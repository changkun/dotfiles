#!/bin/sh
# Rehearses claude/install.sh and claude/uninstall.sh in temporary HOMEs,
# with a stand-in for ccstatus's installer, so nothing outside the temporary
# directory changes and no network is needed.
#
#   sh claude/test/install-test.sh
set -eu
unset CLAUDE_CONFIG_DIR CCSTATUS_HOME DOTFILES

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
T="$(mktemp -d "${TMPDIR:-/tmp}/claude-install-test.XXXXXX")"
trap 'rm -rf "$T"' EXIT
failed=0
passed=0

ok() { passed=$((passed + 1)); printf 'ok    %s\n' "$1"; }
bad() { failed=$((failed + 1)); printf 'FAIL  %s\n' "$1"; }
# is NAME SETTINGS PYTHON-EXPRESSION: s is the parsed settings file
is() {
  if python3 -c "import json, sys; s = json.load(open(sys.argv[1])); sys.exit(0 if ($3) else 1)" "$2" 2>/dev/null; then
    ok "$1"
  else
    bad "$1"
  fi
}
same() { if cmp -s "$2" "$3"; then ok "$1"; else bad "$1"; diff "$2" "$3" | sed 's/^/        /'; fi; }
runs() { if [ "$("$@" >"$T/out" 2>&1; echo $?)" = 0 ]; then return 0; fi; sed 's/^/        /' "$T/out"; return 1; }
install() { HOME="$1" CCSTATUS_SRC="$T/ccstatus" sh "$ROOT/install.sh"; }

OURS='[h["command"] for g in s["hooks"]["PreToolUse"] for h in g["hooks"] if "owner-words.py" in h["command"]]'

# Stands in for ccstatus's install.sh: marks itself installed and points the
# status line at itself, as the real one does.
mkdir -p "$T/ccstatus"
cat >"$T/ccstatus/install.sh" <<'EOF'
set -eu
mkdir -p "$CCSTATUS_HOME/bin"
: >"$CCSTATUS_HOME/bin/ccstatus.mjs"
echo ran >>"$CCSTATUS_HOME/runs"
python3 - "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json" "$CCSTATUS_HOME" <<'PY'
import json, sys
path, home = sys.argv[1], sys.argv[2]
s = json.load(open(path))
s["statusLine"] = {"type": "command", "command": f'"{home}/bin/ccstatus.mjs"'}
open(path, "w").write(json.dumps(s, indent=2, ensure_ascii=False) + "\n")
PY
EOF

echo "== a machine with no Claude Code settings"
H="$T/fresh"; S="$H/.claude/settings.json"
if runs install "$H"; then ok "install succeeds"; else bad "install succeeds"; fi
if [ "$(readlink "$H/.claude/hooks/owner-words.py")" = "$ROOT/hooks/owner-words.py" ]; then
  ok "hook linked to the checkout"
else
  bad "hook linked to the checkout"
fi
is "hook registered once" "$S" "$OURS == ['python3 ~/.claude/hooks/owner-words.py']"
is "hook matcher and timeout" "$S" \
  's["hooks"]["PreToolUse"][0]["matcher"] == "Bash|Write|Edit|MultiEdit|NotebookEdit|Agent|SendMessage" and s["hooks"]["PreToolUse"][0]["hooks"][0]["timeout"] == 30'
is "empty attribution" "$S" 's["attribution"] == {"commit": "", "pr": ""}'
is "env and cleanup period" "$S" 's["env"]["CLAUDE_CODE_SUPPRESS_SESSION_ATTRIBUTION"] == "1" and s["cleanupPeriodDays"] == 99999'
is "plugins and marketplaces" "$S" 's["enabledPlugins"]["spec@latere-ai"] and s["extraKnownMarketplaces"]["latere-ai"]["source"]["repo"] == "latere-ai/agent-skills"'
is "status line from ccstatus" "$S" '"ccstatus" in s["statusLine"]["command"]'
cp "$S" "$T/fresh-1"
runs install "$H" >/dev/null || bad "second install succeeds"
same "second install changes nothing" "$T/fresh-1" "$S"
if [ "$(wc -l <"$H/.local/share/ccstatus/runs")" -eq 1 ]; then ok "ccstatus installer ran once"; else bad "ccstatus installer ran once"; fi

