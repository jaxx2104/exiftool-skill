---
generated_from: vendor/exiftool/html/TagNames/GPS.html
upstream_version: 13.58
upstream_commit: 38bdbace
generated_at: 2026-05-11
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not
> edit by hand — edits will be overwritten on next regeneration.
> To change wording, edit the corresponding file in
> `vendor/exiftool/html/` upstream or override behavior in
> `references/tasks/`.
GPS Tags

## GPS Tags

These GPS tags are part of the EXIF standard, and are stored in a separate
IFD within the EXIF information.

ExifTool is very flexible about the input format when writing lat/long
coordinates, and will accept from 1 to 3 floating point numbers (for decimal
degrees, degrees and minutes, or degrees, minutes and seconds) separated by
just about anything, and will format them properly according to the EXIF
specification.

Some GPS tags have values which are fixed-length strings. For these, the
indicated string lengths include a null terminator which is added
automatically by ExifTool. Remember that the descriptive values are used
when writing (eg. 'Above Sea Level', not '0') unless the print conversion is
disabled (with '-n' on the command line or the [PrintConv](https://exiftool.org/ExifTool.html#PrintConv) option in the API,
or by suffixing the tag name with a `#` character).

When adding GPS information to an image, it is important to set all of the
following tags: GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef,
and GPSAltitude and GPSAltitudeRef if the altitude is known. ExifTool will
write the required GPSVersionID tag automatically if new a GPS IFD is added
to an image.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0x0000 | GPSVersionID | int8u[4]: |  | | 0x0001 | GPSLatitudeRef | string[2] | (tags 0x0001-0x0006 used for camera location according to MWG 2.0. ExifTool will also accept a number when writing GPSLatitudeRef, positive for north latitudes or negative for south, or a string containing N, North, S or South)  'N' = North  'S' = South | | 0x0002 | GPSLatitude | rational64u[3] |  | | 0x0003 | GPSLongitudeRef | string[2] | (ExifTool will also accept a number when writing this tag, positive for east longitudes or negative for west, or a string containing E, East, W or West)  'E' = East  'W' = West | | 0x0004 | GPSLongitude | rational64u[3] |  | | 0x0005 | GPSAltitudeRef | int8u | (ExifTool will also accept number when writing this tag, with negative numbers indicating below sea level)  0 = Above Sea Level  1 = Below Sea Level  2 = Positive Sea Level (sea-level ref)  3 = Negative Sea Level (sea-level ref) | | 0x0006 | GPSAltitude | rational64u |  | | 0x0007 | GPSTimeStamp | rational64u[3] | (UTC time of GPS fix. When writing, date is stripped off if present, and time is adjusted to UTC if it includes a timezone) | | 0x0008 | GPSSatellites | string |  | | 0x0009 | GPSStatus | string[2] | 'A' = Measurement Active  'V' = Measurement Void | | 0x000a | GPSMeasureMode | string[2] | 2 = 2-Dimensional Measurement  3 = 3-Dimensional Measurement | | 0x000b | GPSDOP | rational64u |  | | 0x000c | GPSSpeedRef | string[2] | 'K' = km/h  'M' = mph  'N' = knots | | 0x000d | GPSSpeed | rational64u |  | | 0x000e | GPSTrackRef | string[2] | 'M' = Magnetic North  'T' = True North | | 0x000f | GPSTrack | rational64u |  | | 0x0010 | GPSImgDirectionRef | string[2] | 'M' = Magnetic North  'T' = True North | | 0x0011 | GPSImgDirection | rational64u |  | | 0x0012 | GPSMapDatum | string |  | | 0x0013 | GPSDestLatitudeRef | string[2] | (tags 0x0013-0x001a used for subject location according to MWG 2.0)  'N' = North  'S' = South | | 0x0014 | GPSDestLatitude | rational64u[3] |  | | 0x0015 | GPSDestLongitudeRef | string[2] | 'E' = East  'W' = West | | 0x0016 | GPSDestLongitude | rational64u[3] |  | | 0x0017 | GPSDestBearingRef | string[2] | 'M' = Magnetic North  'T' = True North | | 0x0018 | GPSDestBearing | rational64u |  | | 0x0019 | GPSDestDistanceRef | string[2] | 'K' = Kilometers  'M' = Miles  'N' = Nautical Miles | | 0x001a | GPSDestDistance | rational64u |  | | 0x001b | GPSProcessingMethod | undef | (values of "GPS", "CELLID", "WLAN" or "MANUAL" by the EXIF spec.) | | 0x001c | GPSAreaInformation | undef |  | | 0x001d | GPSDateStamp | string[11] | (when writing, time is stripped off if present, after adjusting date/time to UTC if time includes a timezone. Format is YYYY:mm:dd) | | 0x001e | GPSDifferential | int16u | 0 = No Correction  1 = Differential Corrected | | 0x001f | GPSHPositioningError | rational64u |  | |

---

(This document generated automatically by Image::ExifTool::BuildTagLookup)
  
*Last revised Mar 3, 2025*

[<-- ExifTool Tag Names](https://exiftool.org/TagNames/index.html)
