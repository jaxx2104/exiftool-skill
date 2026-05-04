# Sanitize: strip private metadata before sharing

This file covers removing personally identifying information (GPS,
serial numbers, owner names, comments, embedded thumbnails) from media
files before public posting.

## When this applies
Read this file when the user says things like:
- "strip metadata before posting"
- "remove serial and GPS"
- "wipe everything"
- "is my owner name in there"

## Pre-flight checks
1. **All sanitization is destructive.** Read `references/safety.md`.
2. Default exiftool behavior creates `<file>_original` backups; confirm
   with the user whether to keep them or use `-overwrite_original`.
3. For batch operations, run a count first:
   `find ./photos -type f \( -iname '*.jpg' -o -iname '*.heic' \) | wc -l`

## Common patterns

### Pattern: Strip everything
**Input**: "remove all metadata"
**Command**:
```sh
# Single file:
exiftool -all= photo.jpg
# Batch:
exiftool -all= -r -ext jpg -ext heic ./photos
```
**Why**: `-all=` removes every writable tag in every group at once. Some
tags exiftool cannot remove (file format intrinsics) remain — those are
not personally identifying.

### Pattern: SNS-publish preset
**Input**: "ready this for instagram"
**Command**:
```sh
exiftool \
  -gps:all= \
  -SerialNumber= \
  -InternalSerialNumber= \
  -CameraSerialNumber= \
  -OwnerName= \
  -CameraOwnerName= \
  -ImageDescription= \
  -UserComment= \
  -Comment= \
  -Software= \
  -HostComputer= \
  -RawFileName= \
  photo.jpg
```
**Why**: this preset removes the most common identifying fields while
preserving generally useful metadata (Make, Model, LensModel, capture
date, exposure settings). The `scripts/strip-private.sh` helper wraps
this exact list and accepts a file or directory.

### Pattern: Remove only one group
**Input**: "strip EXIF but keep XMP"
**Command**:
```sh
exiftool -EXIF:all= photo.jpg
# Or only GPS:
exiftool -gps:all= photo.jpg
```
**Why**: `<Group>:all=` deletes every tag in one family. Useful when
the user wants to keep edits stored in XMP (e.g., Lightroom catalog
metadata) but blank out hardware-identifying EXIF.

### Pattern: Strip and clean up _original backups
**Input**: "no backups please"
**Command**:
```sh
# After confirmation that the user accepts irreversibility:
exiftool -all= -overwrite_original -r -ext jpg ./photos
```
**Why**: `-overwrite_original` removes the `_original` files exiftool
creates by default. Per pitfall P-007, this is irreversible — use only
with explicit user consent. Alternative: leave `_original` files in
place and clean them later:
```sh
find ./photos -name '*_original' -delete
```

### Pattern: Verify sanitization succeeded
**Input**: "verify what's left"
**Command**:
```sh
exiftool -G photo.jpg
# Or check for specific concerning tags:
exiftool -G -gps:all -SerialNumber -OwnerName -Software photo.jpg
```
**Why**: post-sanitization read confirms what remains. If the output is
empty for the queried tags, the sanitization succeeded.

### Pattern: PNG-specific (note tEXt chunks)
**Input**: "sanitize PNG"
**Command**:
```sh
exiftool -all= image.png
```
**Why**: PNGs may carry metadata in `tEXt`/`iTXt`/`zTXt` chunks
(separate from EXIF). `-all=` removes them. Using `-EXIF:all=` alone
is insufficient (P-010).

## Pitfalls

- **Composite tags re-derive after deletion**: `Composite:GPSPosition`
  may "reappear" in subsequent reads if the underlying GPS tags were
  not all removed. `-gps:all=` covers this.
- **Embedded thumbnails carry GPS too**: some cameras embed a thumbnail
  with its own EXIF block. `-all=` strips it; `-EXIF:all=` may leave
  thumbnail EXIF behind. Verify by reading after sanitize.
- **`_original` files are irreversible after `-overwrite_original`**
  (P-007). Default behavior is safe; only delete backups with explicit
  consent.
- **PNG `tEXt` chunks** (P-010): use `-all=`, not `-EXIF:all=`.
- **Some MakerNote tags may carry latent identification** (lens-mount
  serial, internal counters) that are not in the SNS-publish preset
  above. For maximum sanitization, use `-all=`.

## See also
- `references/safety.md` (P-007, P-010)
- `references/tag-cheatsheet.md` for the identifying tag families
- `skills/exiftool/scripts/strip-private.sh`
