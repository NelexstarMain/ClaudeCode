#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude"
TARGET_DIR="${CLAUDE_HOME:-$HOME/.claude}"
BACKUP_DIR="$TARGET_DIR/backups/$(date +%Y%m%d_%H%M%S)"

echo "==> Installing Claude Code Hygiene System from $SOURCE_DIR into: $TARGET_DIR"

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 is required in PATH." >&2
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "ERROR: Missing .claude directory at $SOURCE_DIR" >&2
  exit 1
fi

echo "==> Running hook test suite first..."
python3 -m unittest discover -s "$SCRIPT_DIR/tests" -v

mkdir -p "$TARGET_DIR" "$TARGET_DIR/state/sessions" "$TARGET_DIR/state/projects"

backup_if_exists() {
  local rel="$1"
  if [ -e "$TARGET_DIR/$rel" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    cp -a "$TARGET_DIR/$rel" "$BACKUP_DIR/$rel"
    echo "    Backed up existing $rel -> $BACKUP_DIR/$rel"
  fi
}

backup_if_exists "CLAUDE.md"
backup_if_exists "preferences.md"
backup_if_exists "settings.json"

cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
cp "$SOURCE_DIR/preferences.md" "$TARGET_DIR/preferences.md"
cp "$SOURCE_DIR/settings.json" "$TARGET_DIR/settings.json"

rm -rf "$TARGET_DIR/rules" "$TARGET_DIR/hygiene" "$TARGET_DIR/hooks" "$TARGET_DIR/agents"
cp -r "$SOURCE_DIR/rules" "$TARGET_DIR/rules"
cp -r "$SOURCE_DIR/hygiene" "$TARGET_DIR/hygiene"
cp -r "$SOURCE_DIR/hooks" "$TARGET_DIR/hooks"
cp -r "$SOURCE_DIR/agents" "$TARGET_DIR/agents"

mkdir -p "$TARGET_DIR/skills"
for skill_dir in "$SOURCE_DIR"/skills/*; do
  skill_name="$(basename "$skill_dir")"
  rm -rf "$TARGET_DIR/skills/$skill_name"
  cp -r "$skill_dir" "$TARGET_DIR/skills/$skill_name"
done

chmod +x "$TARGET_DIR"/hooks/*.py

echo "==> Installation complete!"
echo "    - Global config:  $TARGET_DIR/CLAUDE.md"
echo "    - Preferences:    $TARGET_DIR/preferences.md (max 70 lines)"
echo "    - Settings/Hooks: $TARGET_DIR/settings.json"
echo "    - Skills:         core-kickoff, core-subagents, core-tests, core-memory, core-hygiene, core-wrapup, csharp"
echo "    - Run 'claude' in any project and start with /core-kickoff."
