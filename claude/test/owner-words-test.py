#!/usr/bin/env python3
"""Pipe tests for the owner-words hook.

    python3 claude/test/owner-words-test.py [HOOK]

HOOK defaults to claude/hooks/owner-words.py in this checkout; pass
~/.claude/hooks/owner-words.py to test the installed one. Each case pipes
one PreToolUse input into the hook and checks its exit code: 2 blocks the
call, 0 lets it pass. The transcripts are synthetic and live in a temporary
HOME, so neither the real transcripts nor the real cache are read.
"""

import json
import os
import shutil
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

HOOK = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 else (
    Path(__file__).resolve().parent.parent / "hooks" / "owner-words.py"
)

# Typed in the demo project's main transcript.
LLAMA = "please teach the purple llama to dance across the frozen lake"
KETTLE = "the copper kettle whistles a cheerful tune at seven every morning"
LATER = "a quiet lighthouse keeper collects blue sea glass in winter"
# Present in the transcripts but never typed by the owner there.
REMINDER = "violet ostrich swallows seven brass marbles before breakfast"
PASTED = "amber walrus juggles nine glass oranges on the pier"
SIDECHAIN = "silver badger paints tiny blue houses on quiet afternoons"
TOOL_RESULT = "crimson heron counts forty wooden buttons very slowly"
ASSISTANT = "the green teapot sings softly under the pale moon"
SUBAGENT = "golden turtle reads long poems aloud to sleepy owls"
OTHER_PROJECT = "orange fox builds a small wooden boat by the river"

# The reported-speech fixtures are put together from parts, so the hook,
# once installed, does not refuse edits to this file.
OWNER = "owner"


def typed(text):
    return {"type": "user", "origin": {"kind": "human"}, "message": {"role": "user", "content": text}}


def write_jsonl(path, entries, tail=""):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "a") as f:
        for e in entries:
            f.write(json.dumps(e) + "\n")
        f.write(tail)


class Suite:
    def __init__(self, root):
        self.root = root
        self.env = {k: v for k, v in os.environ.items() if k != "CLAUDE_CONFIG_DIR"}
        self.env["HOME"] = str(root)
        self.claude = root / ".claude"
        self.demo = self.claude / "projects" / "-work-demo"
        self.other = self.claude / "projects" / "-work-other"
        self.transcript = self.demo / "s1.jsonl"
        self.memory = self.demo / "memory"
        self.files = root / "work"
        self.files.mkdir(parents=True)
        self.failed = 0
        self.passed = 0

    def run(self, payload, args=(), env=None):
        proc = subprocess.run(
            [sys.executable, str(HOOK), *args],
            input=payload if isinstance(payload, str) else json.dumps(payload),
            capture_output=True,
            text=True,
            env=env or self.env,
            cwd=self.files,
        )
        return proc.returncode, proc.stdout + proc.stderr

    def call(self, tool, tool_input, transcript=None):
        return self.run({
            "tool_name": tool,
            "tool_input": tool_input,
            "transcript_path": str(transcript or self.transcript),
            "cwd": str(self.files),
        })

    def expect(self, name, want, got, output="", contains=None):
        ok = got == want and (contains is None or contains in output)
        if ok:
            self.passed += 1
            print(f"ok    {name}")
        else:
            self.failed += 1
            print(f"FAIL  {name}: got {got!r}, want {want!r}")
            for line in output.strip().splitlines():
                print(f"        {line}")

    def check(self, name, want, tool, tool_input, contains=None, transcript=None):
        code, out = self.call(tool, tool_input, transcript)
        self.expect(name, want, code, out, contains)

    def file(self, name, text):
        p = self.files / name
        p.write_text(text)
        return str(p)


def build(s):
    write_jsonl(s.transcript, [
        typed(LLAMA),
        {"type": "user", "origin": {"kind": "human"},
         "message": {"role": "user", "content": [{"type": "text", "text": KETTLE}]}},
        typed(f"<system-reminder>{REMINDER}</system-reminder> short note"),
        typed(f'<pasted_content id="1">{PASTED}</pasted_content> see above'),
        {**typed(SIDECHAIN), "isSidechain": True},
        {"type": "user", "message": {"role": "user", "content": [
            {"type": "tool_result", "content": TOOL_RESULT}]}},
        {"type": "assistant", "message": {"role": "assistant", "content": [
            {"type": "text", "text": ASSISTANT}]}},
    ])
    write_jsonl(s.demo / "s1" / "subagents" / "agent-1.jsonl", [typed(SUBAGENT)])
    write_jsonl(s.other / "o1.jsonl", [typed(OTHER_PROJECT)])


