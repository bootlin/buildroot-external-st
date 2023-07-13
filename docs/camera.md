# Using camera

Applicable platforms: STM32MP135-DK.

Video from the camera can be tested in the *demo* configuration, with
the *yavta* tool.

First you have to configure Video4Linux using the `media-ctl` command.
The configuration depends on your camera, if your camera board is the MB1723
then the camera sensor is an *OV5640* on the other hand if your camera board is the
MB1897 the camera is a *GC2145*.

## GC2145 Sensor

```
# media-ctl -d /dev/media0 --set-v4l2 "'gc2145 1-003c':0[RGB565_2X8_BE/640x480@1/30 field:none]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':0[RGB565_2X8_BE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':1[RGB565_2X8_BE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[fmt:RGB565_2X8_LE/640x480]" -v
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[crop:(0,0)/640x480]" -v
```

## OV5640 Sensor

You first need to apply some changes to the Device Tree of the
STM32MP135-DK board, in order to change from the GC2145 sensor
(default) to the OV5640. The changes consist in:

1. Enabling the OV5640

2. Disabling the GC2145

3. Changing the description of the endpoints used for the camera
pipeline to connect the CSI-to-parallel bridge to the OV5640 instead
of the GC2145.

The changes are described in the patch at
https://gist.github.com/tpetazzoni/63f6c29337111d64a2cf35ed8d42104b.

```
# media-ctl -d /dev/media0 --set-v4l2 "'ov5640 1-003c':0[fmt:RGB565_2X8_LE/640x480@1/30 field:none]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':0[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':1[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[fmt:RGB565_2X8_LE/640x480]" -v
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[crop:(0,0)/640x480]" -v
```

## Capturing frames

Use for example the Yavta tool, which is integrated into the demo root
filesystem:

```
# yavta -F /dev/video0 --capture=10
```

This command captures 10 frame from the camera with the default format and
resolution.

You can list the available formats with the following command:
```
# yavta -l --enum-formats --enum-inputs /dev/video0
```
