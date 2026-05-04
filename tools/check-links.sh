#!/usr/bin/env bash
# check-links.sh — Verify every relative Markdown link under skills/
# resolves to an existing path. Used as a post-regen sanity check
# (also embedded in tests/lint.sh, but this one is standalone for
# the GitHub Action).
#
# Usage:
#   tools/check-links.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0

while IFS= read -r -d '' md; do
    (grep -oE '\]\([^)]+\)' "$md" || true) | sed 's/^](//;s/)$//' \
    | while IFS= read -r link; do
        link_path="${link%%#*}"
        case "$link_path" in
            "" )                   continue ;;
            http://*|https://* )   continue ;;
            mailto:* )             continue ;;
            /* )                   continue ;;
        esac
        # Only validate links to other Markdown files. Non-.md targets
        # (PDFs, TXTs, images embedded in upstream pages) are accepted
        # as-is — they live upstream and are out of scope for the
        # skill's link integrity guarantee.
        case "$link_path" in
            *.md )                 ;;
            * )                    continue ;;
        esac
        md_dir="$(dirname "$md")"
        target="$md_dir/$link_path"
        if [[ ! -e "$target" ]]; then
            echo "broken link in $md: $link_path -> $target" >&2
            FAIL=1
        fi
    done
done < <(find skills/exiftool -name '*.md' -print0)

if [[ "$FAIL" -ne 0 ]]; then
    exit 1
fi
echo "all relative markdown links resolve"
