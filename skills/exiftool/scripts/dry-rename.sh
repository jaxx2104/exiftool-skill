#!/usr/bin/env bash
# dry-rename.sh — Preview a -FileName< rename without modifying files.
#
# Wraps `exiftool -TestName<<TAG> -d <FORMAT>` so the user sees the
# proposed Old → New mapping before committing to the rename.
#
# Usage:
#   dry-rename.sh [-t|--tag TAG] [-d|--date-format FMT] [-e|--ext EXT]... PATH
#
# Defaults:
#   --tag           DateTimeOriginal
#   --date-format   %Y%m%d_%H%M%S.%%le
#
# Examples:
#   dry-rename.sh ./photos
#   dry-rename.sh -d '%Y/%m/%d/%Y%m%d_%H%M%S.%%le' ./photos
#   dry-rename.sh -t CreateDate -e jpg -e heic ./photos
#
# Options:
#   -t, --tag TAG          Source tag (default: DateTimeOriginal).
#   -d, --date-format FMT  -d format string (default: %Y%m%d_%H%M%S.%%le).
#   -e, --ext EXT          Restrict to extension EXT (repeatable).
#   -h, --help             Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

TAG="DateTimeOriginal"
FORMAT='%Y%m%d_%H%M%S.%%le'
EXTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--tag)          TAG="$2"; shift 2 ;;
        -d|--date-format)  FORMAT="$2"; shift 2 ;;
        -e|--ext)          EXTS+=("$2"); shift 2 ;;
        -h|--help)         print_help; exit 0 ;;
        --)                shift; break ;;
        -*)                echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)                 break ;;
    esac
done

if [[ $# -ne 1 ]]; then
    echo "error: expected PATH" >&2
    print_help >&2
    exit 2
fi

TARGET="$1"

if [[ ! -e "$TARGET" ]]; then
    echo "error: not found: $TARGET" >&2
    exit 2
fi

EXT_ARGS=()
for e in "${EXTS[@]}"; do
    EXT_ARGS+=(-ext "$e")
done

R_ARG=()
if [[ -d "$TARGET" ]]; then
    R_ARG+=(-r)
fi

exiftool "${R_ARG[@]}" "${EXT_ARGS[@]}" \
    "-TestName<${TAG}" \
    -d "$FORMAT" \
    "$TARGET"
