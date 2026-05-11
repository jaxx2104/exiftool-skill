---
generated_from: vendor/exiftool/html/TagNames/Apple.html
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
Apple Tags

## Apple Tags

Tags extracted from the maker notes of iPhone images.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0x0001 | MakerNoteVersion | int32s |  | | 0x0002 | AEMatrix? | no |  | | 0x0003 | RunTime | - | --> [Apple RunTime Tags](apple.md#RunTime) | | 0x0004 | AEStable | int32s | 0 = No  1 = Yes | | 0x0005 | AETarget | int32s |  | | 0x0006 | AEAverage | int32s |  | | 0x0007 | AFStable | int32s | 0 = No  1 = Yes | | 0x0008 | AccelerationVector | rational64s[3] | (XYZ coordinates of the acceleration vector in units of g. As viewed from the front of the phone, positive X is toward the left side, positive Y is toward the bottom, and positive Z points into the face of the phone) | | 0x000a | HDRImageType | int32s | 3 = HDR Image  4 = Original Image | | 0x000b | BurstUUID | string | (unique ID for all images in a burst) | | 0x000c | FocusDistanceRange | rational64s[2] |  | | 0x000f | OISMode | int32s |  | | 0x0011 | ContentIdentifier | string | (called MediaGroupUUID when it appears as an XAttr) | | 0x0014 | ImageCaptureType | int32s | 1 = ProRAW  2 = Portrait  10 = Photo  11 = Manual Focus  12 = Scene | | 0x0015 | ImageUniqueID | string |  | | 0x0017 | LivePhotoVideoIndex | yes | (divide by RunTimeScale to get time in seconds) | | 0x0019 | ImageProcessingFlags? | int32s |  | | 0x001a | QualityHint? | string |  | | 0x001d | LuminanceNoiseAmplitude | rational64s |  | | 0x001f | PhotosAppFeatureFlags | int32s | (set if person or pet detected in image) | | 0x0020 | ImageCaptureRequestID? | string |  | | 0x0021 | HDRHeadroom | rational64s |  | | 0x0023 | AFPerformance | int32s[2] | (first number maybe related to focus distance, last number maybe related to focus accuracy) | | 0x0025 | SceneFlags? | int32s |  | | 0x0026 | SignalToNoiseRatioType? | int32s |  | | 0x0027 | SignalToNoiseRatio | rational64s |  | | 0x002b | PhotoIdentifier | string |  | | 0x002d | ColorTemperature | int32s |  | | 0x002e | CameraType | int32s | 0 = Back Wide Angle  1 = Back Normal  6 = Front | | 0x002f | FocusPosition | int32s |  | | 0x0030 | HDRGain | rational64s |  | | 0x0038 | AFMeasuredDepth | int32s | (from the time-of-flight-assisted auto-focus estimator) | | 0x003d | AFConfidence | int32s |  | | 0x003e | ColorCorrectionMatrix? | no |  | | 0x003f | GreenGhostMitigationStatus? | int32s |  | | 0x0040 | SemanticStyle | no | (\_1=Tone, \_2=Warm, \_3=1.Std,2.Vibrant,3.Rich Contrast,4.Warm,5.Cool) | | 0x0041 | SemanticStyleRenderingVer | no |  | | 0x0042 | SemanticStylePreset | no |  | | 0x004e | Apple\_0x004e? | no |  | | 0x004f | Apple\_0x004f? | no |  | | 0x0054 | Apple\_0x0054? | no |  | | 0x005a | Apple\_0x005a? | no |  | |

## Apple RunTime Tags

This PLIST-format information contains the elements of a CMTime structure
representing the amount of time the phone has been running since the last
boot, not including standby time.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 'epoch' | RunTimeEpoch | no |  | | 'flags' | RunTimeFlags | no | Bit 0 = Valid  Bit 1 = Has been rounded  Bit 2 = Positive infinity  Bit 3 = Negative infinity  Bit 4 = Indefinite | | 'timescale' | RunTimeScale | no |  | | 'value' | RunTimeValue | no |  | |

---

(This document generated automatically by Image::ExifTool::BuildTagLookup)
  
*Last revised Mar 11, 2025*

[<-- ExifTool Tag Names](https://exiftool.org/TagNames/index.html)
