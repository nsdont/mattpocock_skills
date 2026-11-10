#!/usr/bin/env bash
set -euo pipefail

# Fork-local: push this fork's skills into the dotfiles repo, which is what
# Claude Code actually loads (~/.claude/skills is rendered from
# ~/.dotfiles/common/claude/skills by `dotfiles apply`, not linked to this
# clone). The fork is the single source of truth; never edit the dotfiles copy.
#
# Which skills are synced is the manifest common/claude/mattpocock-skills.txt
# in the dotfiles repo (one name per line). `dotfiles check` diffs exactly that
# set against this clone, so drift in either direction shows up there.
#
#   scripts/sync-to-dotfiles.sh             sync every skill in the manifest
#   scripts/sync-to-dotfiles.sh --add NAME  also start syncing NAME (new skill)
#
# A manifest skill that no longer exists here (removed or retired upstream) is
# deleted from dotfiles and dropped from the manifest. Skills here that are not
# in the manifest are only listed: installing one is a deliberate --add.

[ "${BASH_VERSINFO[0]}" -ge 4 ] || { echo "needs bash >= 4 (macOS /bin/bash is 3.2; brew install bash)" >&2; exit 1; }

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
DST="$DOTFILES/common/claude/skills"
MANIFEST="$DOTFILES/common/claude/mattpocock-skills.txt"

add=()
while [ $# -gt 0 ]; do
  case "$1" in
    --add) add+=("$2"); shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

[ -d "$DST" ] || { echo "dotfiles skills dir not found: $DST" >&2; exit 1; }
if [ -n "$(git -C "$REPO" status --porcelain)" ]; then
  echo "⚠ fork has uncommitted changes; they will be synced but are not on origin yet" >&2
fi

# name -> path for every live skill (deprecated/ and misc/ are never installed)
declare -A src=()
while IFS= read -r f; do
  dir="$(dirname "$f")"
  src["$(basename "$dir")"]="$dir"
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' -not -path '*/misc/*' -not -path '*/node_modules/*')

wanted=()
[ -f "$MANIFEST" ] && while IFS= read -r n; do [ -n "$n" ] && wanted+=("$n"); done < "$MANIFEST"
for n in "${add[@]}"; do
  [ -n "${src[$n]:-}" ] || { echo "--add $n: no such skill in the fork" >&2; exit 1; }
  wanted+=("$n")
done

kept=()
for n in $(printf '%s\n' "${wanted[@]}" | sort -u); do
  if [ -n "${src[$n]:-}" ]; then
    rsync -a --delete --exclude __pycache__ "${src[$n]}/" "$DST/$n/"
    kept+=("$n")
  else
    rm -rf "${DST:?}/$n"
    echo "removed $n (gone from the fork)"
  fi
done
printf '%s\n' "${kept[@]}" > "$MANIFEST"

for n in $(printf '%s\n' "${!src[@]}" | sort); do
  printf '%s\n' "${kept[@]}" | grep -qx "$n" || echo "not installed: $n (install with --add $n)"
done

echo "synced ${#kept[@]} skills from fork $(git -C "$REPO" rev-parse --short HEAD)"
git -C "$DOTFILES" status --short -- common/claude/skills common/claude/mattpocock-skills.txt
echo "next: commit those paths in $DOTFILES, then run: dotfiles apply"
