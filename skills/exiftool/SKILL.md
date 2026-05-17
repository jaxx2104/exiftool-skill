---
name: exiftool
description: 'Use this skill whenever the user wants to do anything with the metadata of photo, video, or audio files — not the pixels/frames/audio themselves. Core intents: shifting or fixing capture timestamps (timezone wrong, clock off, "bump the date"); reading, writing, removing, or copying GPS / geotags (including geotagging from a GPX track or pulling embedded GPS out of GoPro/DJI clips); stripping private info ("wipe gps", "remove metadata before posting/texting/sharing", sanitize for Instagram/SNS); renaming or sorting files into folders by capture date / shot date; copying tags between files or to/from XMP sidecars; exporting EXIF/IPTC/XMP to JSON or CSV. Trigger on DateTimeOriginal, EXIF, IPTC, XMP, geotag, GPX, "shot date", "capture date", "strip/wipe metadata" — even when "exiftool" is never said. Do NOT trigger for pixel-level work: resizing, cropping, rotating, format conversion, video transcoding, audio editing, OCR, or visual duplicate finding — those are ffmpeg/ImageMagick.'
---

# ExifTool Skill

Read, write, and manage metadata in image, video, and audio files using the
`exiftool` CLI. This skill provides task-oriented translations from
natural-language requests into safe `exiftool` invocations.

## Prerequisite

`exiftool` must be on PATH. Verify with `exiftool -ver`. If absent:

- macOS: `brew install exiftool`
- Debian / Ubuntu: `sudo apt install libimage-exiftool-perl`
- Other: <https://exiftool.org/install.html>

## Reference map (READ-FIRST when relevant)

Look up the user's intent in this table and read the corresponding
reference before composing commands. Most requests need exactly one
task file; writes additionally require `references/safety.md`.

| User intent                                  | Reference                          |
|----------------------------------------------|------------------------------------|
| View / extract metadata                      | `references/tasks/reading.md`      |
| Add / remove / convert GPS                   | `references/tasks/gps.md`          |
| Date / timezone correction                   | `references/tasks/datetime.md`     |
| Bulk tag copy / sidecar XMP                  | `references/tasks/copying.md`      |
| Rename / organize by capture date            | `references/tasks/renaming.md`     |
| JSON / CSV / table export                    | `references/tasks/formats.md`      |
| Video (GoPro/DJI) metadata                   | `references/tasks/video.md`        |
| Sanitize before publishing                   | `references/tasks/sanitize.md`     |
| Need a tag name?                             | `references/tag-cheatsheet.md`     |
| Writing files? (REQUIRED before any write)   | `references/safety.md`             |
| Deep dive on upstream                        | `references/upstream/INDEX.md` |

## Critical safety rules

These four rules apply universally and must be honored even when the
relevant task file is not yet read:

1. **Three-step rule for writes**: any operation that modifies a file
   (commands containing `=`, `<`, or `-overwrite_*`) follows
   plan → confirm → execute. State what will change, get user OK, then
   run. Detail in `references/safety.md`.
2. **Batch operations require a count first**: before any destructive
   recursive command, run an `-if` query (or `scripts/plan-batch.sh`)
   to display the matching file count.
3. **`Composite:GPSPosition` is read-only.** Write to
   `EXIF:GPSLatitude/GPSLongitude` plus their `Ref` tags. (Pitfall P-001.)
4. **`-FileModifyDate` is filesystem mtime, not capture date.** When
   the user says "fix the date", default to `-DateTimeOriginal`.
   (Pitfall P-003.)

For the full pitfall catalog (P-001 through P-010), see
`references/safety.md`.

## Bundled helpers

`scripts/` ships shell wrappers for common multi-step patterns. Use them
when the LLM would otherwise reconstruct the same recipe ad hoc:

| Script | Use case |
|--------|----------|
| `scripts/plan-batch.sh` | Mandatory pre-step for batch destructive ops. |
| `scripts/strip-private.sh` | SNS-publish sanitize preset. |
| `scripts/dry-rename.sh` | Preview a `-FileName<` rename. |
| `scripts/extract-gpx.sh` | GoPro/DJI embedded GPS → GPX. |

All scripts accept `--help` for usage.

## When to consult `references/upstream/`

When the relevant `references/tasks/*.md` does not cover the user's
request, or when the user asks about an option the task file does not
mention, consult `references/upstream/INDEX.md` to find the upstream
documentation excerpt. Each upstream file's frontmatter records which
upstream HTML page it derives from and the upstream version pinned in
`vendor/exiftool/`.
