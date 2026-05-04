# Reading and extracting metadata

This file covers viewing metadata, filtering by tag or group, batch
reads, and producing parseable output. Reading is non-destructive — no
safety gate required.

## When this applies
Read this file when the user says things like:
- "show all exif"
- "just the GPS"
- "what camera shot this"
- "list capture dates"

## Pre-flight checks
1. Reading is read-only; no backup or confirmation needed.
2. For batch reads, decide the output shape early (terminal-readable
   table vs. JSON for downstream parsing). See
   `references/tasks/formats.md` for export forms.

## Common patterns

### Pattern: Show all metadata for one file
**Input**: "what's in photo.jpg"
**Command**:
```sh
exiftool photo.jpg
```
**Why**: default output groups tags by family with human-readable values.
For large outputs add `-G` to prefix every tag with its group, which
makes the source family unambiguous (`[EXIF]` vs `[XMP]` vs
`[Composite]`):
```sh
exiftool -G photo.jpg
```

### Pattern: Show specific tags only
**Input**: "just GPS and capture date"
**Command**:
```sh
exiftool -GPSPosition -DateTimeOriginal photo.jpg
```
**Why**: tag flags filter the output. Use the cheatsheet
(`references/tag-cheatsheet.md`) to pick the right tag name. For
machine consumption prefer the underlying writable tags:
```sh
exiftool -GPSLatitude -GPSLongitude -DateTimeOriginal photo.jpg
```

### Pattern: Show all tags in a group
**Input**: "all EXIF tags"
**Command**:
```sh
exiftool -EXIF:all photo.jpg
# Other groups:
exiftool -XMP:all photo.jpg
exiftool -GPS:all photo.jpg
exiftool -Composite:all photo.jpg
```
**Why**: `<Group>:all` prints every tag in that family. Useful for
confirming what would be touched by a `<Group>:all=` deletion.

### Pattern: Short forms for compact output
**Input**: "compact output"
**Command**:
```sh
exiftool -s photo.jpg     # tag names instead of descriptions
exiftool -s2 photo.jpg    # short form, single column
exiftool -s3 photo.jpg    # values only, no tag names
```
**Why**: `-s3` is ideal for piping a single value into another command:
```sh
DATE=$(exiftool -s3 -DateTimeOriginal photo.jpg)
```

### Pattern: Batch read across a directory
**Input**: "list all capture dates in DIR"
**Command**:
```sh
exiftool -r -ext jpg -ext heic -DateTimeOriginal -FileName ./photos
```
**Why**: `-r` recurses; `-ext` (repeatable) restricts to specific
extensions (case-insensitive). Without `-ext`, exiftool processes every
file it can read. For just the count of photos with a given tag:
```sh
exiftool -if '$DateTimeOriginal' -p '$FileName' -r ./photos | wc -l
```

### Pattern: Conditional filtering with `-if`
**Input**: "only files that have GPS"
**Command**:
```sh
exiftool -if '$gpslatitude' -p '$FileName' -r ./photos
```
**Why**: `-if` evaluates a Perl expression against each file's tag
values. `$gpslatitude` is truthy when present. Combine for stricter
filters: `-if '$gpslatitude and $make eq "Apple"'`.

### Pattern: Export as JSON for downstream parsing
**Input**: "give me JSON"
**Command**:
```sh
exiftool -j -G photo.jpg
exiftool -j -G -DateTimeOriginal -GPSLatitude -GPSLongitude -r ./photos
```
**Why**: `-j` produces a JSON array (one object per file). `-G` adds
group prefixes to every key (e.g., `EXIF:DateTimeOriginal`), which
disambiguates same-named tags from different groups. See
`references/tasks/formats.md` for CSV and other shapes.

## Pitfalls

- **Empty output for an expected tag**: the file may not contain it.
  Check the group: `exiftool -G photo.jpg | grep -i <name>`.
- **Wildcard non-recursion**: `exiftool ./photos/*.jpg` skips
  subdirectories. Use `-r -ext jpg ./photos`. (Pitfall P-008.)
- **JSON values are strings by default**: numeric tags (ISO, FNumber)
  appear as strings. Add `-n` to disable PrintConv for raw numeric
  values when feeding scripts.

## See also

- `references/tasks/formats.md` for full JSON/CSV/structured export.
- `references/tag-cheatsheet.md` for choosing tag names.
- `references/upstream/cli-options.md` (Phase 2) for the full option list.
