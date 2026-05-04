---
generated_from: vendor/exiftool/html/geotag.html
upstream_version: 13.57
upstream_commit: dae9b7a8
generated_at: 2026-05-04
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not
> edit by hand — edits will be overwritten on next regeneration.
> To change wording, edit the corresponding file in
> `vendor/exiftool/html/` upstream or override behavior in
> `references/tasks/`.
Geotagging with ExifTool

[Implementation](#Implementation)
  
  - [Geotag](#geotag)
  
  - [Geosync](#geosync)
  
  - [Geotime](#geotime)
  
[Writing Geolocation](#Geolocation)
  
[CSV File Format](#CSVFormat)
  
[Examples](#Examples)
  
[Options](#Options)
  
[Orientation](#Orient)
  
[Troubleshooting](#Troubleshooting)
  
[Tips](#Tips)

---

[Inverse Geotagging](#Inverse)
  
  - [Creating GPX log](#GPX)
  
  - [Creating KML file](#KML)

# Geotagging with ExifTool

The ExifTool geotagging feature adds GPS tags to images based on data from a
GPS track log file or any supported file(s) containing GPS information. The GPS
track log is loaded, and linear interpolation is used to determine the GPS
position at the time of the image, then the following tags are written to the
image (if the corresponding information is available):

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| GPSLatitude | GPSLongitude | GPSAltitude | CameraElevationAngle | GPSPitch |
| GPSLatitudeRef | GPSLongitudeRef | GPSAltitudeRef | GPSDateStamp | GPSRoll |
| GPSTrack | GPSSpeed | GPSImgDirection | GPSTimeStamp |  |
| GPSTrackRef | GPSSpeedRef | GPSImgDirectionRef | GPSHPositioningError |  |
| GPSCoordinates | AmbientTemperature | GPSMeasureMode | GPSDOP |  |

> *Note: GPSPitch and GPSRoll are not standard tags, and
> must be [user-defined](#Orient). GPSCoordinates is written to
> the preferred QuickTime group when writing QuickTime-format files.*

Currently supported GPS track log file formats:

- GPX
- NMEA (RMC, GGA, GLL and GSA sentences)
- KML
- IGC (glider format)
- Garmin XML and TCX
- Magellan eXplorist PMGNTRK
- Honeywell PTNTHPR (see [Orientation](#Orient))
- Bramor gEO log
- Winplus Beacon .TXT
- [Garmin .FIT](https://exiftool.org/TagNames/Garmin.html#FIT)
- Google Takeout .JSON
- GPS/IMU .CSV
- DJI .CSV
- Columbus .CSV
- [ExifTool .CSV file](#CSVFormat)
- Plus any supported file(s) containing GPS metadata!

### Implementation

Geotagging is accomplished in ExifTool through the use of three special
write-only [Extra tags](tag-names/extra.md):
`Geotag`, `Geosync` and `Geotime`.

#### Geotag

The `Geotag` tag is used to define the GPS track log data. The
geotagging feature is activated by assigning the name of a track log file
or any file(s) containing GPS to this tag. As an example, the following
command line adds GPS tags to all images in the "/Users/Phil/Pictures"
directory based on GPS positions stored in the track log file "track.log" in
the current directory:

```
exiftool -geotag=track.log /Users/Phil/Pictures
```

For convenience (and to make this feature more prominent in the
documentation), the exiftool application also provides a `-geotag`
option, so this command is equivalent to the one above:

```
exiftool -geotag track.log /Users/Phil/Pictures
```

Multiple GPS log files may be loaded simultaneously by using more than one
`-geotag` option or `-geotag=` assignment in the same
command, and/or by using wildcards in the filename argument of the
`-geotag` option (note that wildcards are not supported with the
`-geotag=` syntax). This allows batch processing of images
spanning different tracks or geotagging from a set of already-geotagged
files with a single command. When using wildcards the argument may need to
be quoted on some systems to prevent shell globbing. For example, to geotag
images in an "inbox" directory from a set of already-geotagged images in the
current directory:

```
exiftool -geotag "*.jpg" inbox
```

See the [examples](#Examples) below for more examples.

Deleting the `Geotag` tag (with `-geotag=`) causes the
GPS tags written by the `-geotag` feature to be deleted.

A special feature allows writing of only GPS date/time tags when there is no
position available by specifying a log file name of "DATETIMEONLY" (all
capitals).

> **Programmers**: You may write either a GPS log file name
> or the GPS log data as the value for `Geotag`. If the value contains
> a newline or a null byte it is assumed to be data, otherwise it is taken as a
> file name.

#### Geosync

The `Geosync` tag is needed only when the image timestamps are not
properly synchronized with GPS time. The value written to `Geosync`
may take a number of different forms, but the basic format is that of a simple
time difference which is added to `Geotime` before interpolating the
GPS position in the track log. This time difference may be of the form "SS",
"MM:SS", "HH:MM:SS" or "DD HH:MM:SS" (where SS=seconds, MM=minutes, HH=hours and
DD=days), and a leading "+" or "-" may be added for positive or negative
differences (positive if the GPS time was ahead of the camera clock).
Fractional seconds are allowed (eg. "SS.ss").

For example, "`-geosync=-1:20`" specifies that synchronization
with GPS time is achieved by subtracting 1 minute and 20 seconds from the
`Geotime` value. See the [Time Synchronization Tip](#TP1)
below for more details.

> *Note that a single decimal value is interpreted as
> seconds when written to `Geosync`. This is different from of other
> date/time shift values where a single value is normally taken as hours.*

The `Geosync` value may also be specified using 3 different
formats which provide a GPS time and a corresponding camera clock time. While
these formats may be used for a simple (constant) time synchronization offset,
they are necessary when performing a clock drift correction (with multiple
synchronization points), and are described below.

**Camera clock drift correction:**

A more advanced `Geosync` feature allows the GPS time and the
image time to be specified together, facilitating a time drift correction if
more than one synchronization point is provided. For this, the value written to
`Geosync` takes one of the following forms:

> | Format | Notes |
> | --- | --- |
> | *FILE* | Both GPS and image timestamps are extracted from the specified file. eg) `-geosync=image.jpg` |
> | *GPSTIME*@*FILE* | GPS time is taken from the `Geosync` value and the image timestamp is extracted from the specified file. eg) `-geosync="12:58:05@image.jpg"` |
> | *GPSTIME*@*IMGTIME* | Both GPS and image timestamps are taken from the `Geosync` value. eg) `-geosync="12:58:05@2010:01:02 12:25:26"` |

The values of *GPSTIME* and *IMGTIME* specified on the command line
may contain a date, but it is not necessary.

Notes:

1. If either the GPS or the image timestamp does not contain a date, the two
   timestamps are assumed to be on days which place them within 12 hours of each
   other.
2. If neither the GPS nor the image timestamps contain a date, this
   synchronization point may only be used for constant time offset (ie. no time
   drift correction will be applied).
3. Both the GPS and the image times are assumed to be local unless another
   timezone is specified (unless taken from GPSTimeStamp which is UTC).
4. Both the GPS and the image time values may contain decimal seconds.
5. The applied value of the time drift correction is calculated from a
   piecewise linear interpolation/extrapolation between the synchronization points
   if more than one `Geosync` value is defined.
6. When extracting from file, timestamps are taken from the first available of
   the following tags:
   - Image timestamp: SubSecDateTimeOriginal, SubSecCreateDate, SubSecModifyDate,
     DateTimeOriginal, CreateDate, ModifyDate, FileModifyDate
   - GPS timestamp: GPSDateTime, GPSTimeStamp

#### Geotime

The `Geotime` tag specifies the point in time for which the GPS
position is calculated (by interpolating between fixes in the GPS track log).
Unless a group is specified, exiftool writes the generated tags to the default
groups. If a value for `Geotime` is not given, it is taken from
unformatted value of `SubSecDateTimeOriginal` (preferentially) or
`DateTimeOriginal` for each image, but the value may be copied from
any other date/time tag or set directly from a date/time string. The exact form
of the default `Geotime` argument is:

```
"-Geotime<${DateTimeOriginal#;$_=$self->GetValue('SubSecDateTimeOriginal','ValueConv') || $_}"
```

If the date/time tag does not include a timezone then one may be added (eg.
`"-Geotime<${CreateDate}-05:00"`), otherwise the local system time
is assumed. Decimal seconds are supported in the time value.

By default, in image files GPS tags are created in EXIF and the corresponding
XMP tags are updated in only if they already exist. In QuickTime-format files
the XMP tags are created by default as well as writing QuickTime:GPSCoordinates
in the preferred location. However, an EXIF, XMP or QuickTime group name may be
specified to force writing only to the specified location. For example, writing
`XMP:Geotime` or `EXIF:Geotime` will write the generated
GPS tags only to XMP or EXIF respectively. Note that when written to XMP, the
`GPSLatitudeRef` and `GPSLongitudeRef` tags are not used,
and the XMP `GPSDateTime` tag is written instead of the separate EXIF
`GPSDateStamp` and `GPSTimeStamp` tags. Using
`QuickTime:Geotime` disables writing of XMP tags to QuickTime-format
files creates the GPSPosition tag in the preferred QuickTime location (ItemList
by default), but `ItemList:Geotime`, `UserData:Geotime` or
`Keys:Geotime` may be specified to write to a specific location.

See the [Examples](#Examples) section below for sample command
lines illustrating various aspects of the geotagging feature.

> **Programmers**: Note that `Geotime` must always
> be specified when geotagging via the API (the default value is implemented by
> the application). Also, `Geotime` must be set after both
> `Geotag` and `Geosync` (the exiftool application reorders
> the assignments to ensure this).

### Writing Geolocation Tags while Geotagging

Geolocation city, state/province and country tags may be written automatically
based on the geotagged GPS position by setting the Geolocate tag to "geotag".
For example:

```
exiftool -geotag track.gpx -geolocate=geotag c:\images
```

See the
["While geotagging" section of the Geolocation page](geolocation.md#Geotag)
for more information.

### ExifTool CSV Log File Format

ExifTool supports input log files in CSV format with the first row containing
headings in the form of ExifTool tag names or descriptions. Valid column
headings are:

> | Column Heading | Description |
> | --- | --- |
> | GPSDateTime | Date and time in standard EXIF format, or other format specified by the `-d` option if used. Time is assumed to be in UTC unless the values contain another time zone |
> | GPSDateStamp | Date in standard EXIF format |
> | GPSTimeStamp | Time in EXIF format. UTC is assumed unless the values include a time zone |
> | GPSLatitude | Latitude in flexible ExifTool format (see [FAQ 14](faq.md#Q14)) |
> | GPSLongitude | Longitude in flexible ExifTool format (see [FAQ 14](faq.md#Q14)) |
> | GPSLatitudeRef | String beginning with "S" for southern coordinates (used only if GPSLatitude isn't signed or doesn't specify hemisphere) |
> | GPSLongitudeRef | String beginning with "W" for western coordinates (used only if GPSLongitude isn't signed or doesn't specify hemisphere) |
> | GPSAltitude | Altitude in meters relative to sea level (negative for below sea level) |
> | GPSSpeed | Speed in knots, or specified units if "(km/h)", "(mph)" or "(m/s)" appears in heading |
> | GPSTrack | Compass heading in degrees true |
> | GPSImgDirection | Camera compass direction in degrees true |
> | GPSPitch or CameraElevationAngle | Pitch angle in degrees with positive pitch upwards |
> | GPSRoll | Roll angle in degrees |

Required columns are GPSDateTime (or GPSDateStamp and GPSTimeStamp),
GPSLatitude and GPSLongitude. All other columns are optional, and unrecognized
columns are ignored.

### Examples

1. Geotag all images in the "c:\images" directory from position information in a
GPS track log ("c:\gps logs\track.log"). Since the `Geotime` time is
not specified, the value of `SubSecDateTimeOriginal#` (preferentially)
or `DateTimeOriginal#` is used. Local system time is assumed unless
the date/time value contains a timezone:

```
exiftool -geotag "c:\gps logs\track.log" c:\images
```

2. Geotag all images in directory "dir" from the GPS positions in "track.log"
(in the current directory), for a camera clock that was running 25 seconds
slower than the GPS clock:

```
exiftool -geotag track.log -geosync=+25 dir
```

3. Geotag an image with the GPS position for a specific time:

```
exiftool -geotag t.log -geotime="2009:04:02 13:41:12-05:00" a.jpg
```

4. Geotag all images in directory "dir" with XMP tags instead of EXIF tags,
based on the image `CreateDate`:

```
exiftool -geotag log.gpx "-xmp:geotime<createdate" dir
```

5. Geotag images in "dir" using `CreateDate` with the specified
timezone. If `CreateDate` already contained a timezone, then the
timezone specified on the command line is ignored. (Note that in Windows,
double quotes (`"`) must be used instead of single quotes
(`'`) around the `-geotime` argument in the next 2
commands):

```
exiftool -geotag a.log '-geotime<${createdate}+01:00' dir
```

6. Geotag images for which the camera clock was set to UTC (+00:00), using
the time from `DateTimeOriginal`:

```
exiftool -geotag trk.gpx '-geotime<${DateTimeOriginal}+00:00' dir
```

7. Delete GPS tags which were added by the geotag feature. (Note that this does
not remove all GPS tags -- to do this instead use `-gps:all=`):

```
exiftool -geotag= a.jpg
```

8. Delete XMP GPS tags which were added by the geotag feature:

```
exiftool -xmp:geotag= a.jpg
```

9. Geotag an image with XMP tags, using the time from
`SubSecDateTimeOriginal` or `DateTimeOriginal`:

```
exiftool -xmp:geotag=track.log a.jpg
```

10. Combine multiple track logs and geotag an entire directory tree of
images:

```
exiftool -geotag a.log -geotag b.log -r dir
```

11. Use wildcards to load multiple track files (the quotes are necessary for most
operating systems to prevent filename expansion):

```
exiftool -geotag "logs/*.log" dir
```

12. Geotag from a sub-second date/time value with a sub-second time synchronization
(only possible if the EXIF sub-second time stamps or time zone are available).
*[Note that this example is obsolete since ExifTool 13.29 because
SubSecDateTimeOriginal is used by default if available.]*

```
exiftool -Geotag a.log -Geosync=+13.42 "-Geotime<SubSecDateTimeOriginal" dir
```

13. Geotag images with a piecewise linear time drift correction using the GPS
time synchronization from three already-geotagged images:

```
exiftool -geotag a.log -geosync=1.jpg -geosync=2.jpg -geosync=3.jpg dir
```

14. Geotag MP4 videos by writing Keys:GPSCoordinates (add
`-api QuickTimeUTC` to this command if CreateDate in your
videos is UTC):

```
exiftool -geotag a.log "-keys:geotime<createdate" -ext MP4 dir
```

15. Geotag images in EXIF by DateTimeOriginal and videos in UserData
by CreateDate:

```
exiftool -geotag a.log "-exif:geotime<datetimeoriginal" "-userdata:geotime<createdate" dir
```

15. Geotag images from timed GPS metadata in a video file (internally, ExifTool
uses the [API ExtractEmbedded option](https://exiftool.org/ExifTool.html#ExtractEmbedded)
to extract the timed GPS from the video, then uses this as the track for
geotagging the image files):

```
exiftool -geotag video.mp4 c:\images
```

### Options

Geotagging may be configured via the following ExifTool options. These
options may be set using either the `-api` option of the command-line
application, the Options() function of the API, or the
%Image::ExifTool::UserDefined::Options hash of the config file. (See the
[sample config file](https://exiftool.org/config.html) for details about how to use the
config file.)

> | Option | Description | Values | Default |
> | --- | --- | --- | --- |
> | GeoMaxIntSecs | Maximum interpolation time in seconds for geotagging. Geotagging is treated as an extrapolation if the Geotime value lies between two fixes in the same track which are separated by a number of seconds greater than this. Otherwise, the coordinates are calculated as a linear interpolation between the nearest fixes on either side of the Geotime value. Set to 0 to disable interpolation and use the coordinates of the nearest fix instead (provided it is within GeoMaxExtSecs, otherwise geotagging fails). | A floating point number | 1800 |
> | GeoMaxExtSecs | Maximum extrapolation time in seconds for geotagging. Geotagging fails if the Geotime value lies outside a GPS track by a number of seconds greater than this. Otherwise, the coordinates of the nearest fix are taken. | A floating point number | 1800 |
> | GeoMaxHDOP | Maximum Horizontal (2D) Dilution Of Precision for geotagging. GPS fixes are ignored if the HDOP is greater than this. | A floating point number, or undef to disable | undef |
> | GeoMaxPDOP | Maximum Position (3D) Dilution Of Precision for geotagging. GPS fixes are ignored if the PDOP is greater than this. | A floating point number, or undef to disable | undef |
> | GeoHPosErr | Expression to set GPSHPositioningError based on value of GPSDOP when geotagging. For example, use `'$GPSDOP * 4'` to set GPSHPositioningError to 4 times GPSDOP. | Perl expression using `$GPSDOP` | undef |
> | GeoMinSats | Minimum number of satellites for geotagging. GPS fixes are ignored if the number of acquired satellites is less than this. | A positive integer, or undef to disable | undef |
> | GeoSpeedRef | Reference units for writing GPSSpeed when geotagging. | |  |  | | --- | --- | | **K**, **k** or **km/h** | = km/h | | **M**, **m** or **mph** | = mph | | *(anything else)* | = knots | | undef |
> | GeoUserTag | Additional user-defined tags to write when geotagging from GPX or CSV files. Format is '*TAG*=*TOKEN*,...' where *TAG* is an ExifTool tag name (with optional group name), and *TOKEN* is is the property name in the GPX file or the column name in the CSV file. eg) '`Location=desc`' will write the Location tag based on value of 'desc' in the GPS log file. The tag value is taken from the nearest fix in time. Multiple tags may be specified using comma separators. | String of the form '*TAG*=*TOKEN*,...' | undef |

### Orientation

ExifTool reads orientation information from the PTNTHPR sentence generated by
some Honeywell digital compasses. This is a proprietary NMEA sentence which
contains information about heading, pitch and roll angles. When this
information is available, the heading is written to GPSImgDirection (and
GPSImgDirectionRef is set to "T"), and pitch to CameraElevationAngle, but no
standard tag exists for roll. Regardless, ExifTool attempts to write
GPSRoll (and GPSPitch). For these tags to be written, appropriate
user-defined tags must be created. Below is a simple config file which
defines the necessary EXIF GPS tags. Corresponding XMP-exif tags may also be
created. See the [config file documentation](https://exiftool.org/config.html) for
more information.

```
%Image::ExifTool::UserDefined = (
    'Image::ExifTool::GPS::Main' => {
        0xd000 => {
            Name => 'GPSPitch',
            Writable => 'rational64s',
        },
        0xd001 => {
            Name => 'GPSRoll',
            Writable => 'rational64s',
        },
    },
);
1; #end
```

### Troubleshooting

1. **"No track points found in GPS file"**

> If you see the above message, either exiftool does not yet support
> your track log file format, or your track log does not contain the necessary
> position/timestamp information. For instance, in KML files each Placemark must
> contain a TimeStamp. If you believe your track log contains the necessary
> information, please send me a sample file and I will add support for this
> format.

2. **"No writable tags set"** or **"0 image files updated"**

> If you see these without any other warning messages, it is likely
> that `Geotime` didn't get set properly.

> Be sure that the necessary date/time tag exists in your image for
> copying to `Geotime`. Unless otherwise specified, the required tag
> is `DateTimeOriginal`. The following command may be used to list the
> names and values of all available date/time tags in an image:
>
> ```
> exiftool -s -time:all image.jpg
> ```
>
> Even if there is no metadata in the image you may be able to set
> `Geotime` from the filesystem modification date for the image (which
> will appear as `FileModifyDate` in the output of the above command).
> In this case you may also want to include the `-P` option to preserve
> the original value of `FileModifyDate`:
>
> ```
> exiftool -geotag track.gpx "-geotime<filemodifydate" -P image.jpg
> ```
>
> Without the `-P` option, `FileModifyDate` is set to the
> current date/time when the file is rewritten.

3. **"Warning: Time is too far before track in File:Geotime (ValueConvInv)"**

> If you see a warning like this, you may have a time zone problem,
> or a time synchronization issue. Keep in mind that GPS times are in UTC, but
> the camera times are typically in your local time zone.

> To see more details about what ExifTool is doing, try adding the
> `-v2` option to your command. You should then see messages like
> this if the GPS track log was loaded successfully:
>
> ```
> Loaded 372 points from GPS track log file 'my_track.log'
>   GPS track start: 2009:03:30 19:45:25 UTC
>   GPS track end:   2009:04:03 11:16:04 UTC
> ```
>
> If the number of points loaded and start/end times seem reasonable, then
> the problem is likely in the time synchronization. Also printed will be the
> UTC time for the image:
>
> ```
>   Geotime value:   2009:04:03 10:57:01 UTC (local timezone is -05:00)
> ```
>
> The "Geotime value" must lie within 1/2 hour of a valid GPS fix in the track log
> for a position to be calculated. (1/2 hour is the default, but this can be
> configured via the geotagging [Options](#Options).) The time
> calibration relies on proper synchronization between the GPS time and your
> camera's clock. If a timezone is not specified, the local system time zone (as
> set by the shell's TZ environment variable) is printed in the above message and
> used to convert the `Geotime` value to UTC. You should specify the
> timezone for `Geotime` if your images were taken in a different
> timezone (see [Examples](#Examples) above). If the camera clock was
> wrong, the `Geosync` tag may be used to apply a time correction, or
> the ExifTool time shift feature may be used to adjust the image times before
> geotagging -- see the [Time Synchronization](#TP1) tip below for
> examples.

### Tips

**1. Time Synchronization**

> One way to accurately synchronize your images with GPS time is to
> take a picture of the time displayed on your GPS unit while you are out
> shooting. Then after you download your images you can use this image to
> synchronize the image timestamps for geotagging. This is done by using an image
> viewer to read the time from the GPS display in the image, and exiftool to
> extract `DateTimeOriginal` from the file. For example, if the time in
> the GPS display reads 19:32:21 UTC and `DateTimeOriginal` is
> 14:31:49, then for this image the camera clock was 32 seconds slow (assuming
> that the timezone of the camera clock was -05:00). There
> are various ways to use this time synchronization to improve your geotagging
> accuracy:

> A) Use the `Geosync` tag to specify the time difference
> while geotagging. Using this technique the existing image timestamps will not
> be corrected, but the `GPSTimeStamp` tag created by the geotagging
> process will contain the correct GPS time:
>
> ```
> exiftool -geosync=+00:00:32 -geotag my_gps.log C:\Images
> ```
>
> or equivalently,
>
> ```
> exiftool -geosync=19:32:21Z@14:31:49-05:00 -geotag my_gps.log C:\Images
> ```
>
> *(Note that this technique may also be used for a more advanced time
> drift correction. See the [Geosync section above](#geosync) for
> details)*

> B) First fix the image timestamps by shifting them to synchronize
> with GPS time, then geotag using the corrected timestamps:
>
> ```
> exiftool -alldates+=00:00:32 C:\Images
> exiftool -geotag my_gps.log C:\Images
> ```
>
> C) Do both in the same command:
>
> ```
> exiftool -alldates+=00:00:32 -geosync=+00:00:32 -geotag my_gps.log C:\Images
> ```
>
> The examples above assume that your track log file (`my_gps.log`)
> is in the current directory, that the images were downloaded to the
> `C:\Images` directory, and that the computer and camera clocks are
> in the same timezone.

---

## Inverse Geotagging

ExifTool also has the ability to **create a GPS track file from a series of
geotagged images**. The `-p` option may be used to output files in
any number of formats. This section gives examples for creating GPX and KML
output files from a set of geotagged images, or from a geotagged video file.
(But note that the `-ee3` option must be added to the commands below
to extract the full track from a video file.)

> *(This is different from what is sometimes called
> "reverse geocoding", which is the [ExifTool Geolocation feature](geolocation.md).)*

#### Creating a GPX track log

The following print format file may be used to generate a GPX track log from
one or more geotagged images:

```
#------------------------------------------------------------------------------
# File:         gpx.fmt
#
# Description:  Example ExifTool print format file to generate a GPX track log
#
# Usage:        exiftool -p gpx.fmt -ee3 FILE [...] > out.gpx
#
# Requires:     ExifTool version 10.49 or later
#
# Revisions:    2010/02/05 - P. Harvey created
#               2018/01/04 - PH Added IF to be sure position exists
#               2018/01/06 - PH Use DateFmt function instead of -d option
#               2019/10/24 - PH Preserve sub-seconds in GPSDateTime value
#
# Notes:     1) Input file(s) must contain GPSLatitude and GPSLongitude.
#            2) The -ee3 option is to extract the full track from video files.
#            3) The -fileOrder option may be used to control the order of the
#               generated track points when processing multiple files.
#------------------------------------------------------------------------------
#[HEAD]<?xml version="1.0" encoding="utf-8"?>
#[HEAD]<gpx version="1.0"
#[HEAD] creator="ExifTool $ExifToolVersion"
#[HEAD] xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#[HEAD] xmlns="http://www.topografix.com/GPX/1/0"
#[HEAD] xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd">
#[HEAD]<trk>
#[HEAD]<number>1</number>
#[HEAD]<trkseg>
#[IF]  $gpslatitude $gpslongitude
#[BODY]<trkpt lat="$gpslatitude#" lon="$gpslongitude#">
#[BODY]  <ele>$gpsaltitude#</ele>
#[BODY]  <time>${gpsdatetime#;my ($ss)=/\.\d+/g;DateFmt("%Y-%m-%dT%H:%M:%SZ");s/Z/${ss}Z/ if $ss}</time>
#[BODY]</trkpt>
#[TAIL]</trkseg>
#[TAIL]</trk>
#[TAIL]</gpx>
```

This example assumes that the `GPSLatitude`,
`GPSLongitude`, `GPSAltitude` and `GPSDateTime`
tags are all available in each processed *FILE*. Warnings will be
generated for missing tags. The output GPX format will invalid if any
`GPSLatitude` or `GPSLongitude` tags are missing, but will
be OK for missing `GPSAltitude` or `GPSDateTime` tags.

Note that the order of track points in the output GPX file will be the same
as the order of processing the input files, which may not be chronological
depending on how the files are named. The `-fileOrder` option may be
used to force processing of files in a particular order. For example, the
following command processes files in order of increasing `GPSDateTime`:

```
exiftool -fileOrder gpsdatetime -p gpx.fmt /Users/Phil/Pictures > out.gpx
```

Since no directory was specified for `gpx.fmt`, this file must
exist in the current directory when the above command is executed. (If the
`gpx.fmt` file can't be found then the `-p` argument is
interpreted as a string instead of a file name, and the text
"`gpx.fmt`" is sent to the output, which isn't what we want.)

The `-if` option may be added to ensure that only files containing
GPS information are processed. For example, the following command creates
"`out.gpx`" in the current directory from all pictures containing
`GPSDateTime` information in directory "`pics`" and its
sub-directories:

```
exiftool -r -if '$gpsdatetime' -fileOrder gpsdatetime -p gpx.fmt pics > out.gpx
```

Note: In Windows, double quotes (`"`) must be used instead of
single quotes (`'`) around the `-if` argument above.

The "fmt\_files" directory of the full exiftool distribution contains this
sample format file ("gpx.fmt") as well as a sample which creates GPX waypoints
with pictures ("gpx\_wpt.fmt").

#### Creating a Google Earth KML file

Below is an example of a print format file which generates a Google Earth KML
file from a collection of geotagged images. This example uses the SECT feature added
in ExifTool 10.41 to divide the placemarks into folders based on directory name:

```
#------------------------------------------------------------------------------
# File:         kml.fmt
#
# Description:  Example ExifTool print format file for generating a
#               Google Earth KML file from a collection of geotagged images
#
# Usage:        exiftool -p kml.fmt -r DIR [...] > out.kml
#
# Requires:     ExifTool version 10.41 or later
#
# Revisions:    2010/02/05 - P. Harvey created
#               2013/02/05 - PH Fixed camera icon to work with new Google Earth
#               2017/02/02 - PH Organize into folders based on file directory
#               2018/01/04 - PH Added IF to be sure position exists
#               2020/01/11 - F. Kotov Limited image preview size to 500px
#
# Notes:     1) Input files must contain GPSLatitude and GPSLongitude.
#            2) Add the -ee3 option to extract the full track from video files.
#            3) For Google Earth to be able to find the images, the input
#               images must be specified using relative paths, and "out.kml"
#               must stay in the same directory as where the command was run.
#            4) Google Earth is picky about the case of the image file extension,
#               and may not be able to display the image if an upper-case
#               extension is used.
#            5) The -fileOrder option may be used to control the order of the
#               generated placemarks when processing multiple files.
#------------------------------------------------------------------------------
#[HEAD]<?xml version="1.0" encoding="UTF-8"?>
#[HEAD]<kml xmlns="http://earth.google.com/kml/2.0">
#[HEAD]  <Document>
#[HEAD]    <name>My Photos</name>
#[HEAD]    <open>1</open>
#[HEAD]    <Style id="Photo">
#[HEAD]      <IconStyle>
#[HEAD]        <Icon>
#[HEAD]          <href>http://maps.google.com/mapfiles/kml/pal4/icon38.png</href>
#[HEAD]          <scale>1.0</scale>
#[HEAD]        </Icon>
#[HEAD]      </IconStyle>
#[HEAD]    </Style>
#[SECT]    <Folder>
#[SECT]      <name>$main:directory</name>
#[SECT]      <open>0</open>
#[IF]  $gpslatitude $gpslongitude
#[BODY]      <Placemark>
#[BODY]        <description><![CDATA[<img src='$main:directory/$main:filename'
#[BODY]          style='max-width:500px;max-height:500px;'> ]]>
#[BODY]        </description>
#[BODY]        <Snippet/>
#[BODY]        <name>$filename</name>
#[BODY]        <styleUrl>#Photo</styleUrl>
#[BODY]        <Point>
#[BODY]          <altitudeMode>clampedToGround</altitudeMode>
#[BODY]          <coordinates>$gpslongitude#,$gpslatitude#,0</coordinates>
#[BODY]        </Point>
#[BODY]      </Placemark>
#[ENDS]    </Folder>
#[TAIL]  </Document>
#[TAIL]</kml>
```

This example file is included in the "fmt\_files" directory of the full
ExifTool distribution. See
[this
forum post](https://exiftool.org/forum/index.php/topic,7836.0.html) for more useful tips about creating KML files.

---

*Created Apr 2, 2009*  
*Last revised Apr 14, 2026*

[<-- Back to ExifTool home page](https://exiftool.org/index.html)
