#!/usr/bin/env python3
"""Refuses outgoing text that repeats the owner's own words.

Claude Code runs this as a PreToolUse hook. It collects every message the
owner typed in this project's sessions (the main transcripts next to the
hook input's transcript_path, never subagents' transcripts, tool results,
system text or pasted blocks) and blocks a tool call whose outgoing text
shares a run of RUN or more words with one of them:

  Bash          git commit, tag or merge, gh pr/issue/release create, edit,
                comment, review or merge, and gh api; the command line plus
                any message file it names with -F, --file, --body-file,
                --notes-file or --input, or as gh api's -F field=@FILE
  Write         the content, less the runs the file already had
  Edit          new_string, less the runs in old_string
  MultiEdit     every new_string, less the runs in the old_strings
  NotebookEdit  new_source
  Agent         the prompt
  SendMessage   the message

Outside the memory directory it also blocks a new sentence that reports
what the owner asked, said or framed ("the owner asked why…"), since that
retells the conversation instead of saying what the change does. Curly
apostrophes count as straight ones, and a phrase the replaced text already
had passes.

It exits 2 with the repeated runs on stderr, which blocks the call and
tells Claude what to rewrite. The cache of typed messages lives next to
the installed hook, in $CLAUDE_CONFIG_DIR/hooks (~/.claude/hooks by
default), and only its owner can read it.

    owner-words.py --scan FILE...   lists repeated runs in existing files
"""

import json
import os
import re
import sys
from collections import Counter
from pathlib import Path

RUN = 5
CLAUDE_DIR = Path(os.path.expanduser(os.environ.get("CLAUDE_CONFIG_DIR") or "~/.claude"))
CACHE = CLAUDE_DIR / "hooks" / "owner-words.cache.json"
MEMORY = CLAUDE_DIR / "projects"
TRIM = "'\"`*_~()[]{}<>.,;:!?«»“”‘’…-–—/\\|#="

OUTWARD = re.compile(
    r"\bgit\b[^|;&\n]*\b(commit|tag|merge)\b"
    r"|\bgh\s+(pr|issue|release)\s+(create|edit|comment|review|merge)\b"
    r"|\bgh\s+api\b"
)
# Matched against text whose curly apostrophes were made straight.
RETOLD = re.compile(
    r"\b(?:project )?owner(?:'s)?\s*(?:\([^)\n]*\)\s*)?,?\s+"
    r"(?:asked|asks|said|says|wrote|writes|told|tells|wanted|wants|requested|requests"
    r"|insisted|insists|rejected|rejects|pointed\s+out|points\s+out|emphasi[sz]e[sd]"
    r"|reaffirmed|stressed|stresses|suggested|suggests|prefers|preferred|noted"
    r"|mentioned|complained|objected|flagged|decided)\b"
    r"|\bowner's\s+(?:framing|words|wording|question|questions|instruction|instructions"
    r"|comment|comments|plan|request|requests|ask|feedback|preference|preferences"
    r"|concern|concerns|wish|wishes)\b"
    r"|\bas the owner\s+(?:asked|said|wanted|wrote|requested|suggested|put it)\b",
    re.I,
)
# git commit -F FILE, gh --body-file FILE, gh api -F field=@FILE, gh api --input FILE
MESSAGE_FILE = re.compile(
    r"(?:\s-F|--file|--body-file|--notes-file|--field|--input)[\s=]+(['\"]?)([^\s'\"]+)\1"
)

NOT_TYPED = [
    re.compile(r"<system-reminder>.*?</system-reminder>", re.S),
    re.compile(r"<pasted_content\b[^>]*>.*?</pasted_content\b[^>]*>", re.S),
    re.compile(
        r"<(command-name|command-message|local-command-stdout|local-command-stderr"
        r"|bash-input|bash-stdout|bash-stderr)>.*?</\1>",
        re.S,
    ),
    re.compile(r"</?command-args>"),
    re.compile(r"\[Request interrupted by user[^\]]*\]"),
]


