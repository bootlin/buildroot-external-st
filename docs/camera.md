# Using camera

Applicable platforms: STM32MP135-DK.

Video from the camera can be tested in the *demo* configuration, with
the *yavta* tool.

First you have to configure Video4Linux using the `media-ctl` command.
The configuration depends on your camera, if your camera board is the MB1723
then the camera sensor is an *OV5640* on the other hand if your camera board is the
MB1897 the camera is a *GC2145*.

Configuration for *OV5640*:
```
# media-ctl -d /dev/media0 --set-v4l2 "'ov5640 1-003c':0[fmt:RGB565_2X8_LE/640x480@1/30 field:none]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':0[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':1[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[fmt:RGB565_2X8_LE/640x480]" -v
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[crop:(0,0)/640x480]" -v
```

Configuration for *GC2145*:
```
# media-ctl -d /dev/media0 --set-v4l2 "'gc2145 1-003c':0[RGB565_2X8_BE/640x480@1/30 field:none]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':0[RGB565_2X8_BE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_parallel':1[RGB565_2X8_BE/640x480]"
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[fmt:RGB565_2X8_LE/640x480]" -v
# media-ctl -d /dev/media0 --set-v4l2 "'dcmipp_dump_postproc':1[crop:(0,0)/640x480]" -v
```

Then use the Yavta tool.

```
# yavta -F /dev/video0 --capture=10
```

This command capture 10 frame from the camera with the default format and
resolution.
You can list the available format with the following command:
```
# yavta -l --enum-formats --enum-inputs /dev/video0
```
