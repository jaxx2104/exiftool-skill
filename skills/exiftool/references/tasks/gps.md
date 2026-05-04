# GPS / Geolocation

This file covers reading, writing, deleting, and converting GPS coordinates
in image and video files using exiftool.

## When this applies
Read this file when the user says things like:
- 「GPS 消して」「ジオタグ削除」/ "strip GPS", "remove location"
- 「この写真どこで撮った？」/ "where was this taken"
- 「GPX から座標つけて」/ "geotag from GPX"
- 「この座標を入れて」/ "set GPS to lat,lon"

## Pre-flight checks
1. **Writing or deleting?** Read `references/safety.md` first.
2. **Batch operation?** Run a count first:
   `exiftool -if '$gpslatitude' -p '$filename' -r DIR | wc -l`
3. **Backup behavior**: by default exiftool creates `<file>_original`.
   Confirm with the user whether to keep or use `-overwrite_original`.

## Common patterns

### Pattern: Show GPS coordinates
**Input**: 「この写真の GPS 教えて」 / "where was photo.jpg taken"
**Command**:
```sh
exiftool -GPSPosition -GPSAltitude photo.jpg
# Or for parsing:
exiftool -j -GPSLatitude -GPSLongitude photo.jpg
```
**Why**: `Composite:GPSPosition` is a derived (read-only) tag combining
lat/lon/refs into a human-friendly string. For programmatic use, prefer
the raw `EXIF:GPSLatitude` / `GPSLongitude`.

### Pattern: Strip GPS from one or many files
**Input**: 「GPS 消して」 / "remove all location data before posting"
**Command (single file, dry-run first recommended)**:
```sh
# Confirm what will be removed:
exiftool -gps:all photo.jpg
# Then remove:
exiftool -gps:all= photo.jpg
```
**Command (batch)**:
```sh
# 1) Count first:
exiftool -if '$gpslatitude' -p '$filename' -r ./photos | wc -l
# 2) Strip:
exiftool -gps:all= -r ./photos
```
**Why**: `-gps:all=` deletes the entire GPS group in EXIF and XMP at once,
which is what users typically mean by "remove GPS". Setting individual tags
can leave residue (e.g., `GPSAltitude` lingering).

### Pattern: Set GPS coordinates manually
**Input**: 「この写真に東京駅の座標入れて」 / "geotag photo.jpg to 35.6812, 139.7671"
**Command**:
```sh
exiftool \
  -GPSLatitude=35.6812 -GPSLatitudeRef=N \
  -GPSLongitude=139.7671 -GPSLongitudeRef=E \
  photo.jpg
```
**Why**: GPS in EXIF is stored as positive magnitude + N/S/E/W ref.
Forgetting `Ref` results in coordinates being interpreted as the wrong
hemisphere — a common silent failure. (Pitfall P-002.)

### Pattern: Geotag from a GPX track
**Input**: 「track.gpx に合わせて全部 geotag して」
**Command**:
```sh
exiftool -geotag track.gpx -r ./photos
# If photo time is offset from GPX time:
exiftool -geotag track.gpx -geosync=+1:00:00 -r ./photos
```
**Why**: exiftool matches by `DateTimeOriginal`. If the camera clock is off,
use `-geosync` to apply an offset.

## Pitfalls
- **`Composite:GPSPosition` is read-only.** Writing to it silently fails.
  Use `EXIF:GPSLatitude` / `EXIF:GPSLongitude` (with `Ref` tags). (P-001)
- **Forgetting `Ref` tags.** Without `GPSLatitudeRef=N`, southern hemisphere
  coordinates flip sign in some viewers. (P-002)
- **HEIC files**: GPS may live in `XMP:GPSLatitude` instead of `EXIF`. When
  in doubt, read both groups: `exiftool -GPS:all -XMP:GPS:all file.heic`. (P-006)
- **Video GPS** (GoPro/DJI): see `references/tasks/video.md` — different
  storage location.

## See also
- `references/safety.md` — backup behavior, batch confirmation
- `references/upstream/geotag.md` — full geotag option reference (Phase 2)
- `references/tag-cheatsheet.md` — GPS tag families across EXIF/XMP/Composite
- `references/tasks/video.md` — GPS in video files
