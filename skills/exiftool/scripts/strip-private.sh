#!/usr/bin/env bash
# strip-private.sh — Remove the most common identifying metadata from
# image files in preparation for public sharing.
#
# Removes: GPS, SerialNumber (and variants), OwnerName, ImageDescription,
# UserComment, Software, HostComputer, RawFileName.
#
# Preserves: Make, Model, LensModel, capture date, exposure settings.
#
# Usage:
#   strip-private.sh [--dry-run] [--no-backup] [-e|--ext EXT]... PATH
#
# Examples:
#   strip-private.sh photo.jpg
#   strip-private.sh --dry-run ./photos
#   strip-private.sh --no-backup -e jpg -e heic ./photos
#
# Options:
#   --dry-run       Show what would be removed; do not modify files.
#   --no-backup     Pass -overwrite_original to exiftool. IRREVERSIBLE.
#   -e, --ext EXT   Restrict to extension EXT (repeatable).
#   -h, --help      Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

DRY_RUN=0
NO_BACKUP=0
EXTS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)    DRY_RUN=1; shift ;;
        --no-backup)  NO_BACKUP=1; shift ;;
        -e|--ext)     EXTS+=("$2"); shift 2 ;;
        -h|--help)    print_help; exit 0 ;;
        --)           shift; break ;;
        -*)           echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)            break ;;
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

# Tags to remove. Order matches references/tasks/sanitize.md SNS preset.
STRIP_TAGS=(
    -gps:all=
    -SerialNumber=
    -InternalSerialNumber=
    -CameraSerialNumber=
    -OwnerName=
    -CameraOwnerName=
    -ImageDescription=
    -UserComment=
    -Comment=
    -Software=
    -HostComputer=
    -RawFileName=
)

EXTRA_ARGS=()
if [[ "$NO_BACKUP" -eq 1 ]]; then
    EXTRA_ARGS+=(-overwrite_original)
fi

if [[ -d "$TARGET" ]]; then
    EXTRA_ARGS+=(-r)
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
    # Dry-run: show readings of the tags that WOULD be removed.
    READ_TAGS=()
    for t in "${STRIP_TAGS[@]}"; do
        READ_TAGS+=("${t%=}")
    done
    echo "# dry-run: tags currently present that would be removed"
    if [[ -d "$TARGET" ]]; then
        exiftool -G "${EXT_ARGS[@]}" -r "${READ_TAGS[@]}" "$TARGET"
    else
        exiftool -G "${READ_TAGS[@]}" "$TARGET"
    fi
    exit 0
fi

exiftool "${EXTRA_ARGS[@]}" "${EXT_ARGS[@]}" "${STRIP_TAGS[@]}" "$TARGET"
