# Safety rules for write operations

Read this file **before issuing any write or delete** with `exiftool`.
Reading-only operations (no `=`, no `<`, no `-overwrite_*`) do not require
this gate.

## The three-step rule

1. **Plan**: state what will change — which files, which tags, expected
   count — and surface this to the user.
2. **Confirm**: get explicit user approval. Do not infer consent from
   ambiguous phrasing.
3. **Execute**: run the write only after confirmation.

For batch operations, the Plan step **must** include a count produced by
the matching `-if` query (or `scripts/plan-batch.sh`).

## `_original` backup behavior

By default, exiftool writes the modified file in place and leaves the
unmodified original next to it as `<file>_original`.

| Flag | Behavior | Use when |
|------|----------|----------|
| (none) | Creates `<file>_original` | Default. Safe. |
| `-overwrite_original` | Deletes the backup after success | The user explicitly accepts that the original cannot be restored. |
| `-overwrite_original_in_place` | Same content as above, but preserves inode and atime | The file is referenced by hard links or apps that watch inode identity, and the user accepts loss of the backup. |

When in doubt, **do not** pass `-overwrite_original` — exiftool's default
is the safe choice.

## Tag-family writability

| Group | Read | Write | Notes |
|-------|------|-------|-------|
| `EXIF` | yes | yes | Primary writable group for most cameras. |
| `XMP` | yes | yes | Sidecar-friendly; broader Unicode support than IPTC. |
| `IPTC` | yes | yes | Legacy news/photo tags. |
| `Composite` | yes | **no** | Derived/computed tags. Writing silently no-ops. |
| `MakerNote` | yes | rarely | Manufacturer-proprietary; partial write support per camera. |
| `File` (e.g., `FileName`, `FileModifyDate`) | yes | yes | These are filesystem operations, not metadata writes. |

## Pitfall catalog

Each entry: **symptom → cause → avoidance**. Numbered for easy reference
in conversations.

### P-001: Writing to `Composite:GPSPosition` does nothing

- **Symptom**: command succeeds, no error, but coordinates are unchanged.
- **Cause**: `Composite:GPSPosition` is a derived (read-only) tag combining
  `EXIF:GPSLatitude`, `GPSLongitude`, and the `Ref` tags into one string.
- **Avoidance**: write the four underlying tags
  (`EXIF:GPSLatitude`, `GPSLatitudeRef`, `GPSLongitude`, `GPSLongitudeRef`).

### P-002: Forgetting `Ref` tags flips hemispheres

- **Symptom**: a Tokyo photo (35.68°N) reads as 35.68°S in some viewers.
- **Cause**: EXIF stores GPS as positive magnitude + N/S/E/W ref. Without
  the ref, the consuming app applies an arbitrary default.
- **Avoidance**: when writing latitude/longitude manually, always include
  `GPSLatitudeRef=N|S` and `GPSLongitudeRef=E|W`.

### P-003: `-FileModifyDate` ≠ `-DateTimeOriginal`

- **Symptom**: the user asks to "fix the date" and the photo metadata is
  unchanged; only the filesystem mtime moved.
- **Cause**: `FileModifyDate` is a filesystem property; `DateTimeOriginal`
  is the EXIF capture date. Most users mean the latter.
- **Avoidance**: clarify intent. Default to `-DateTimeOriginal`
  (or `-AllDates`).

### P-004: `-AllDates` is not "every date"

- **Symptom**: bulk shift leaves `FileModifyDate` (or other unexpected
  fields) at the old value.
- **Cause**: `-AllDates` is a shortcut for the three EXIF date tags
  (`DateTimeOriginal`, `CreateDate`, `ModifyDate`). It does **not** include
  filesystem dates, GPS times, or QuickTime times.
- **Avoidance**: enumerate explicitly when needed:
  `-DateTimeOriginal -CreateDate -ModifyDate -GPSDateTime -QuickTime:CreateDate`.

### P-005: `QuickTime:CreateDate` is in UTC

- **Symptom**: a video shows a 9-hour offset between EXIF and QuickTime
  date values for the same recording.
- **Cause**: QuickTime/MP4 atoms store creation times in UTC by spec; EXIF
  stores wall-clock with optional `OffsetTime`.
- **Avoidance**: when shifting video dates, treat QuickTime fields as UTC
  and apply or strip the offset accordingly.

### P-006: HEIC stores GPS in XMP, not always EXIF

- **Symptom**: `exiftool -GPS:all heic_file.heic` returns nothing for a
  photo that clearly has location.
- **Cause**: Apple devices often write GPS into the XMP block of HEIC
  containers in addition to (or instead of) the EXIF block.
- **Avoidance**: read both groups:
  `exiftool -GPS:all -XMP:GPS:all file.heic`. For deletion, use
  `-gps:all=` (lowercase, all groups).

### P-007: `-overwrite_original` cannot be undone

- **Symptom**: user wants to recover a pre-edit copy after running with
  `-overwrite_original`; there is no `_original` file.
- **Cause**: the flag deletes the backup synchronously after the write.
- **Avoidance**: never add `-overwrite_original` to a write command on the
  user's behalf without explicit confirmation. Consider
  `-overwrite_original_in_place` only when inode preservation is required.

### P-008: Wildcards vs. `-r`

- **Symptom**: `exiftool ./photos/*.jpg` skips `./photos/sub/IMG.jpg`.
- **Cause**: shell glob expansion is non-recursive; `-r` is exiftool's
  own recursion flag.
- **Avoidance**: prefer `exiftool -r -ext jpg ./photos` for recursive
  walks. The shell glob and `-r` serve different purposes.

### P-009: Filename case from `%%le` vs. `%%e`

- **Symptom**: a renamed file ends up with `.JPG` instead of `.jpg`
  (or vice versa), breaking downstream tooling that case-discriminates.
- **Cause**: in `-d`/`-FileName<` formats, `%%e` preserves the original
  extension's case; `%%le` lowercases it.
- **Avoidance**: pick the appropriate form. For mixed-case sources where
  consistent lowercase is desired, use `%%le`.

### P-010: PNG metadata may be in tEXt, not EXIF

- **Symptom**: stripping EXIF from a PNG leaves visible "metadata" intact
  in viewers.
- **Cause**: PNG historically stores metadata in `tEXt`, `iTXt`, `zTXt`
  chunks. Newer files may carry EXIF in an `eXIf` chunk; both can coexist.
- **Avoidance**: for full sanitization of PNGs, use `-all=` rather than
  `-exif:all=`.

## See also

- `references/upstream/common-mistakes.md` (Phase 2; auto-generated from
  upstream `mistakes.html`)
- `references/upstream/idiosyncracies.md` (Phase 2; auto-generated from
  upstream `idiosyncracies.html`)
- `references/tag-cheatsheet.md` for tag-name lookup