def word_runs(s):
    agent = lambda prompt: {"prompt": prompt}
    s.check("five typed words in a row", 2, "Agent",
            agent("Then teach the purple llama to dance in the hall."), contains="teach the purple llama to dance")
    s.check("four typed words in a row", 0, "Agent", agent("A purple llama to dance is fine."))
    s.check("case and punctuation do not matter", 2, "Agent", agent("TEACH, the Purple llama: to DANCE!"))
    s.check("typed text given as content blocks", 2, "Agent",
            agent("The copper kettle whistles a cheerful tune here."))
    s.check("system reminder text", 0, "Agent", agent(REMINDER))
    s.check("pasted block", 0, "Agent", agent(PASTED))
    s.check("sidechain message", 0, "Agent", agent(SIDECHAIN))
    s.check("tool result", 0, "Agent", agent(TOOL_RESULT))
    s.check("assistant text", 0, "Agent", agent(ASSISTANT))
    s.check("subagent transcript", 0, "Agent", agent(SUBAGENT))
    s.check("other project, before its cache entry exists", 0, "Agent", agent(OTHER_PROJECT))
    s.check("other project, in its own session", 2, "Agent", agent(OTHER_PROJECT), transcript=s.other / "o1.jsonl")
    s.check("other project, once cached", 0, "Agent", agent(OTHER_PROJECT))

    s.check("Write, new file", 2, "Write", {"file_path": str(s.files / "new.md"), "content": LLAMA})
    had = s.file("had.md", f"Notes.\n{LLAMA}\n")
    s.check("Write, run the file already had", 0, "Write", {"file_path": had, "content": f"More notes.\n{LLAMA}\n"})
    s.check("Edit, run only in new_string", 2, "Edit", {"file_path": had, "old_string": "Notes.", "new_string": KETTLE})
    s.check("Edit, run in old_string too", 0, "Edit",
            {"file_path": had, "old_string": LLAMA, "new_string": LLAMA + " now"})
    s.check("MultiEdit", 2, "MultiEdit", {"file_path": had, "edits": [
        {"old_string": "Notes.", "new_string": "Fine."}, {"old_string": "x", "new_string": KETTLE}]})
    s.check("NotebookEdit", 2, "NotebookEdit", {"notebook_path": str(s.files / "n.ipynb"), "new_source": KETTLE})
    s.check("SendMessage, text", 2, "SendMessage", {"to": "a", "message": KETTLE})
    s.check("SendMessage, structured", 2, "SendMessage", {"to": "a", "message": {"text": KETTLE}})
    s.check("Read is not checked", 0, "Read", {"file_path": had})

    bash = lambda cmd: {"command": cmd}
    s.check("git commit -m", 2, "Bash", bash(f"git commit -m '{LLAMA}'"))
    s.check("git -C dir commit", 2, "Bash", bash(f"git -C /tmp/x commit -m '{LLAMA}'"))
    s.check("git merge -m", 2, "Bash", bash(f"git merge --no-ff topic -m '{LLAMA}'"))
    s.check("git tag -m", 2, "Bash", bash(f"git tag -a v1 -m '{LLAMA}'"))
    s.check("plain echo is not outgoing", 0, "Bash", bash(f"echo '{LLAMA}'"))
    msg = s.file("msg.txt", f"docs: update\n\n{KETTLE}\n")
    s.check("git commit -F FILE", 2, "Bash", bash("git commit -F msg.txt"))
    s.check("gh pr create --body-file", 2, "Bash", bash(f"gh pr create --title t --body-file {msg}"))
    s.check("gh pr merge --body", 2, "Bash", bash(f"gh pr merge 3 --merge --body '{LLAMA}'"))
    s.check("gh issue comment --body", 2, "Bash", bash(f'gh issue comment 9 --body "{KETTLE}"'))
    s.check("gh api -F field=@FILE", 2, "Bash", bash(f"gh api repos/o/r/issues/1/comments -F body=@{msg}"))
    s.check("gh api --input FILE", 2, "Bash", bash("gh api repos/o/r/pulls -X POST --input msg.txt"))
    s.check("gh api -F field=value", 0, "Bash", bash("gh api repos/o/r/issues -F title=hello -F labels=x"))


