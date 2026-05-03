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
- Debian/Ubuntu: `sudo apt install libimage-exiftool-perl`
- Other: <https://exiftool.org/install.html>

## Reference map

(Filled in T22. References listed below are stubs only.)

- View / extract: `references/tasks/reading.md`
- GPS: `references/tasks/gps.md`
- Date/time: `references/tasks/datetime.md`
- Tag copy / sidecar: `references/tasks/copying.md`
- Renaming: `references/tasks/renaming.md`
- Formats: `references/tasks/formats.md`
- Video: `references/tasks/video.md`
- Sanitize: `references/tasks/sanitize.md`
- Tag cheatsheet: `references/tag-cheatsheet.md`
- Safety (REQUIRED before any write): `references/safety.md`

## Critical safety rules

(Filled in T22.)
