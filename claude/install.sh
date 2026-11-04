#!/bin/sh
# Set up Claude Code on this machine: link the owner-words hook into
# ~/.claude/hooks, merge settings.json from this directory into
# ~/.claude/settings.json, and install the ccstatus status line.
#
#   sh claude/install.sh
#
# from a checkout of this repository, or on a new machine:
#
#   curl -fsSL https://raw.githubusercontent.com/changkun/dotfiles/main/claude/install.sh | sh
#
# which clones the repository into $DOTFILES (~/dev/changkun.de/dotfiles by
# default) and runs the installer from there. The merge only adds what is
# missing, so running it again changes nothing. CLAUDE_CONFIG_DIR and
# CCSTATUS_HOME move the install as they do for Claude Code and ccstatus;
# CCSTATUS_SRC installs ccstatus from a checkout instead of from GitHub.
set -eu

DOTFILES_URL="https://github.com/changkun/dotfiles.git"
CCSTATUS_URL="https://raw.githubusercontent.com/changkun/ccstatus/main/install.sh"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CCSTATUS_HOME="${CCSTATUS_HOME:-$HOME/.local/share/ccstatus}"
export CCSTATUS_HOME

say() { printf 'claude: %s\n' "$*"; }
die() { printf 'claude: %s\n' "$*" >&2; exit 1; }

command -v python3 >/dev/null 2>&1 || die "python3 is required."

# A checkout next to this script installs from there; a piped install clones.
HERE=""
if [ -f "$0" ]; then
  HERE="$(cd "$(dirname "$0")" && pwd)"
  [ -f "$HERE/hooks/owner-words.py" ] || HERE=""
fi
if [ -z "$HERE" ]; then
  DOTFILES="${DOTFILES:-$HOME/dev/changkun.de/dotfiles}"
  if [ ! -e "$DOTFILES" ]; then
    command -v git >/dev/null 2>&1 || die "git is required to install from the network."
    say "cloning into $DOTFILES"
    mkdir -p "$(dirname "$DOTFILES")"
    git clone --quiet "$DOTFILES_URL" "$DOTFILES"
  fi
  [ -f "$DOTFILES/claude/install.sh" ] || die "$DOTFILES has no claude/install.sh; pull it and run again."
  exec sh "$DOTFILES/claude/install.sh"
fi

# 1. The hook, as a link, so a pull updates it.
HOOK_SRC="$HERE/hooks/owner-words.py"
HOOK="$CLAUDE_DIR/hooks/owner-words.py"
mkdir -p "$CLAUDE_DIR/hooks"
if [ -L "$HOOK" ] && [ "$(readlink "$HOOK")" = "$HOOK_SRC" ]; then
  say "$HOOK already links to $HOOK_SRC"
else
  if [ -L "$HOOK" ] || { [ -f "$HOOK" ] && cmp -s "$HOOK" "$HOOK_SRC"; }; then
    rm -f "$HOOK"
  elif [ -e "$HOOK" ]; then
    mv "$HOOK" "$HOOK.bak"
    say "moved the previous $HOOK to $HOOK.bak"
  fi
  ln -s "$HOOK_SRC" "$HOOK"
  say "linked $HOOK to $HOOK_SRC"
fi

# 2. The settings, merged so that nothing this machine already has changes.
SETTINGS="$CLAUDE_DIR/settings.json" PORTABLE="$HERE/settings.json" HOOK="$HOOK" python3 - <<'PY'
import json
import os
import shlex
import stat
import sys
from pathlib import Path

path = Path(os.environ["SETTINGS"])
portable = json.loads(Path(os.environ["PORTABLE"]).read_text())
hook = os.environ["HOOK"]

raw = path.read_text() if path.exists() else ""
try:
    settings = json.loads(raw) if raw.strip() else {}
except ValueError:
    settings = None
if not isinstance(settings, dict):
    sys.exit(f"claude: {path} is not a JSON object; fix it and run again.")

added = []


def merge(have, want, where):
    """Adds the keys and array entries of want that have lacks. A value
    already set in have is kept, even when want sets another."""
    for key, value in want.items():
        name = f"{where}.{key}" if where else key
        if key not in have:
            have[key] = value
            added.append(name)
        elif isinstance(have[key], dict) and isinstance(value, dict):
            merge(have[key], value, name)
        elif isinstance(have[key], list) and isinstance(value, list):
            for item in value:
                if item not in have[key]:
                    have[key].append(item)
                    added.append(f"{name}[]")


def script(command):
    """The file name of the script a hook command runs."""
    return Path(shlex.split(command)[-1]).name


# A hook counts as installed when some entry already runs its script, so a
# matcher or timeout tuned on this machine is not added a second time.
for event, groups in portable.pop("hooks", {}).items():
    for group in groups:
        for h in group["hooks"]:
            if hook != os.path.expanduser("~/.claude/hooks/owner-words.py"):
                h["command"] = h["command"].replace("~/.claude/hooks/owner-words.py", shlex.quote(hook))
        have = settings.setdefault("hooks", {}).setdefault(event, [])
        running = " ".join(
            h.get("command", "")
            for g in have if isinstance(g, dict)
            for h in g.get("hooks", []) if isinstance(h, dict)
        )
        if all(script(h["command"]) in running for h in group["hooks"]):
            continue
        have.append(group)
        added.append(f"hooks.{event}[{group.get('matcher', '')}]")

merge(settings, portable, "")

if not added:
    print(f"claude: {path} already has every setting")
    sys.exit(0)
backup = path.with_name(path.name + ".dotfiles-backup")
if raw and not backup.exists():
    backup.write_text(raw)
    print(f"claude: kept the settings from before the first install at {backup}")
real = Path(os.path.realpath(path))
real.parent.mkdir(parents=True, exist_ok=True)
tmp = real.with_name(f"{real.name}.tmp{os.getpid()}")
tmp.write_text(json.dumps(settings, indent=2, ensure_ascii=False) + "\n")
if real.exists():
    os.chmod(tmp, stat.S_IMODE(real.stat().st_mode))
os.replace(tmp, real)
for name in added:
    print(f"claude: added {name} to {path}")
PY

# 3. The status line, from ccstatus's own installer.
status=0
current=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1])).get("statusLine", {}).get("command", ""))' \
  "$CLAUDE_DIR/settings.json" 2>/dev/null || true)
case "$current" in
  *ccstatus*) installed=$([ -f "$CCSTATUS_HOME/bin/ccstatus.mjs" ] && echo yes || true) ;;
  *) installed="" ;;
esac
if [ -n "$installed" ]; then
  say "ccstatus is already installed in $CCSTATUS_HOME; its install.sh updates it"
elif [ -n "${CCSTATUS_SRC:-}" ]; then
  sh "$CCSTATUS_SRC/install.sh" || status=1
elif ! command -v curl >/dev/null 2>&1; then
  say "curl is required to fetch ccstatus" >&2
  status=1
elif script=$(curl -fsSL "$CCSTATUS_URL"); then
  sh -c "$script" || status=1
else
  status=1
fi
[ "$status" -eq 0 ] || say "the status line was not installed; the hook and the settings were" >&2
exit "$status"