def straight(text):
    """text with its curly apostrophes made straight."""
    return text.replace("’", "'").replace("‘", "'")


def tokens(text):
    """Lower-cased words with their surrounding punctuation trimmed, each
    paired with the word as written."""
    out = []
    for raw in text.split():
        word = straight(raw).lower().strip(TRIM)
        if word:
            out.append((word, raw))
    return out


def runs(words):
    return {tuple(words[i : i + RUN]) for i in range(len(words) - RUN + 1)}


def typed_text(entry):
    """The owner's typed text in a transcript entry, or None."""
    if entry.get("type") != "user" or entry.get("isSidechain"):
        return None
    origin = entry.get("origin")
    if not isinstance(origin, dict) or origin.get("kind") != "human":
        return None
    content = entry.get("message", {}).get("content")
    if isinstance(content, list):
        content = "\n".join(b.get("text", "") for b in content if b.get("type") == "text")
    if not isinstance(content, str):
        return None
    for pattern in NOT_TYPED:
        content = pattern.sub(" ", content)
    content = content.strip()
    return content or None


def project_dir(transcript_path):
    parts = Path(transcript_path).parts
    if "projects" in parts:
        i = parts.index("projects")
        if len(parts) > i + 1:
            return Path(*parts[: i + 2])
    return Path(transcript_path).parent


def owner_messages(transcript_path):
    """Every typed message in the project's main transcripts. Transcripts
    only grow, so each run reads just the bytes added since the last. The
    cache holds every project the hook has run in; only this one counts."""
    if not transcript_path:
        return []
    here = project_dir(transcript_path)
    try:
        cache = json.loads(CACHE.read_text())
    except (OSError, ValueError):
        cache = {}
    files = cache.setdefault("files", {})
    changed = False
    for path in sorted(here.glob("*.jsonl")):
        st = path.stat()
        rec = files.get(str(path))
        if not rec or rec.get("ino") != st.st_ino or rec.get("offset", 0) > st.st_size:
            rec = {"ino": st.st_ino, "offset": 0, "texts": []}
        if rec["offset"] < st.st_size:
            with open(path, "rb") as f:
                f.seek(rec["offset"])
                data = f.read()
            end = data.rfind(b"\n") + 1
            for line in data[:end].splitlines():
                if b'"human"' not in line:
                    continue
                try:
                    text = typed_text(json.loads(line))
                except ValueError:
                    continue
                if text:
                    rec["texts"].append(text)
            rec["offset"] += end
            changed = True
        files[str(path)] = rec
    if changed:
        CACHE.parent.mkdir(parents=True, exist_ok=True)
        tmp = CACHE.with_suffix(".tmp%d" % os.getpid())
        tmp.write_text(json.dumps(cache))
        os.chmod(tmp, 0o600)
        os.replace(tmp, CACHE)
    return [t for key, rec in files.items() if Path(key).parent == here for t in rec["texts"]]


def outgoing(tool, inp):
    """(new text, text it replaces) for a tool call, or None to let it pass."""
    if tool == "Bash":
        cmd = inp.get("command", "")
        if not OUTWARD.search(cmd):
            return None
        parts = [cmd]
        for _, name in MESSAGE_FILE.findall(cmd):
            if "=" in name:  # gh api -F field=@FILE; any other field is inline
                if "=@" not in name:
                    continue
                name = name.split("=@", 1)[1]
            p = Path(os.path.expanduser(name))
            if not p.is_absolute():
                p = Path(inp.get("_cwd", ".")) / p
            try:
                if p.is_file() and p.stat().st_size < 1 << 20:
                    parts.append(p.read_text(errors="replace"))
            except OSError:
                pass
        return "\n".join(parts), ""
    if tool == "Write":
        old = ""
        try:
            p = Path(inp.get("file_path", ""))
            if p.is_file() and p.stat().st_size < 4 << 20:
                old = p.read_text(errors="replace")
        except OSError:
            pass
        return inp.get("content", ""), old
    if tool == "Edit":
        return inp.get("new_string", ""), inp.get("old_string", "")
    if tool == "MultiEdit":
        edits = inp.get("edits", [])
        return (
            "\n".join(e.get("new_string", "") for e in edits),
            "\n".join(e.get("old_string", "") for e in edits),
        )
    if tool == "NotebookEdit":
        return inp.get("new_source", ""), ""
    if tool == "Agent":
        return inp.get("prompt", ""), ""
    if tool == "SendMessage":
        msg = inp.get("message", "")
        return (msg if isinstance(msg, str) else json.dumps(msg)), ""
    return None


