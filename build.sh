#!/usr/bin/env bash
# Build the uploadable skill archive.
#
# Produces dist/canvas-review.zip, whose root is the canvas-review/ folder itself —
# that shape is what claude.ai -> Customize -> Skills expects.
set -euo pipefail

cd "$(dirname "$0")"

SKILL_NAME="canvas-review"
OUT="dist/${SKILL_NAME}.zip"

if [ ! -f "skill/${SKILL_NAME}/SKILL.md" ]; then
  echo "error: skill/${SKILL_NAME}/SKILL.md not found" >&2
  exit 1
fi

mkdir -p dist
rm -f "$OUT"

# Zip from inside skill/ so the archive root is the skill folder, not its parent.
# .claude-plugin/ is for the Claude Code plugin track and is not part of the skill upload.
(
  cd skill
  zip -r -q "../${OUT}" "${SKILL_NAME}" \
    -x "*/.DS_Store" \
    -x "*/.claude-plugin/*"
)

echo "built ${OUT}"
echo
unzip -l "$OUT"
