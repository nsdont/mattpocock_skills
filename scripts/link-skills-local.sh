#!/usr/bin/env bash
set -euo pipefail

# Fork-local wrapper around scripts/link-skills.sh. That script is upstream
# owned and says modifications to it will not be approved, so this fork keeps
# its extras in a separate file instead of editing it.
#
# On top of the upstream behaviour this script:
#   - mirrors the same links into ~/.gemini/config/skills, the global skills
#     dir used by the Antigravity CLI (agy)
#   - prunes stale links in all three dirs: skills that moved into misc/ or
#     deprecated/, and links into this repo whose target no longer exists
#     (a renamed or removed skill)
# The link set is read back out of ~/.agents/skills rather than recomputed, so
# the upstream filter rules stay the single source of truth.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$HOME/.agents/skills"
AGY_DIR="$HOME/.gemini/config/skills"

bash "$REPO/scripts/link-skills.sh"

for dir in "$HOME/.claude/skills" "$AGENTS_DIR" "$AGY_DIR"; do
  [ -d "$dir" ] || continue
  for entry in "$dir"/*; do
    [ -L "$entry" ] || continue
    target="$(readlink "$entry")"
    case "$target" in
      "$REPO"/skills/misc/*|"$REPO"/skills/deprecated/*) ;;
      "$REPO"/skills/*)
        if [ -e "$entry" ]; then continue; fi
        ;;
      *) continue ;;
    esac
    rm "$entry"
    echo "removed stale $entry -> $target"
  done
done

mkdir -p "$AGY_DIR"
for entry in "$AGENTS_DIR"/*; do
  [ -L "$entry" ] || continue
  target="$(readlink "$entry")"
  case "$target" in
    "$REPO"/skills/*) ;;
    *) continue ;;
  esac
  name="$(basename "$entry")"
  ln -sfn "$target" "$AGY_DIR/$name"
  echo "linked $name -> $target ($AGY_DIR)"
done
