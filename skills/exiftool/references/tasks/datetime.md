# Date and time correction

This file covers viewing capture dates, shifting timestamps in bulk,
restoring dates from filenames, and timezone correction.

## When this applies
Read this file when the user says things like:
- "shift all dates by +2h"
- "camera clock was on UTC"
- "set capture date from filename"
- "no offset time stored"

## Pre-flight checks
1. Date writes are destructive. Read `references/safety.md`.
2. Confirm which tag the user means: `DateTimeOriginal` (EXIF capture
   moment), `CreateDate` (often equal), `FileModifyDate` (filesystem
   mtime — usually NOT what users want; pitfall P-003).
3. For batch shifts, count first:
   `exiftool -if '$DateTimeOriginal' -p '$FileName' -r DIR | wc -l`.

## Common patterns

### Pattern: Show capture dates
**Input**: "when was this taken"
**Command**:
```sh
exiftool -DateTimeOriginal -CreateDate -OffsetTimeOriginal photo.jpg
# For directory:
exiftool -DateTimeOriginal -r ./photos
```
**Why**: `DateTimeOriginal` is the canonical capture moment. Showing
`OffsetTimeOriginal` alongside reveals whether the camera recorded TZ
context (many older cameras do not).

### Pattern: Shift all dates by an offset
**Input**: "add 2 hours to all dates"
**Command**:
```sh
# Single file:
exiftool -AllDates+="0:0:0 2:0:0" photo.jpg
# Batch:
exiftool -AllDates+="0:0:0 2:0:0" -r ./photos
# Subtract:
exiftool -AllDates-="0:0:0 2:0:0" -r ./photos
# Days, hours, minutes, seconds:
exiftool -AllDates+="0:0:0 0:30:0" photo.jpg   # +30 minutes
exiftool -AllDates+="0:0:1 0:0:0" photo.jpg    # +1 day
```
**Why**: `-AllDates` is a shortcut for `DateTimeOriginal`, `CreateDate`,
`ModifyDate` simultaneously. Format is
`Y:M:D h:m:s`. **Note**: this does NOT include `FileModifyDate`,
`GPSDateTime`, or `QuickTime:CreateDate` (P-004).

### Pattern: Restore date from filename
**Input**: "recover DateTimeOriginal from filename"
**Command**:
```sh
exiftool '-DateTimeOriginal<filename' photo.jpg
# Verify what would be set first (dry-run via no-op test):
exiftool -p '$filename -> $DateTimeOriginal' '-DateTimeOriginal<filename' photo.jpg
```
**Why**: `<` reads the value from another tag. exiftool tries to match
common date patterns inside `$filename`. For unusual patterns, use a
custom format string per the upstream filename docs (Phase 2).

### Pattern: Apply or fix timezone offset
**Input**: "set OffsetTimeOriginal to +09:00"
**Command**:
```sh
# Set the offset annotation (does NOT shift dates):
exiftool -OffsetTimeOriginal=+09:00 -OffsetTime=+09:00 \
        -OffsetTimeDigitized=+09:00 photo.jpg
# To both shift dates by 9 hours AND record the offset:
exiftool -AllDates+="0:0:0 9:0:0" \
        -OffsetTimeOriginal=+09:00 -OffsetTime=+09:00 \
        -OffsetTimeDigitized=+09:00 photo.jpg
```
**Why**: `OffsetTime*` tags are EXIF 2.31+ TZ annotations. They do not
re-interpret existing wall-clock dates; they label them. For video,
`QuickTime:CreateDate` is UTC by spec (P-005) — handle separately.

### Pattern: Conditional shift (only files matching a criterion)
**Input**: "shift only Apple iPhone files by +9h"
**Command**:
```sh
exiftool -if '$Make eq "Apple"' \
        -AllDates+="0:0:0 9:0:0" \
        -r ./photos
```
**Why**: `-if` filters before applying the write. The Plan step in the
three-step rule should run the same `-if` with `-p '$FileName' | wc -l`
first to display the count.

## Pitfalls

- **No metadata to filter on → ASK, do not guess.** When the user says
  "only the photos shot in TZ X" but the files lack `OffsetTimeOriginal`,
  GPS, or any other tag that would identify the subset, do NOT pick
  files heuristically (e.g. by year or by camera model). Surface the
  ambiguity to the user and ask which files to target. The wrong shift
  on the wrong files is silent corruption.
- **`-AllDates` is not "every date".** Filesystem mtime, GPSDateTime,
  and QuickTime atoms are not included (P-004). Enumerate explicitly
  when needed.
- **`-FileModifyDate` is filesystem-only** (P-003). The user almost
  always means `DateTimeOriginal`.
- **Video dates are UTC** (`QuickTime:CreateDate`, P-005). Shifting the
  same way as image dates can introduce a double-offset.
- **Date format gotcha**: the offset string is `Y:M:D h:m:s`, not
  `D:H:M:S`. `0:0:0 25:0:0` is valid (25 hours = +1d 1h).

## See also
- `references/safety.md` (especially P-003, P-004, P-005)
- `references/tasks/video.md` for QuickTime date handling
- `references/upstream/cli-options.md` (Phase 2) for `-tagsFromFile` and
  date-format extras
