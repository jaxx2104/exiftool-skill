#!/usr/bin/env bash
# extract-gpx.sh — Extract embedded GPS track from a GoPro/DJI video as GPX.
#
# Uses exiftool -ee (ExtractEmbedded) plus the gpx.fmt template shipped
# with upstream exiftool.
#
# Usage:
#   extract-gpx.sh [-o|--output FILE] [-f|--fmt PATH] VIDEO
#
# Defaults:
#   --output  <video>.gpx (alongside the source)
#   --fmt     auto-detected; searches:
#               $EXIFTOOL_GPX_FMT
#               $XDG_CONFIG_HOME/exiftool/fmt/gpx.fmt
#               $HOME/.config/exiftool/fmt/gpx.fmt
#               <repo>/vendor/exiftool/fmt_files/gpx.fmt (when run from
#               inside the exiftool-skill repo)
#
# Examples:
#   extract-gpx.sh gopro.mp4
#   extract-gpx.sh -o track.gpx gopro.mp4
#   extract-gpx.sh -f /path/to/gpx.fmt drone.mov
#
# Options:
#   -o, --output FILE   Output GPX path.
#   -f, --fmt PATH      Path to gpx.fmt template.
#   -h, --help          Print this help.

set -euo pipefail

print_help() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

OUT=""
FMT=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o|--output)  OUT="$2"; shift 2 ;;
        -f|--fmt)     FMT="$2"; shift 2 ;;
        -h|--help)    print_help; exit 0 ;;
        --)           shift; break ;;
        -*)           echo "unknown option: $1" >&2; print_help >&2; exit 2 ;;
        *)            break ;;
    esac
done

if [[ $# -ne 1 ]]; then
    echo "error: expected VIDEO" >&2
    print_help >&2
    exit 2
fi

VIDEO="$1"

if [[ ! -f "$VIDEO" ]]; then
    echo "error: not a file: $VIDEO" >&2
    exit 2
fi

if [[ -z "$OUT" ]]; then
    OUT="${VIDEO%.*}.gpx"
fi

if [[ -z "$FMT" ]]; then
    CANDIDATES=(
        "${EXIFTOOL_GPX_FMT:-}"
        "${XDG_CONFIG_HOME:-$HOME/.config}/exiftool/fmt/gpx.fmt"
        "$HOME/.config/exiftool/fmt/gpx.fmt"
    )
    # When running from inside the exiftool-skill repo, vendor/ has it.
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    REPO_ROOT="$SCRIPT_DIR/../../.."
    CANDIDATES+=("$REPO_ROOT/vendor/exiftool/fmt_files/gpx.fmt")

    for c in "${CANDIDATES[@]}"; do
        if [[ -n "$c" && -f "$c" ]]; then
            FMT="$c"
            break
        fi
    done
fi

if [[ -z "$FMT" || ! -f "$FMT" ]]; then
    cat >&2 <<EOF
error: gpx.fmt not found

Provide one with --fmt PATH, or place the template in one of:
  \$EXIFTOOL_GPX_FMT
  \$XDG_CONFIG_HOME/exiftool/fmt/gpx.fmt
  \$HOME/.config/exiftool/fmt/gpx.fmt

The upstream exiftool source ships gpx.fmt under fmt_files/.
EOF
    exit 2
fi

exiftool -ee -p "$FMT" "$VIDEO" > "$OUT"
echo "wrote: $OUT"
