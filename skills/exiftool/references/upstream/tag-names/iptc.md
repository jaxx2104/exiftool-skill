---
generated_from: vendor/exiftool/html/TagNames/IPTC.html
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
IPTC Tags

## IPTC Tags

The tags listed below are part of the International Press Telecommunications
Council (IPTC) and the Newspaper Association of America (NAA) Information
Interchange Model (IIM). This is an older meta information format, slowly
being phased out in favor of XMP -- the newer IPTCCore specification uses
XMP format. IPTC information may be found in JPG, TIFF, PNG, MIFF, PS, PDF,
PSD, XCF and DNG images.

IPTC information is separated into different records, each of which has its
own set of tags. See
<http://www.iptc.org/std/IIM/4.1/specification/IIMV4.1.pdf> for the
official IPTC IIM specification.

This specification dictates a length for ASCII (`string` or `digits`) and
binary (`undef`) values. These lengths are given in square brackets after
the **Writable** format name. For tags where a range of lengths is allowed,
the minimum and maximum lengths are separated by a comma within the
brackets. When writing, ExifTool issues a minor warning and truncates the
value if it is longer than allowed by the IPTC specification. Minor errors
may be ignored with the [IgnoreMinorErrors](https://exiftool.org/ExifTool.html#IgnoreMinorErrors) (-m) option, allowing longer
values to be written, but beware that values like this may cause problems
for some other IPTC readers. ExifTool will happily read IPTC values of any
length.

Separate IPTC date and time tags may be written with a combined date/time
value and ExifTool automagically takes the appropriate part of the date/time
string depending on whether a date or time tag is being written. This is
very useful when copying date/time values to IPTC from other metadata
formats.

IPTC time values include a timezone offset. If written with a value which
doesn't include a timezone then the current local timezone offset is used
(unless written with a combined date/time, in which case the local timezone
offset at the specified date/time is used, which may be different due to
changes in daylight savings time).

Note that it is not uncommon for IPTC to be found in non-standard locations
in JPEG and TIFF-based images. When reading, the family 1 group name has a
number added for non-standard IPTC ("IPTC2", "IPTC3", etc), but when writing
only "IPTC" may be specified as the group. To keep the IPTC consistent,
ExifTool updates tags in all existing IPTC locations, but will create a new
IPTC group only in the standard location.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Record | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 1 | IPTCEnvelope | - | --> [IPTC EnvelopeRecord Tags](iptc.md#EnvelopeRecord) | | 2 | IPTCApplication | - | --> [IPTC ApplicationRecord Tags](iptc.md#ApplicationRecord) | | 3 | IPTCNewsPhoto | - | --> [IPTC NewsPhoto Tags](iptc.md#NewsPhoto) | | 7 | IPTCPreObjectData | - | --> [IPTC PreObjectData Tags](iptc.md#PreObjectData) | | 8 | IPTCObjectData | - | --> [IPTC ObjectData Tags](iptc.md#ObjectData) | | 9 | IPTCPostObjectData | - | --> [IPTC PostObjectData Tags](iptc.md#PostObjectData) | | 240 | IPTCFotoStation | - | --> [IPTC FotoStation Tags](iptc.md#FotoStation) | |

## IPTC EnvelopeRecord Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | EnvelopeRecordVersion | int16u: |  | | 5 | Destination | string[0,1024]+ |  | | 20 | FileFormat | int16u | 0 = No ObjectData  1 = IPTC-NAA Digital Newsphoto Parameter Record  2 = IPTC7901 Recommended Message Format  3 = Tagged Image File Format (Adobe/Aldus Image data)  4 = Illustrator (Adobe Graphics data)  5 = AppleSingle (Apple Computer Inc)  6 = NAA 89-3 (ANPA 1312)  7 = MacBinary II  8 = IPTC Unstructured Character Oriented File Format (UCOFF)  9 = United Press International ANPA 1312 variant  10 = United Press International Down-Load Message  11 = JPEG File Interchange (JFIF)  12 = Photo-CD Image-Pac (Eastman Kodak)  13 = Bit Mapped Graphics File [.BMP] (Microsoft)  14 = Digital Audio File [.WAV] (Microsoft & Creative Labs)  15 = Audio plus Moving Video [.AVI] (Microsoft)  16 = PC DOS/Windows Executable Files [.COM][.EXE]  17 = Compressed Binary File [.ZIP] (PKWare Inc)  18 = Audio Interchange File Format AIFF (Apple Computer Inc)  19 = RIFF Wave (Microsoft Corporation)  20 = Freehand (Macromedia/Aldus)  21 = Hypertext Markup Language [.HTML] (The Internet Society)  22 = MPEG 2 Audio Layer 2 (Musicom), ISO/IEC  23 = MPEG 2 Audio Layer 3, ISO/IEC  24 = Portable Document File [.PDF] Adobe  25 = News Industry Text Format (NITF)  26 = Tape Archive [.TAR]  27 = Tidningarnas Telegrambyra NITF version (TTNITF DTD)  28 = Ritzaus Bureau NITF version (RBNITF DTD)  29 = Corel Draw [.CDR] | | 22 | FileVersion | int16u |  | | 30 | ServiceIdentifier | string[0,10] |  | | 40 | EnvelopeNumber | digits[8] |  | | 50 | ProductID | string[0,32]+ |  | | 60 | EnvelopePriority | digits[1] | |  | | --- | | 0 = 0 (reserved)  1 = 1 (most urgent)  2 = 2  3 = 3  4 = 4  5 = 5 (normal urgency)  6 = 6  7 = 7  8 = 8 (least urgent)  9 = 9 (user-defined priority) | | | 70 | DateSent | digits[8] |  | | 80 | TimeSent | string[11] |  | | 90 | CodedCharacterSet | string[0,32]! | (values are entered in the form "ESC X Y[, ...]". The escape sequence for UTF-8 character coding is "ESC % G", but this is displayed as "UTF8" for convenience. Either string may be used when writing. The value of this tag affects the decoding of string values in the Application and NewsPhoto records. This tag is marked as "unsafe" to prevent it from being copied by default in a group operation because existing tags in the destination image may use a different encoding. When creating a new IPTC record from scratch, it is suggested that this be set to "UTF8" if special characters are a possibility) | | 100 | UniqueObjectName | string[14,80] |  | | 120 | ARMIdentifier | int16u |  | | 122 | ARMVersion | int16u |  | |

## IPTC ApplicationRecord Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | ApplicationRecordVersion | int16u: |  | | 3 | ObjectTypeReference | string[3,67] |  | | 4 | ObjectAttributeReference | string[4,68]+ |  | | 5 | ObjectName | string[0,64] |  | | 7 | EditStatus | string[0,64] |  | | 8 | EditorialUpdate | digits[2] | 01 = Additional language | | 10 | Urgency | digits[1] | |  | | --- | | 0 = 0 (reserved)  1 = 1 (most urgent)  2 = 2  3 = 3  4 = 4  5 = 5 (normal urgency)  6 = 6  7 = 7  8 = 8 (least urgent)  9 = 9 (user-defined priority) | | | 12 | SubjectReference | string[13,236]+ |  | | 15 | Category | string[0,3] |  | | 20 | SupplementalCategories | string[0,32]+ |  | | 22 | FixtureIdentifier | string[0,32] |  | | 25 | Keywords | string[0,64]+ |  | | 26 | ContentLocationCode | string[3]+ |  | | 27 | ContentLocationName | string[0,64]+ |  | | 30 | ReleaseDate | digits[8] |  | | 35 | ReleaseTime | string[11] |  | | 37 | ExpirationDate | digits[8] |  | | 38 | ExpirationTime | string[11] |  | | 40 | SpecialInstructions | string[0,256] |  | | 42 | ActionAdvised | digits[2] | 01 = Object Kill  02 = Object Replace  03 = Object Append  04 = Object Reference | | 45 | ReferenceService | string[0,10]+ |  | | 47 | ReferenceDate | digits[8]+ |  | | 50 | ReferenceNumber | digits[8]+ |  | | 55 | DateCreated | digits[8] |  | | 60 | TimeCreated | string[11] |  | | 62 | DigitalCreationDate | digits[8] |  | | 63 | DigitalCreationTime | string[11] |  | | 65 | OriginatingProgram | string[0,32] |  | | 70 | ProgramVersion | string[0,10] |  | | 75 | ObjectCycle | string[1] | 'a' = Morning  'b' = Both Morning and Evening  'p' = Evening | | 80 | By-line | string[0,32]+ |  | | 85 | By-lineTitle | string[0,32]+ |  | | 90 | City | string[0,32] |  | | 92 | Sub-location | string[0,32] |  | | 95 | Province-State | string[0,32] |  | | 100 | Country-PrimaryLocationCode | string[3] |  | | 101 | Country-PrimaryLocationName | string[0,64] |  | | 103 | OriginalTransmissionReference | string[0,32] | (now used as a job identifier) | | 105 | Headline | string[0,256] |  | | 110 | Credit | string[0,32] |  | | 115 | Source | string[0,32] |  | | 116 | CopyrightNotice | string[0,128] |  | | 118 | Contact | string[0,128]+ |  | | 120 | Caption-Abstract | string[0,2000] |  | | 121 | LocalCaption | string[0,256] | (I haven't found a reference for the format of tags 121, 184-188 and 225-232, so I have just make them writable as strings with reasonable length. Beware that if this is wrong, other utilities may not be able to read these tags as written by ExifTool) | | 122 | Writer-Editor | string[0,32]+ |  | | 125 | RasterizedCaption | undef[7360] |  | | 130 | ImageType | string[2] |  | | 131 | ImageOrientation | string[1] | 'L' = Landscape  'P' = Portrait  'S' = Square | | 135 | LanguageIdentifier | string[2,3] |  | | 150 | AudioType | string[2] | |  | | --- | | '0T' = Text Only  '1A' = Mono Actuality  '1C' = Mono Question and Answer Session  '1M' = Mono Music  '1Q' = Mono Response to a Question  '1R' = Mono Raw Sound  '1S' = Mono Scener  '1V' = Mono Voicer  '1W' = Mono Wrap  '2A' = Stereo Actuality  '2C' = Stereo Question and Answer Session  '2M' = Stereo Music  '2Q' = Stereo Response to a Question  '2R' = Stereo Raw Sound  '2S' = Stereo Scener  '2V' = Stereo Voicer  '2W' = Stereo Wrap | | | 151 | AudioSamplingRate | digits[6] |  | | 152 | AudioSamplingResolution | digits[2] |  | | 153 | AudioDuration | digits[6] |  | | 154 | AudioOutcue | string[0,64] |  | | 184 | JobID | string[0,64] |  | | 185 | MasterDocumentID | string[0,256] |  | | 186 | ShortDocumentID | string[0,64] |  | | 187 | UniqueDocumentID | string[0,128] |  | | 188 | OwnerID | string[0,128] |  | | 200 | ObjectPreviewFileFormat | int16u | 0 = No ObjectData  1 = IPTC-NAA Digital Newsphoto Parameter Record  2 = IPTC7901 Recommended Message Format  3 = Tagged Image File Format (Adobe/Aldus Image data)  4 = Illustrator (Adobe Graphics data)  5 = AppleSingle (Apple Computer Inc)  6 = NAA 89-3 (ANPA 1312)  7 = MacBinary II  8 = IPTC Unstructured Character Oriented File Format (UCOFF)  9 = United Press International ANPA 1312 variant  10 = United Press International Down-Load Message  11 = JPEG File Interchange (JFIF)  12 = Photo-CD Image-Pac (Eastman Kodak)  13 = Bit Mapped Graphics File [.BMP] (Microsoft)  14 = Digital Audio File [.WAV] (Microsoft & Creative Labs)  15 = Audio plus Moving Video [.AVI] (Microsoft)  16 = PC DOS/Windows Executable Files [.COM][.EXE]  17 = Compressed Binary File [.ZIP] (PKWare Inc)  18 = Audio Interchange File Format AIFF (Apple Computer Inc)  19 = RIFF Wave (Microsoft Corporation)  20 = Freehand (Macromedia/Aldus)  21 = Hypertext Markup Language [.HTML] (The Internet Society)  22 = MPEG 2 Audio Layer 2 (Musicom), ISO/IEC  23 = MPEG 2 Audio Layer 3, ISO/IEC  24 = Portable Document File [.PDF] Adobe  25 = News Industry Text Format (NITF)  26 = Tape Archive [.TAR]  27 = Tidningarnas Telegrambyra NITF version (TTNITF DTD)  28 = Ritzaus Bureau NITF version (RBNITF DTD)  29 = Corel Draw [.CDR] | | 201 | ObjectPreviewFileVersion | int16u |  | | 202 | ObjectPreviewData | undef[0,256000] |  | | 221 | Prefs | string[0,64] | (PhotoMechanic preferences) | | 225 | ClassifyState | string[0,64] |  | | 228 | SimilarityIndex | string[0,32] |  | | 230 | DocumentNotes | string[0,1024] |  | | 231 | DocumentHistory | string[0,256] |  | | 232 | ExifCameraInfo | string[0,4096] |  | | 255 | CatalogSets | string[0,256]+ | (written by iView MediaPro) | |

## IPTC NewsPhoto Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | NewsPhotoVersion | int16u: |  | | 10 | IPTCPictureNumber | string[16] | (4 numbers: 1-Manufacturer ID, 2-Equipment ID, 3-Date, 4-Sequence) | | 20 | IPTCImageWidth | int16u |  | | 30 | IPTCImageHeight | int16u |  | | 40 | IPTCPixelWidth | int16u |  | | 50 | IPTCPixelHeight | int16u |  | | 55 | SupplementalType | int8u | 0 = Main Image  1 = Reduced Resolution Image  2 = Logo  3 = Rasterized Caption | | 60 | ColorRepresentation | int16u | 0x0 = No Image, Single Frame  0x100 = Monochrome, Single Frame  0x300 = 3 Components, Single Frame  0x301 = 3 Components, Frame Sequential in Multiple Objects  0x302 = 3 Components, Frame Sequential in One Object  0x303 = 3 Components, Line Sequential  0x304 = 3 Components, Pixel Sequential  0x305 = 3 Components, Special Interleaving  0x400 = 4 Components, Single Frame  0x401 = 4 Components, Frame Sequential in Multiple Objects  0x402 = 4 Components, Frame Sequential in One Object  0x403 = 4 Components, Line Sequential  0x404 = 4 Components, Pixel Sequential  0x405 = 4 Components, Special Interleaving | | 64 | InterchangeColorSpace | int8u | |  | | --- | | 1 = X,Y,Z CIE  2 = RGB SMPTE  3 = Y,U,V (K) (D65)  4 = RGB Device Dependent  5 = CMY (K) Device Dependent  6 = Lab (K) CIE  7 = YCbCr  8 = sRGB | | | 65 | ColorSequence | int8u |  | | 66 | ICC\_Profile | no |  | | 70 | ColorCalibrationMatrix | no |  | | 80 | LookupTable | no |  | | 84 | NumIndexEntries | int16u |  | | 85 | ColorPalette | no |  | | 86 | IPTCBitsPerSample | int8u |  | | 90 | SampleStructure | int8u | 0 = OrthogonalConstangSampling  1 = Orthogonal4-2-2Sampling  2 = CompressionDependent | | 100 | ScanningDirection | int8u | |  |  |  | | --- | --- | --- | | 0 = L-R, Top-Bottom  1 = R-L, Top-Bottom  2 = L-R, Bottom-Top  3 = R-L, Bottom-Top |  | 4 = Top-Bottom, L-R  5 = Bottom-Top, L-R  6 = Top-Bottom, R-L  7 = Bottom-Top, R-L | | | 102 | IPTCImageRotation | int8u | 0 = 0  1 = 90  2 = 180  3 = 270 | | 110 | DataCompressionMethod | int32u |  | | 120 | QuantizationMethod | int8u | |  | | --- | | 0 = Linear Reflectance/Transmittance  1 = Linear Density  2 = IPTC Ref B  3 = Linear Dot Percent  4 = AP Domestic Analogue  5 = Compression Method Specific  6 = Color Space Specific  7 = Gamma Compensated | | | 125 | EndPoints | no |  | | 130 | ExcursionTolerance | int8u | 0 = Not Allowed  1 = Allowed | | 135 | BitsPerComponent | int8u |  | | 140 | MaximumDensityRange | int16u |  | | 145 | GammaCompensatedValue | int16u |  | |

## IPTC PreObjectData Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 10 | SizeMode | no | 0 = Size Not Known  1 = Size Known | | 20 | MaxSubfileSize | no |  | | 90 | ObjectSizeAnnounced | no |  | | 95 | MaximumObjectSize | no |  | |

## IPTC ObjectData Tags

> |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 10 | SubFile | no+ |  | |

## IPTC PostObjectData Tags

> |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 10 | ConfirmedObjectSize | no |  | |

## IPTC FotoStation Tags

> |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | *[no tags known]* | | | | |

---

(This document generated automatically by Image::ExifTool::BuildTagLookup)
  
*Last revised Oct 2, 2020*

[<-- ExifTool Tag Names](https://exiftool.org/TagNames/index.html)
