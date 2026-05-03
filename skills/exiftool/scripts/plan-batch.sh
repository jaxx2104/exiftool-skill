#!/usr/bin/env bash
# plan-batch.sh — Count files matched by an exiftool -if query.
#
# This is the mandatory pre-step for batch destructive operations: print
# the count (and optionally the list) before any write so the user can
# confirm scope.
#
# Usage:
#   plan-batch.sh [-l|--list] [-e|--ext EXT]... DIR EXIFTOOL_IF_EXPR
#
# Examples:
#   plan-batch.sh ./photos '$gpslatitude'
#   plan-batch.sh -e jpg -e heic ./photos '$DateTimeOriginal'
#   plan-batch.sh --list ./photos '$Make eq "Apple"'
#
# Options:
#   -l, --list       Print matching filenames in addition to the count.
#   -e, --ext EXT    Restrict to extension EXT (repeatable).
#   -h, --help       Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

LIST=0
EXTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--list)   LIST=1; shift ;;
        -e|--ext)    EXTS+=("$2"); shift 2 ;;
        -h|--help)   print_help; exit 0 ;;
        --)          shift; break ;;
        -*)          echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)           break ;;
    esac
done

if [[ $# -ne 2 ]]; then
    echo "error: expected DIR and EXIFTOOL_IF_EXPR" >&2
    print_help >&2
    exit 2
fi

DIR="$1"
EXPR="$2"

if [[ ! -d "$DIR" ]]; then
    echo "error: not a directory: $DIR" >&2
    exit 2
fi

EXT_ARGS=()
for e in "${EXTS[@]}"; do
    EXT_ARGS+=(-ext "$e")
done

if [[ "$LIST" -eq 1 ]]; then
    exiftool -r "${EXT_ARGS[@]}" -if "$EXPR" -p '$FileName' "$DIR"
    COUNT=$(exiftool -r "${EXT_ARGS[@]}" -if "$EXPR" -p '$FileName' "$DIR" | wc -l)
else
    COUNT=$(exiftool -r "${EXT_ARGS[@]}" -if "$EXPR" -p '$FileName' "$DIR" | wc -l)
fi

# Strip leading whitespace from wc output for clean display.
COUNT="${COUNT// /}"

echo "matched: $COUNT file(s)"