def repeated(text, old, owner):
    """The spans of text, as written, that repeat RUN or more of the owner's
    words in a row and that old didn't already contain."""
    said = set()
    for message in owner:
        said |= runs([w for w, _ in tokens(message)])
    had = runs([w for w, _ in tokens(old)])
    toks = tokens(text)
    words = [w for w, _ in toks]
    hit = [False] * len(toks)
    for i in range(len(words) - RUN + 1):
        gram = tuple(words[i : i + RUN])
        if gram in said and gram not in had:
            for j in range(i, i + RUN):
                hit[j] = True
    spans, cur = [], []
    for (_, raw), h in zip(toks, hit):
        if h:
            cur.append(raw)
        elif cur:
            spans.append(" ".join(cur))
            cur = []
    if cur:
        spans.append(" ".join(cur))
    return spans


def retold(text, old):
    """The phrases in text that report what the owner asked or said, less as
    many of each as old already had."""
    had = Counter(" ".join(m.group(0).lower().split()) for m in RETOLD.finditer(straight(old)))
    told = []
    for m in RETOLD.finditer(straight(text)):
        key = " ".join(m.group(0).lower().split())
        if had[key]:
            had[key] -= 1
        else:
            told.append(m.group(0))
    return told


def scan(paths):
    owner = owner_messages(str(MEMORY / project_key() / "x.jsonl"))
    found = 0
    for name in paths:
        try:
            text = Path(name).read_text(errors="replace")
        except OSError as e:
            print(f"{name}: {e}", file=sys.stderr)
            continue
        for span in repeated(text, "", owner):
            found += 1
            print(f"{name}: {span}")
    return 1 if found else 0


def project_key():
    return re.sub(r"[^A-Za-z0-9]", "-", os.environ.get("OWNER_WORDS_PROJECT", os.getcwd()))


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--scan":
        return scan(sys.argv[2:])
    hook = json.load(sys.stdin)
    inp = dict(hook.get("tool_input") or {})
    inp["_cwd"] = hook.get("cwd", ".")
    tool = hook.get("tool_name", "")
    out = outgoing(tool, inp)
    if not out or not out[0].strip():
        return 0
    text, old = out
    problems = []
    spans = repeated(text, old, owner_messages(hook.get("transcript_path", "")))
    if spans:
        problems.append(
            "It repeats the owner's own words:\n" + "\n".join(f"  - {s}" for s in spans[:5])
        )
    path = inp.get("file_path") or ""
    in_memory = "/memory/" in path and MEMORY in Path(path).parents
    if not in_memory:
        told = retold(text, old)
        if told:
            problems.append(
                "It retells what the owner asked or said:\n" + "\n".join(f"  - {s}" for s in told[:5])
            )
    if not problems:
        return 0
    print(
        "Blocked: commits, PRs, issues, docs, specs, memory and agent briefs\n"
        "say what the change does, never what the owner said.\n"
        + "\n".join(problems)
        + "\nRewrite it in your own words, describing the change or the rule.\n"
        "Don't restate the request, and don't quote or closely paraphrase it.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:  # a broken check must not block all work
        print(f"owner-words hook failed: {e!r}", file=sys.stderr)
        sys.exit(1)
