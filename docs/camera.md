# Using camera

Applicable platforms: STM32MP257F-EV1, STM32MP135-DK.

Video from the camera can be tested in the *demo* configuration, with
the *yavta* tool.

First you have to configure Video4Linux using the `media-ctl` command.
The configuration depends on your camera:

## IMX335 Sensor (MB1854 camera board)

```
# media-ctl -d "platform:dcmipp" --set-v4l2 "'imx335 0-001a':0[fmt:SRGGB10_1X10/2592x1940]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'stm32_csi2host.48020000.csi2hos':1[fmt:SRGGB10_1X10/2592x1940]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_main_isp':1[fmt:RGB888_1X24/2592x1940 field:none]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_main_postproc':0[compose:(0,0)/640x480]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_main_postproc':1[fmt:RGB565_2X8_LE/640x480]"
# export camera_dev=$(media-ctl -d "platform:dcmipp" -e "dcmipp_dump_capture")
```

## GC2145 Sensor (MB1897 camera board)

```
# media-ctl -d "platform:dcmipp" --set-v4l2 "'gc2145 1-003c':0[fmt:RGB565_2X8_BE/640x480@1/30 field:none]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_input':0[fmt:RGB565_2X8_BE/640x480]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_input':1[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_dump_postproc':0[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_dump_postproc':1[crop:(80,104)/480x272]"
# export camera_dev=$(media-ctl -d "platform:dcmipp" -e "dcmipp_dump_capture")
```

## OV5640 Sensor (MB1723 camera board)

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
# media-ctl -d "platform:dcmipp" --set-v4l2 "'ov5640 1-003c':0[fmt:RGB565_2X8_LE/640x480@1/30 field:none]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_input':0[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_dump_postproc':0[fmt:RGB565_2X8_LE/640x480]"
# media-ctl -d "platform:dcmipp" --set-v4l2 "'dcmipp_dump_postproc':1[crop:(80,104)/480x272]"
# export camera_dev=$(media-ctl -d "platform:dcmipp" -e "dcmipp_dump_capture")
```

## Capturing frames

Use for example the Yavta tool, which is integrated into the demo root
filesystem:

```
# yavta -F $camera_dev --capture=10
```

This command captures 10 frame from the camera with the default format and
resolution.

You can list the available formats with the following command:
```
# yavta -l --enum-formats --enum-inputs $camera_dev
```

```
$ mv frame-000000.bin frame-000000.rgb
$ ffmpeg -s 640x480 -pix_fmt rgb565le -i frame-000000.rgb -f image2 -pix_fmt rgb24 frame0.png
```

Run these commands on your host computer to convert the rgb frame to a png
image.
