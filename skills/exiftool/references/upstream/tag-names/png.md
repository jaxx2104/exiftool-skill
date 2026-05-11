---
generated_from: vendor/exiftool/html/TagNames/PNG.html
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
PNG Tags

## PNG Tags

Tags extracted from PNG images. See
<http://www.libpng.org/pub/png/spec/1.2/> for the official PNG 1.2
specification.

According to the specification, a PNG file should end at the IEND chunk,
however ExifTool will preserve any data found after this when writing unless
it is specifically deleted with `-Trailer:All=`. When reading, a minor
warning is issued if this trailer exists, and ExifTool will attempt to parse
this data as additional PNG chunks.

Also according to the PNG specification, there is no restriction on the
location of text-type chunks (tEXt, zTXt and iTXt). However, certain
utilities (including some Apple and Adobe utilities) won't read the XMP iTXt
chunk if it comes after the IDAT chunk, and at least one utility won't read
other text chunks here. For this reason, when writing, ExifTool 11.63 and
later create new text chunks (including XMP) before IDAT, and move existing
text chunks to before IDAT.

The PNG format contains CRC checksums that are validated when reading with
either the [Verbose](https://exiftool.org/ExifTool.html#Verbose) or [Validate](https://exiftool.org/ExifTool.html#Validate) option. When writing, these checksums are
validated by default, but the [FastScan](https://exiftool.org/ExifTool.html#FastScan) option may be used to bypass this
check if speed is more of a concern.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 'IHDR' | ImageHeader | - | --> [PNG ImageHeader Tags](png.md#ImageHeader) | | 'PLTE' | Palette | no |  | | 'acTL' | AnimationControl | - | --> [PNG AnimationControl Tags](png.md#AnimationControl) | | 'bKGD' | BackgroundColor | no |  | | 'cHRM' | PrimaryChromaticities | - | --> [PNG PrimaryChromaticities Tags](png.md#PrimaryChromaticities) | | 'cICP' | CICodePoints | - | --> [PNG CICodePoints Tags](png.md#CICodePoints) | | 'caBX' | JUMBF | - | --> [Jpeg2000 Tags](https://exiftool.org/TagNames/Jpeg2000.html) | | 'cpIp' | OLEInfo | - | --> [FlashPix Tags](https://exiftool.org/TagNames/FlashPix.html) | | 'dSIG' | DigitalSignature | no |  | | 'eXIf' | eXIf | - | --> [EXIF Tags](exif.md)  (this is where ExifTool will create new EXIF) | | 'fRAc' | FractalParameters | no |  | | 'gAMA' | Gamma | yes! | (ExifTool reports the gamma for decoding the image, which is consistent with the EXIF convention, but is the inverse of the stored encoding gamma) | | 'gIFg' | GIFGraphicControlExtension | no |  | | 'gIFt' | GIFPlainTextExtension | no |  | | 'gIFx' | GIFApplicationExtension | no |  | | 'gdAT' | GainMapImage | no |  | | 'hIST' | PaletteHistogram | no |  | | 'iCCP' | ICC\_Profile | - | --> [ICC\_Profile Tags](https://exiftool.org/TagNames/ICC_Profile.html)  (this is where ExifTool will write a new ICC\_Profile. When creating a new ICC\_Profile, the SRGBRendering tag should be deleted if it exists) | | 'iCCP-name' | ProfileName | yes | (not a real tag ID, this tag represents the iCCP profile name, and may only be written when the ICC\_Profile is written) | | 'iDOT' | AppleDataOffsets | no |  | | 'iTXt' | InternationalText | - | --> [PNG TextualData Tags](png.md#TextualData) | | 'meTa' | MeTa | - | --> [XMP XML Tags](xmp.md#XML) | | 'oFFs' | ImageOffset | no |  | | 'pCAL' | PixelCalibration | no |  | | 'pHYs' | PhysicalPixel | - | --> [PNG PhysicalPixel Tags](png.md#PhysicalPixel) | | 'sBIT' | SignificantBits | no |  | | 'sCAL' | SubjectScale | - | --> [PNG SubjectScale Tags](png.md#SubjectScale) | | 'sPLT' | SuggestedPalette | no |  | | 'sRGB' | SRGBRendering | yes! | (this chunk should not be present if an iCCP chunk exists)  0 = Perceptual  1 = Relative Colorimetric  2 = Saturation  3 = Absolute Colorimetric | | 'sTER' | StereoImage | - | --> [PNG StereoImage Tags](png.md#StereoImage) | | 'seAl' | SEAL | - | --> [XMP SEAL Tags](xmp.md#SEAL) | | 'tEXt' | TextualData | - | --> [PNG TextualData Tags](png.md#TextualData) | | 'tIME' | ModifyDate | yes |  | | 'tRNS' | Transparency | no |  | | 'tXMP' | XMP | - | --> [XMP Tags](xmp.md)  (obsolete location specified by a September 2001 XMP draft) | | 'vpAg' | VirtualPage | - | --> [PNG VirtualPage Tags](png.md#VirtualPage) | | 'zTXt' | CompressedText | - | --> [PNG TextualData Tags](png.md#TextualData) | | 'zxIf' | zxIf | - | --> [EXIF Tags](exif.md)  (a once-proposed chunk for compressed EXIF) | |

## PNG ImageHeader Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index1 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | ImageWidth | no |  | | 4 | ImageHeight | no |  | | 8 | BitDepth | no |  | | 9 | ColorType | no | 0 = Grayscale  2 = RGB  3 = Palette  4 = Grayscale with Alpha  6 = RGB with Alpha | | 10 | Compression | no | 0 = Deflate/Inflate | | 11 | Filter | no | 0 = Adaptive | | 12 | Interlace | no | 0 = Noninterlaced  1 = Adam7 Interlace | |

## PNG AnimationControl Tags

Tags found in the Animation Control chunk. See
<https://wiki.mozilla.org/APNG_Specification> for details.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index4 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | AnimationFrames | no |  | | 1 | AnimationPlays | no |  | |

## PNG PrimaryChromaticities Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index4 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | WhitePointX | no |  | | 1 | WhitePointY | no |  | | 2 | RedX | no |  | | 3 | RedY | no |  | | 4 | GreenX | no |  | | 5 | GreenY | no |  | | 6 | BlueX | no |  | | 7 | BlueY | no |  | |

## PNG CICodePoints Tags

These tags are found in the PNG cICP chunk and belong to the PNG-cICP family
1 group.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index1 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | ColorPrimaries | no | 1 = BT.709  2 = Unspecified  4 = BT.470 System M (historical)  5 = BT.470 System B, G (historical)  6 = BT.601  7 = SMPTE 240  8 = Generic film (color filters using illuminant C)  9 = BT.2020, BT.2100  10 = SMPTE 428 (CIE 1921 XYZ)  11 = SMPTE RP 431-2  12 = SMPTE EG 432-1  22 = EBU Tech. 3213-E | | 1 | TransferCharacteristics | no | |  | | --- | | 0 = For future use (0)  1 = BT.709  2 = Unspecified  3 = For future use (3)  4 = BT.470 System M (historical)  5 = BT.470 System B, G (historical)  6 = BT.601  7 = SMPTE 240 M  8 = Linear  9 = Logarithmic (100 : 1 range)  10 = Logarithmic (100 \* Sqrt(10) : 1 range)  11 = IEC 61966-2-4  12 = BT.1361  13 = sRGB or sYCC  14 = BT.2020 10-bit systems  15 = BT.2020 12-bit systems  16 = SMPTE ST 2084, ITU BT.2100 PQ  17 = SMPTE ST 428  18 = BT.2100 HLG, ARIB STD-B67 | | | 2 | MatrixCoefficients | no | 0 = Identity matrix  1 = BT.709  2 = Unspecified  3 = For future use (3)  4 = US FCC 73.628  5 = BT.470 System B, G (historical)  6 = BT.601  7 = SMPTE 240 M  8 = YCgCo  9 = BT.2020 non-constant luminance, BT.2100 YCbCr  10 = BT.2020 constant luminance  11 = SMPTE ST 2085 YDzDx  12 = Chromaticity-derived non-constant luminance  13 = Chromaticity-derived constant luminance  14 = BT.2100 ICtCp | | 3 | VideoFullRangeFlag | no |  | |

## PNG TextualData Tags

The PNG TextualData format allows arbitrary tag names to be used. The tags
listed below are the only ones that can be written (unless new user-defined
tags are added via the configuration file), however ExifTool will extract
any other TextualData tags that are found. All TextualData tags (including
tags not listed below) are removed when deleting all PNG tags.

These tags may be stored as tEXt, zTXt or iTXt chunks in the PNG image. By
default ExifTool writes new string-value tags as as uncompressed tEXt, or
compressed zTXt if the [Compress](https://exiftool.org/ExifTool.html#Compress) (-z) option is used and Compress::Zlib is
available. Alternate language tags and values containing special characters
(unless the Latin character set is used) are written as iTXt, and compressed
if the [Compress](https://exiftool.org/ExifTool.html#Compress) option is used and Compress::Zlib is available. Raw profile
information is always created as compressed zTXt if Compress::Zlib is
available, or tEXt otherwise. Standard XMP is written as uncompressed iTXt.
User-defined tags may set an 'iTXt' flag in the tag definition to be written
only as iTXt.

Alternate languages are accessed by suffixing the tag name with a '-',
followed by an RFC 3066 language code (eg. "PNG:Comment-fr", or
"Title-en-US"). See <http://www.ietf.org/rfc/rfc3066.txt> for the RFC 3066
specification.

Some of the tags below are not registered as part of the PNG specification,
but are included here because they are generated by other software such as
ImageMagick.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 'Artist' | Artist | string | (unregistered) | | 'Author' | Author | string |  | | 'Collection' | Collection | string |  | | 'Comment' | Comment | string |  | | 'Copyright' | Copyright | string |  | | 'Creation Time' | CreationTime | string | (stored in RFC-1123 format and converted to/from EXIF format by ExifTool) | | 'Description' | Description | string |  | | 'Disclaimer' | Disclaimer | string |  | | 'Document' | Document | string | (unregistered) | | 'Label' | Label | string | (unregistered) | | 'Make' | Make | string | (unregistered) | | 'Model' | Model | string | (unregistered) | | 'Raw profile type 8bim' | Photoshop\_Profile | - | --> [Photoshop Tags](https://exiftool.org/TagNames/Photoshop.html)  (unregistered) | | 'Raw profile type APP1' | APP1\_Profile | - | --> [EXIF Tags](exif.md)  --> [XMP Tags](xmp.md)  (unregistered) | | 'Raw profile type exif' | EXIF\_Profile | - | --> [EXIF Tags](exif.md)  (unregistered) | | 'Raw profile type icc' | ICC\_Profile | - | --> [ICC\_Profile Tags](https://exiftool.org/TagNames/ICC_Profile.html)  (unregistered) | | 'Raw profile type icm' | ICC\_Profile | - | --> [ICC\_Profile Tags](https://exiftool.org/TagNames/ICC_Profile.html)  (unregistered) | | 'Raw profile type iptc' | IPTC\_Profile | - | --> [Photoshop Tags](https://exiftool.org/TagNames/Photoshop.html)  (unregistered. May be either IPTC IIM or Photoshop IRB format. This is where ExifTool will add new IPTC, inside a Photoshop IRB container) | | 'Raw profile type xmp' | XMP\_Profile | - | --> [XMP Tags](xmp.md)  (unregistered) | | 'Software' | Software | string |  | | 'Source' | Source | string |  | | 'TimeStamp' | TimeStamp | string | (unregistered) | | 'Title' | Title | string |  | | 'URL' | URL | string | (unregistered) | | 'Warning' | PNGWarning | string |  | | 'XML:com.adobe.xmp' | XMP | - | --> [XMP Tags](xmp.md)  (unregistered, but this is the location according to the June 2002 or later XMP specification, and is where ExifTool will add a new XMP chunk if the image didn't already contain XMP) | | 'aesthetic\_score' | AestheticScore | string | (unregistered) | | 'create-date' | CreateDate | string | (unregistered) | | 'modify-date' | ModDate | string | (unregistered) | | 'parameters' | Parameters | string | (unregistered) | |

## PNG PhysicalPixel Tags

These tags are found in the PNG pHYs chunk and belong to the PNG-pHYs family
1 group. They are all created together with default values if necessary
when any of these tags is written, and may only be deleted as a group.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index1 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | PixelsPerUnitX | int32u | (default 2834) | | 4 | PixelsPerUnitY | int32u | (default 2834) | | 8 | PixelUnits | int8u | (default meters)  0 = Unknown  1 = meters | |

## PNG SubjectScale Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index1 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | SubjectUnits | no | 1 = meters  2 = radians | | 1 | SubjectPixelWidth | no |  | | 2 | SubjectPixelHeight | no |  | |

## PNG StereoImage Tags

> |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index1 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | StereoMode | no | 0 = Cross-fuse Layout  1 = Diverging-fuse Layout | |

## PNG VirtualPage Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index4 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | VirtualImageWidth | no |  | | 1 | VirtualImageHeight | no |  | | 2 | VirtualPageUnits | no |  | |

---

(This document generated automatically by Image::ExifTool::BuildTagLookup)
  
*Last revised Feb 26, 2025*

[<-- ExifTool Tag Names](https://exiftool.org/TagNames/index.html)
