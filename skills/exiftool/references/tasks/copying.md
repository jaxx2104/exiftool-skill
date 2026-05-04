# Tag copying and sidecar XMP

This file covers copying metadata between files (image-to-image,
image-to-XMP, XMP-to-image), selective tag copies, and bulk sidecar
application.

## When this applies
Read this file when the user says things like:
- "copy exif from a to b"
- "preserve raw exif in the converted tiff"
- "apply XMP sidecars to images"
- "extract exif as sidecar"

## Pre-flight checks
1. Tag copies are writes. Read `references/safety.md`.
2. By default, only writable tags are copied (Composite, etc., are
   skipped automatically).
3. For batch sidecar application, confirm the naming convention
   (`photo.jpg` ↔ `photo.xmp` vs `photo.jpg.xmp`).

## Common patterns

### Pattern: Copy all metadata between two files
**Input**: "copy a.jpg metadata to b.jpg"
**Command**:
```sh
exiftool -tagsFromFile a.jpg b.jpg
```
**Why**: `-tagsFromFile <source>` reads from the source and writes the
named tags (default: all writable tags) to the file(s) listed
afterwards. The destination file is modified in place; an `_original`
backup is created.

### Pattern: Copy a subset (e.g., only GPS or only EXIF)
**Input**: "copy only GPS from a.jpg to b.jpg"
**Command**:
```sh
exiftool -tagsFromFile a.jpg -gps:all b.jpg
# Multiple selections (additive):
exiftool -tagsFromFile a.jpg -gps:all -DateTimeOriginal -Make -Model b.jpg
# Whole group:
exiftool -tagsFromFile a.jpg -EXIF:all b.jpg
```
**Why**: tag flags after `-tagsFromFile` restrict what is copied. Use
group:all for a clean sweep of one family.

### Pattern: Apply sidecar XMP to an image
**Input**: "apply photo.xmp to photo.jpg"
**Command**:
```sh
exiftool -tagsFromFile photo.xmp -all:all photo.jpg
```
**Why**: `-all:all` after `-tagsFromFile` from an XMP source pulls every
tag the sidecar contains into the image. For only structured XMP fields:
`-XMP:all` instead of `-all:all`.

### Pattern: Bulk sidecar application across a directory
**Input**: "apply each XMP sidecar to its image"
**Command**:
```sh
exiftool -tagsFromFile %d%f.xmp -all:all -ext jpg ./photos
```
**Why**: `%d` = directory of the destination, `%f` = base filename. So
for `./photos/IMG_001.jpg`, exiftool reads `./photos/IMG_001.xmp`. Add
`-r` for recursion.

### Pattern: Extract image metadata as a sidecar
**Input**: "export photo.jpg metadata as XMP sidecar"
**Command**:
```sh
exiftool -o photo.xmp photo.jpg
# Or for batch:
exiftool -o %d%f.xmp -r -ext jpg ./photos
```
**Why**: `-o <output>` writes a new file rather than modifying the
source. When the output ends in `.xmp`, exiftool produces a valid
XMP sidecar containing the source's metadata.

### Pattern: Copy from a different tag (rename a tag)
**Input**: "copy IPTC:Caption-Abstract to XMP-dc:Description"
**Command**:
```sh
exiftool '-XMP-dc:Description<IPTC:Caption-Abstract' photo.jpg
```
**Why**: `<` copies one tag's value into another. This is the
fundamental mechanism behind `-FileName<DateTimeOriginal` (renaming) and
similar tag-to-tag rewrites.

## Pitfalls

- **`-tagsFromFile` and the source argument**: the tag flags after
  `-tagsFromFile <source>` apply to that source until the next
  `-tagsFromFile` or until the end of options. Order matters.
- **Naming-convention mismatch for sidecars**: `photo.xmp` vs.
  `photo.jpg.xmp` are both used in the wild. The `%d%f.xmp` recipe
  assumes the former.
- **Composite tags are skipped silently** when copying — that is correct
  behavior but can confuse users who expect `Composite:GPSPosition` to
  carry over. The underlying writable tags (`GPSLatitude` etc.) do
  copy; the composite re-derives in the destination.
- **XMP sidecars created via `-o` overwrite if existing**. Confirm
  before running on a tree where sidecars may already be present.

## See also
- `references/safety.md`
- `references/upstream/metafiles.md` (Phase 2) for sidecar formats and
  related tags
- `references/tag-cheatsheet.md` for picking selective tags
