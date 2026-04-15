#!/bin/bash
# imagine.io Claude Skills Installer
# Copies all imagineio skills to ~/.claude/skills/imagineio/
# Run once per machine: ./install.sh

set -e

SKILLS_SRC="$(dirname "$0")/.claude/skills/imagineio"
SKILLS_DST="$HOME/.claude/skills/imagineio"

if [ ! -d "$SKILLS_SRC" ]; then
  echo "Error: skills source directory not found at $SKILLS_SRC"
  exit 1
fi

mkdir -p "$SKILLS_DST"
cp -r "$SKILLS_SRC/"* "$SKILLS_DST/"

echo "imagine.io skills installed to $SKILLS_DST"
echo ""
echo "Available skills:"
for skill_dir in "$SKILLS_DST"/*/; do
  skill_name=$(basename "$skill_dir")
  echo "  /imagineio:$skill_name"
done
echo ""
echo "Restart Claude Code to pick up the new skills."
