#!/bin/sh
# Remove the owner-words hook: its entry in ~/.claude/settings.json, its link
# in ~/.claude/hooks and its cache of typed messages. The other settings stay,
# since the machine may have had them before the install. ccstatus has its
# own uninstaller, which this script names but does not run.
set -eu

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CCSTATUS_HOME="${CCSTATUS_HOME:-$HOME/.local/share/ccstatus}"
HOOK="$CLAUDE_DIR/hooks/owner-words.py"

say() { printf 'claude: %s\n' "$*"; }

SETTINGS="$CLAUDE_DIR/settings.json" python3 - <<'PY'
import json
import os
import stat
import sys
from pathlib import Path

path = Path(os.environ["SETTINGS"])
if not path.exists():
    sys.exit(0)
settings = json.loads(path.read_text())
hooks = settings.get("hooks", {})
removed = 0
for event in list(hooks):
    kept = []
    for group in hooks[event]:
        entries = group.get("hooks", [])
        others = [h for h in entries if "owner-words.py" not in h.get("command", "")]
        removed += len(entries) - len(others)
        if others or not entries:
            group["hooks"] = others
            kept.append(group)
    if kept:
        hooks[event] = kept
    else:
        del hooks[event]
if "hooks" in settings and not hooks:
    del settings["hooks"]
if removed:
    real = Path(os.path.realpath(path))
    tmp = real.with_name(f"{real.name}.tmp{os.getpid()}")
    tmp.write_text(json.dumps(settings, indent=2, ensure_ascii=False) + "\n")
    os.chmod(tmp, stat.S_IMODE(real.stat().st_mode))
    os.replace(tmp, real)
    print(f"claude: removed the owner-words hook from {path}")
PY

if [ -L "$HOOK" ]; then
  rm -f "$HOOK"
  say "removed the link $HOOK"
elif [ -e "$HOOK" ]; then
  say "left $HOOK in place, since it is a file and not a link to this checkout"
fi
rm -f "$CLAUDE_DIR/hooks/owner-words.cache.json" "$CLAUDE_DIR/hooks/owner-words.cache.tmp"*
say "removed the cache of typed messages"
if [ -x "$CCSTATUS_HOME/uninstall.sh" ]; then
  say "the status line stays; $CCSTATUS_HOME/uninstall.sh removes it"
fi
