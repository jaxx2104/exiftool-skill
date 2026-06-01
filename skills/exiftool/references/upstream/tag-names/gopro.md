---
generated_from: vendor/exiftool/html/TagNames/GoPro.html
upstream_version: 13.59
upstream_commit: 2200871d
generated_at: 2026-06-01
do_not_edit: true
---

> **Auto-generated** from upstream exiftool documentation. Do not
> edit by hand — edits will be overwritten on next regeneration.
> To change wording, edit the corresponding file in
> `vendor/exiftool/html/` upstream or override behavior in
> `references/tasks/`.
GoPro Tags

## GoPro GPMF Tags

Tags extracted from the GPMF box of GoPro MP4 videos, the APP6 "GoPro"
segment of JPEG files, and from the "gpmd" timed metadata if the
[ExtractEmbedded](https://exiftool.org/ExifTool.html#ExtractEmbedded) (-ee) option is enabled. Many more tags exist, but are
currently unknown and extracted only with the [Unknown](https://exiftool.org/ExifTool.html#Unknown) (-u) option. Please
let me know if you discover the meaning of any of these unknown tags. See
<https://github.com/gopro/gpmf-parser> for details about this format.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Tag ID | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 'AALP' | AudioLevel | no | (dBFS) | | 'ABSC' | AutoBoostScore | no |  | | 'ACCL' | Accelerometer | no | (accelerator readings in m/s2) | | 'ALLD' | AutoLowLightDuration | no |  | | 'APTO' | AudioProtuneOption | no |  | | 'ARUW' | AspectRatioUnwarped | no |  | | 'ARWA' | AspectRatioWarped | no |  | | 'ATTD' | Attitude | no |  | | 'ATTR' | AttitudeTarget | no |  | | 'AUBT' | AudioBlueTooth | no | 'N' = No  'Y' = Yes | | 'AUDO' | AudioSetting | no |  | | 'AUPT' | AutoProtune | no | 'N' = No  'Y' = Yes | | 'BITR' | BitrateSetting | no |  | | 'BPOS' | Controller? | no |  | | 'CASN' | CameraSerialNumber | no |  | | 'CDAT' | CreationDate | no |  | | 'CDTM' | CaptureDelayTimer | no |  | | 'CLDP' | ClassificationDataPresent | no | 'N' = No  'Y' = Yes | | 'CORI' | CameraOrientation | no | (quaternions 0-1) | | 'CPIN' | ChapterNumber | no |  | | 'CSEN' | CoyoteSense | no |  | | 'CTRL' | ControlLevel | no |  | | 'CYTS' | CoyoteStatus | no |  | | 'DEVC' | DeviceContainer | - | --> [GoPro GPMF Tags](gopro.md#GPMF) | | 'DUST' | DurationSetting | no |  | | 'DVID' | DeviceID? | no |  | | 'DVNM' | DeviceName | no |  | | 'DZMX' | DigitalZoomAmount | no |  | | 'DZOM' | DigitalZoomOn | no | 'N' = No  'Y' = Yes | | 'DZST' | DigitalZoom | no |  | | 'EISA' | ElectronicImageStabilization | no |  | | 'EISE' | ElectronicStabilizationOn | no | 'N' = No  'Y' = Yes | | 'EMPT' | Empty? | no |  | | 'ESCS' | EscapeStatus? | no |  | | 'EXPT' | ExposureType | no |  | | 'FACE' | FaceDetected | no |  | | 'FCNM' | FaceNumbers | no |  | | 'FMWR' | FirmwareVersion | no |  | | 'FWVS' | OtherFirmware | no |  | | 'GLPI' | GPSPos | - | --> [GoPro GLPI Tags](gopro.md#GLPI) | | 'GPRI' | GPSRaw? | - | --> [GoPro GPRI Tags](gopro.md#GPRI) | | 'GPS5' | GPSInfo | - | --> [GoPro GPS5 Tags](gopro.md#GPS5) | | 'GPS9' | GPSInfo9 | - | --> [GoPro GPS9 Tags](gopro.md#GPS9) | | 'GPSA' | GPSAltitudeSystem | no |  | | 'GPSF' | GPSMeasureMode | no | 2 = 2-Dimensional Measurement  3 = 3-Dimensional Measurement | | 'GPSP' | GPSHPositioningError | no |  | | 'GPSU' | GPSDateTime | no |  | | 'GRAV' | GravityVector | no |  | | 'GYRO' | Gyroscope | no | (gyroscope readings in rad/s) | | 'HCTL' | HorizonControl | no |  | | 'HDRV' | HDRVideo | no | 'N' = No  'Y' = Yes | | 'HSGT' | HindsightSettings | no |  | | 'HUES' | PredominantHue | no |  | | 'IORI' | ImageOrientation | no | (quaternions 0-1) | | 'ISOE' | ISOSpeeds | no |  | | 'ISOG' | ImageSensorGain | no |  | | 'KBAT' | BatteryStatus | - | --> [GoPro KBAT Tags](gopro.md#KBAT) | | 'LNED' | LocalPositionNED | no |  | | 'LOGS' | HealthLogs | no |  | | 'MAGN' | Magnetometer | no |  | | 'MAPX' | MappingXCoefficients | no |  | | 'MAPY' | MappingYCoefficients | no |  | | 'MINF' | Model | no |  | | 'MMOD' | MediaMode | no |  | | 'MTRX' | AccelerometerMatrix | no |  | | 'MUID' | MediaUniqueID | no |  | | 'MWET' | MicrophoneWet | no |  | | 'MXCF' | MappingXMode | no |  | | 'MYCF' | MappingYMode | no |  | | 'ORDP' | OrientationDataPresent | no | 'N' = No  'Y' = Yes | | 'OREN' | AutoRotation | no | 'A' = Auto  'D' = Down  'U' = Up | | 'ORIN' | InputOrientation | no |  | | 'ORIO' | OutputOrientation | no |  | | 'PHDR' | HDRSetting | no |  | | 'PIMD' | ProtuneISOMode | no |  | | 'PIMN' | AutoISOMin | no |  | | 'PIMX' | AutoISOMax | no |  | | 'POLY' | PolynomialCoefficients | no |  | | 'PRES' | PhotoResolution | no |  | | 'PRJT' | LensProjection | no |  | | 'PRTN' | Protune | no | 'N' = Off  'Y' = On | | 'PTCL' | ColorMode | no |  | | 'PTEV' | ExposureCompensation | no |  | | 'PTSH' | Sharpness | no |  | | 'PTWB' | WhiteBalance | no |  | | 'PWPR' | PowerProfile | no |  | | 'PYCF' | PolynomialPower | no |  | | 'RAMP' | SpeedRampSetting | no |  | | 'RATE' | Rate | no |  | | 'RMRK' | Comments | no |  | | 'SCAL' | ScaleFactor? | no |  | | 'SCAP' | ScheduleCapture | no | 'N' = No  'Y' = Yes | | 'SCEN' | SceneClassification | no |  | | 'SCPR' | ScaledPressure | no |  | | 'SCTM' | ScheduleCaptureTime | no |  | | 'SHUT' | ExposureTimes | no |  | | 'SIMU' | ScaledIMU | no |  | | 'SIUN' | SIUnits? | no |  | | 'SMTR' | SpotMeter | no | 'N' = No  'Y' = Yes | | 'SROT' | SensorReadoutTime | no |  | | 'STMP' | TimeStamp | no |  | | 'STNM' | StreamName? | no |  | | 'STRM' | NestedSignalStream | - | --> [GoPro GPMF Tags](gopro.md#GPMF) | | 'SYST' | SystemTime | no |  | | 'TIMO' | TimeOffset | no |  | | 'TMPC' | CameraTemperature | no |  | | 'TSMP' | TotalSamples? | no |  | | 'TYPE' | StructureType? | no |  | | 'TZON' | TimeZone | no |  | | 'UNIF' | InputUniformity | no |  | | 'UNIT' | Units? | no |  | | 'VERS' | MetadataVersion | no |  | | 'VFOV' | FieldOfView | no | 'L' = Linear  'S' = Super View  'W' = Wide | | 'VFPS' | VideoFrameRate | no |  | | 'VFRH' | VisualFlightRulesHUD | no |  | | 'VRES' | VideoFrameSize | no |  | | 'WBAL' | ColorTemperatures | no |  | | 'WNDM' | WindProcessing | no |  | | 'WRGB' | WhiteBalanceRGB | no |  | | 'YAVG' | LumaAverage | no |  | | 'ZFOV' | DiagonalFieldOfView | no |  | | 'ZMPL' | ZoomScaleNormalization | no |  | |

## GoPro GLPI Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | GPSDateTime | no |  | | 1 | GPSLatitude | no |  | | 2 | GPSLongitude | no |  | | 3 | GPSAltitude | no |  | | 5 | GPSSpeedX | no |  | | 6 | GPSSpeedY | no |  | | 7 | GPSSpeedZ | no |  | | 8 | GPSTrack | no |  | |

## GoPro GPRI Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | GPSDateTimeRaw | no |  | | 1 | GPSLatitudeRaw | no |  | | 2 | GPSLongitudeRaw | no |  | | 3 | GPSAltitudeRaw | no |  | | 6 | GPSSpeedRaw | no |  | | 7 | GPSTrackRaw | no |  | |

## GoPro GPS5 Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | GPSLatitude | no |  | | 1 | GPSLongitude | no |  | | 2 | GPSAltitude | no |  | | 3 | GPSSpeed | no | (stored as m/s but converted to km/h when extracted) | | 4 | GPSSpeed3D | no | (stored as m/s but converted to km/h when extracted) | |

## GoPro GPS9 Tags

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | GPSLatitude | no |  | | 1 | GPSLongitude | no |  | | 2 | GPSAltitude | no |  | | 3 | GPSSpeed | no | (stored as m/s but converted to km/h when extracted) | | 4 | GPSSpeed3D | no | (stored as m/s but converted to km/h when extracted) | | 6 | GPSDateTime | no |  | | 7 | GPSDOP | no |  | | 8 | GPSMeasureMode | no | 2 = 2-Dimensional Measurement  3 = 3-Dimensional Measurement | |

## GoPro KBAT Tags

Battery status information found in GoPro Karma videos.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 0 | BatteryCurrent | no |  | | 1 | BatteryCapacity | no |  | | 3 | BatteryTemperature | no |  | | 4 | BatteryVoltage1 | no |  | | 5 | BatteryVoltage2 | no |  | | 6 | BatteryVoltage3 | no |  | | 7 | BatteryVoltage4 | no |  | | 8 | BatteryTime | no |  | | 14 | BatteryLevel | no |  | |

## GoPro fdsc Tags

Tags extracted from the MP4 "fdsc" timed metadata when the [ExtractEmbedded](https://exiftool.org/ExifTool.html#ExtractEmbedded)
(-ee) option is used.

> |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
> | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
> | | Index1 | Tag Name | Writable | Values / Notes | | --- | --- | --- | --- | | 8 | FirmwareVersion | no |  | | 23 | SerialNumber | no |  | | 87 | OtherSerialNumber | no |  | | 102 | Model | no |  | |

---

(This document generated automatically by Image::ExifTool::BuildTagLookup)
  
*Last revised Sep 26, 2025*

[<-- ExifTool Tag Names](https://exiftool.org/TagNames/index.html)