echo "== a machine with settings of its own"
H="$T/tuned"; S="$H/.claude/settings.json"
mkdir -p "$H/.claude/hooks"
cat >"$S" <<'EOF'
{
  "model": "opus",
  "env": {"FOO": "1"},
  "attribution": {"commit": "Made here"},
  "cleanupPeriodDays": 30,
  "permissions": {"allow": ["Bash(ls:*)"]},
  "enabledPlugins": {"other@somewhere": true, "spec@latere-ai": false},
  "hooks": {
    "PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "echo pre"}]}],
    "Stop": [{"hooks": [{"type": "command", "command": "echo stop"}]}]
  },
  "statusLine": {"type": "command", "command": "echo mine"}
}
EOF
cp "$S" "$T/tuned-0"
echo "an older copy" >"$H/.claude/hooks/owner-words.py"
runs install "$H" >/dev/null || bad "install succeeds"
is "keys it had are kept" "$S" 's["model"] == "opus" and s["permissions"] == {"allow": ["Bash(ls:*)"]}'
is "values it had win" "$S" 's["attribution"]["commit"] == "Made here" and s["cleanupPeriodDays"] == 30 and s["enabledPlugins"]["spec@latere-ai"] is False'
is "missing nested keys are added" "$S" 's["attribution"]["pr"] == "" and s["env"] == {"FOO": "1", "CLAUDE_CODE_SUPPRESS_SESSION_ATTRIBUTION": "1"} and s["enabledPlugins"]["other@somewhere"] and s["enabledPlugins"]["ci@latere-ai"]'
is "its own hooks are kept" "$S" 's["hooks"]["PreToolUse"][0]["hooks"][0]["command"] == "echo pre" and s["hooks"]["Stop"][0]["hooks"][0]["command"] == "echo stop"'
is "hook appended once" "$S" "len($OURS) == 1 and len(s['hooks']['PreToolUse']) == 2"
same "backup of the settings before the install" "$T/tuned-0" "$S.dotfiles-backup"
if grep -q "an older copy" "$H/.claude/hooks/owner-words.py.bak" && [ -L "$H/.claude/hooks/owner-words.py" ]; then
  ok "a different hook file is kept as .bak"
else
  bad "a different hook file is kept as .bak"
fi
cp "$S" "$T/tuned-1"
runs install "$H" >/dev/null || bad "second install succeeds"
same "second install changes nothing" "$T/tuned-1" "$S"

echo "== uninstall"
: >"$H/.claude/hooks/owner-words.cache.json"
if runs env HOME="$H" sh "$ROOT/uninstall.sh"; then ok "uninstall succeeds"; else bad "uninstall succeeds"; fi
is "hook entry removed" "$S" "len(s['hooks']['PreToolUse']) == 1 and $OURS == []"
is "other hooks and settings stay" "$S" 's["hooks"]["Stop"] and s["model"] == "opus" and s["attribution"]["pr"] == ""'
if [ ! -e "$H/.claude/hooks/owner-words.py" ] && [ ! -e "$H/.claude/hooks/owner-words.cache.json" ]; then
  ok "link and cache removed"
else
  bad "link and cache removed"
fi

echo "== a hook entry tuned on this machine"
H="$T/hooked"; S="$H/.claude/settings.json"
mkdir -p "$H/.claude"
cat >"$S" <<'EOF'
{"hooks": {"PreToolUse": [{"matcher": "Bash|Write", "hooks": [{"type": "command", "command": "python3 ~/.claude/hooks/owner-words.py", "timeout": 60}]}]}}
EOF
runs install "$H" >/dev/null || bad "install succeeds"
is "not added a second time" "$S" "len($OURS) == 1 and s['hooks']['PreToolUse'][0]['hooks'][0]['timeout'] == 60"

echo "== settings that are not JSON"
H="$T/broken"; S="$H/.claude/settings.json"
mkdir -p "$H/.claude"
printf '{"model": "opus",\n' >"$S"
cp "$S" "$T/broken-0"
if install "$H" >/dev/null 2>&1; then bad "install refuses"; else ok "install refuses"; fi
same "file left alone" "$T/broken-0" "$S"

echo "== CLAUDE_CONFIG_DIR"
H="$T/config"; C="$H/elsewhere"
if runs env HOME="$H" CLAUDE_CONFIG_DIR="$C" CCSTATUS_SRC="$T/ccstatus" sh "$ROOT/install.sh"; then
  ok "install succeeds"
else
  bad "install succeeds"
fi
is "hook runs from CLAUDE_CONFIG_DIR" "$C/settings.json" "$OURS == ['python3 $C/hooks/owner-words.py']"
if [ -L "$C/hooks/owner-words.py" ] && [ ! -e "$H/.claude" ]; then ok "nothing written to ~/.claude"; else bad "nothing written to ~/.claude"; fi

echo "== piped from curl"
H="$T/piped"
if runs env HOME="$H" DOTFILES="$(dirname "$ROOT")" CCSTATUS_SRC="$T/ccstatus" sh <"$ROOT/install.sh"; then
  ok "install from a checkout named by DOTFILES"
else
  bad "install from a checkout named by DOTFILES"
fi
is "hook registered" "$H/.claude/settings.json" "len($OURS) == 1"

printf '%s passed, %s failed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]
