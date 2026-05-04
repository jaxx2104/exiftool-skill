---
name: exiftool
description: Use this skill any time the user works with image, video, or audio file metadata (EXIF, IPTC, XMP, GPS, MakerNote). This includes viewing or extracting metadata; reading or writing GPS coordinates; correcting DateTimeOriginal or shifting timestamps across many files; renaming or organizing files by capture date; copying tags between files or applying sidecar XMP; exporting metadata to JSON/CSV; extracting GPS tracks from GoPro/DJI videos; stripping private information (GPS, serials, comments) before public sharing. Trigger when the user mentions metadata, EXIF, GPS, geotag, "shot date", "撮影日時", sanitize, or references media files (.jpg, .jpeg, .heic, .heif, .cr2, .cr3, .nef, .arw, .dng, .raw, .tiff, .png, .mp4, .mov, .avi, .mkv, .mp3, .wav, .gpr, .360). Also trigger when extracting structured data from media files for analysis. Do NOT trigger for image content (pixels, resizing, format conversion of pixel data), video transcoding, or audio waveform processing — those need ffmpeg/ImageMagick, not exiftool.
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
| 表示・抽出 (view metadata)                   | `references/tasks/reading.md`      |
| GPS の追加・削除・変換                        | `references/tasks/gps.md`          |
| 撮影日時の補正・タイムゾーン                  | `references/tasks/datetime.md`     |
| タグの一括コピー・sidecar XMP 適用            | `references/tasks/copying.md`      |
| 撮影日でリネーム・整理                        | `references/tasks/renaming.md`     |
| JSON / CSV / 表形式エクスポート               | `references/tasks/formats.md`      |
| 動画 (GoPro/DJI) のメタデータ                | `references/tasks/video.md`        |
| 個人情報除去 (公開前 sanitize)                | `references/tasks/sanitize.md`     |
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