def retelling(s):
    agent = lambda prompt: {"prompt": prompt}
    s.check("past tense", 2, "Agent", agent(f"Fix the build. The {OWNER} asked for a faster one."))
    s.check("present tense", 2, "Agent", agent(f"The {OWNER} wants shorter lines."))
    s.check("curly apostrophe", 2, "Agent", agent(f"Keep the {OWNER}’s framing in the guide."))
    s.check("straight apostrophe", 2, "Agent", agent(f"Keep the {OWNER}'s framing in the guide."))
    s.check("aside in parentheses", 2, "Agent", agent(f"The {OWNER} (on Tuesday), said it should go."))
    s.check("as ... put it", 2, "Agent", agent(f"As the {OWNER} put it, nothing ships."))
    s.check("plural owners", 0, "Agent", agent(f"The {OWNER}s said nothing."))
    s.check("hook name", 0, "Agent", agent(f"The {OWNER}-words hook refuses such text."))
    s.check("plain description", 0, "Agent", agent("Rename the flag and update the tests."))
    s.check("SendMessage", 2, "SendMessage", {"to": "a", "message": f"the {OWNER} insisted on it"})
    s.check("NotebookEdit", 2, "NotebookEdit",
            {"notebook_path": str(s.files / "n.ipynb"), "new_source": f"# the {OWNER} says so"})

    told = f"The {OWNER} asked for short lines."
    s.check("Write outside memory", 2, "Write", {"file_path": str(s.files / "doc.md"), "content": told})
    s.check("Write into memory", 0, "Write", {"file_path": str(s.memory / "note.md"), "content": told})
    s.check("a directory named memory elsewhere", 2, "Write",
            {"file_path": str(s.files / "memory" / "note.md"), "content": told})
    doc = s.file("doc.md", told + "\n")
    s.check("Edit keeps the phrase old_string had", 0, "Edit",
            {"file_path": doc, "old_string": told, "new_string": told[:-1] + ", always."})
    s.check("Edit keeps it with other case", 0, "Edit",
            {"file_path": doc, "old_string": told, "new_string": told.lower()})
    s.check("Edit adds a second one", 2, "Edit",
            {"file_path": doc, "old_string": told, "new_string": told + " " + told})
    s.check("Write keeps the file's own phrase", 0, "Write", {"file_path": doc, "content": told + "\nMore.\n"})

    bash = lambda cmd: {"command": cmd}
    s.check("commit message", 2, "Bash", bash(f"git commit -m 'docs: the {OWNER} wanted shorter lines'"))
    s.check("plain echo is not outgoing", 0, "Bash", bash(f"echo the {OWNER} said hi"))
    s.check("gh api owner field", 0, "Bash",
            bash(f"gh api graphql -f query='{{repository({OWNER}: \"x\", name: \"y\") {{id}}}}' -F {OWNER}=x"))


def cache(s):
    path = s.claude / "hooks" / "owner-words.cache.json"
    mode = stat.S_IMODE(path.stat().st_mode) if path.exists() else None
    s.expect("cache is private to its owner", 0o600, mode)
    s.check("message added after the cache was built", 0, "Agent", {"prompt": LATER})
    write_jsonl(s.transcript, [], tail=json.dumps(typed(LATER)))
    s.check("half-written last line is not read yet", 0, "Agent", {"prompt": LATER})
    write_jsonl(s.transcript, [], tail="\n")
    s.check("finished line is read", 2, "Agent", {"prompt": LATER})
    entries = json.loads(path.read_text())["files"]
    s.expect("subagent transcripts are never cached", 0,
             sum("subagents" in k for k in entries))

    alt = s.root / "alt-config"
    env = {**s.env, "CLAUDE_CONFIG_DIR": str(alt)}
    payload = {"tool_name": "Agent", "tool_input": {"prompt": LLAMA},
               "transcript_path": str(s.transcript), "cwd": str(s.files)}
    code, out = s.run(payload, env=env)
    s.expect("CLAUDE_CONFIG_DIR moves the cache", 2, code, out)
    s.expect("cache written under CLAUDE_CONFIG_DIR", True, (alt / "hooks" / "owner-words.cache.json").exists())

    code, out = s.run({"tool_name": "Agent", "tool_input": {"prompt": LLAMA}, "cwd": str(s.files)})
    s.expect("no transcript_path", 0, code, out)
    code, out = s.run("not json")
    s.expect("a broken input fails open", 1, code, out)


def scan(s):
    env = {**s.env, "OWNER_WORDS_PROJECT": "/work/demo"}
    dirty = s.file("dirty.md", f"Intro.\n{KETTLE}\n")
    clean = s.file("clean.md", "Nothing to see.\n")
    code, out = s.run("", args=("--scan", dirty, clean), env=env)
    s.expect("--scan reports a repeated run", 1, code, out, contains="copper kettle whistles a cheerful tune")
    code, out = s.run("", args=("--scan", clean), env=env)
    s.expect("--scan passes a clean file", 0, code, out)


def main():
    if not HOOK.is_file():
        print(f"no hook at {HOOK}", file=sys.stderr)
        return 1
    print(f"testing {HOOK}")
    root = Path(tempfile.mkdtemp(prefix="owner-words-test."))
    try:
        s = Suite(root)
        build(s)
        word_runs(s)
        retelling(s)
        cache(s)
        scan(s)
    finally:
        shutil.rmtree(root, ignore_errors=True)
    print(f"{s.passed} passed, {s.failed} failed")
    return 1 if s.failed else 0


if __name__ == "__main__":
    sys.exit(main())
