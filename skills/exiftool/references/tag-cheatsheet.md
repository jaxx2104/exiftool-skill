# Tag cheatsheet

Frequent-use tag names grouped by metadata family. Use this as a quick
lookup when composing `exiftool` commands. For exhaustive listings, see
`references/upstream/tag-names/` (Phase 2).

## How tag references work

`exiftool` tag names are case-insensitive but conventionally PascalCase.
Tags can be qualified by group:

- `EXIF:GPSLatitude` (specific)
- `GPSLatitude` (all groups; ambiguous if multiple groups carry it)
- `-GPS:all` (all tags in the GPS sub-group)
- `-EXIF:all` (all EXIF tags)
- `-Composite:all` (all derived tags — read-only)

## EXIF — capture metadata

| Tag | Notes |
|-----|-------|
| `DateTimeOriginal` | Capture moment. Wall-clock; pair with `OffsetTimeOriginal` for TZ. |
| `CreateDate` | Often equal to `DateTimeOriginal`. |
| `ModifyDate` | Last-edited timestamp (in EXIF, not filesystem). |
| `OffsetTime` / `OffsetTimeOriginal` / `OffsetTimeDigitized` | TZ offsets like `+09:00`. |
| `Make`, `Model`, `LensModel` | Camera/lens identification. |
| `ISO`, `FNumber`, `ExposureTime`, `FocalLength` | Exposure settings. |
| `Orientation` | 1..8 (rotation/flip flag, NOT pixel rotation). |
| `Software` | Often the editor or firmware version. |
| `SerialNumber`, `LensSerialNumber` | Personally identifying — consider stripping for public sharing. |

## EXIF GPS sub-group

| Tag | Notes |
|-----|-------|
| `GPSLatitude` / `GPSLatitudeRef` | Magnitude + `N`/`S`. |
| `GPSLongitude` / `GPSLongitudeRef` | Magnitude + `E`/`W`. |
| `GPSAltitude` / `GPSAltitudeRef` | `0` = above sea level, `1` = below. |
| `GPSDateStamp` / `GPSTimeStamp` | UTC, separate from EXIF dates. |
| `GPSProcessingMethod` | e.g., `GPS`, `CELLID`, `MANUAL`. |

## XMP — broader, Unicode-friendly

| Tag | Notes |
|-----|-------|
| `XMP-dc:Title`, `XMP-dc:Subject`, `XMP-dc:Description` | Dublin Core; widely supported. |
| `XMP-dc:Creator`, `XMP-dc:Rights` | Authorship. |
| `XMP-photoshop:DateCreated` | Often used by Lightroom/Photoshop. |
| `XMP-iptcExt:LocationShown*` | Structured location info. |
| `XMP-GPS:GPSLatitude` / `GPSLongitude` | XMP-stored GPS (HEIC, some Android). |

## IPTC — legacy news/photo tags

| Tag | Notes |
|-----|-------|
| `IPTC:Caption-Abstract` | Caption / description. Historical name kept by spec. |
| `IPTC:Keywords` | Multi-value keywords. |
| `IPTC:By-line` / `IPTC:By-lineTitle` | Author. |
| `IPTC:City`, `IPTC:Country-PrimaryLocationName` | Location. |

## Composite — derived, read-only

| Tag | Composed from |
|-----|---------------|
| `Composite:GPSPosition` | `GPSLatitude` + `GPSLatitudeRef` + `GPSLongitude` + `GPSLongitudeRef`, formatted. |
| `Composite:GPSDateTime` | `GPSDateStamp` + `GPSTimeStamp`. |
| `Composite:ImageSize` | `ImageWidth` + `ImageHeight`. |
| `Composite:Aperture`, `Composite:ShutterSpeed`, `Composite:FOV` | Computed from raw EXIF values. |

**Composite tags cannot be written.** See pitfall P-001 in `safety.md`.

## QuickTime / MP4 — video

| Tag | Notes |
|-----|-------|
| `QuickTime:CreateDate` / `QuickTime:ModifyDate` | UTC by spec (P-005). |
| `QuickTime:Duration` | Seconds. |
| `QuickTime:VideoFrameRate`, `VideoCodec` | Stream characteristics. |
| `QuickTime:GPSCoordinates` | Single-string lat,lon,alt for whole-clip location. |

## MakerNote — manufacturer-specific

Read-only in most cases. See `references/upstream/tag-names/<vendor>.md`
(Phase 2) for full enumeration. Common groups encountered:

- `Canon:`, `Nikon:`, `Sony:`, `Fujifilm:`, `Panasonic:`, `Olympus:`,
  `Pentax:`, `Apple:` (HEIC iPhone metadata), `DJI:` (drones),
  `GoPro:` (action cameras).

## File group — filesystem operations

| Tag | Notes |
|-----|-------|
| `FileName` | Used with `-FileName<...` to rename. |
| `Directory` | Used with `-Directory<...` to move. |
| `FileModifyDate` | Filesystem mtime — not a metadata write (P-003). |

## See also

- `references/safety.md` for write-safety rules.
- `references/tasks/<topic>.md` for command patterns by use case.
- `references/upstream/tag-names/` (Phase 2) for exhaustive listings.
