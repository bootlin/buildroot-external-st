# Using Qt5 examples

Applicable platforms: STM32MP257F-EV1, STM32MP157-DK1, STM32MP157-DK2, STM32MP135-DK.

The Qt5 graphical toolkit is enabled in the *demo* configurations,
together with a number of example applications. Note that only the
base Qt5 modules are enabled in the *demo* configurations, but
Buildroot supports several additional Qt5 modules if necessary.

The Qt5 examples are installed in the target at
`/usr/lib/qt/examples/`.

## STM32MP257 and STM32MP157

The STM32MP257 and STM32MP157 SoCs have a GPU, for which the support is enabled
in the *demo* configuration. Qt5 is compiled with OpenGL support, and uses the
*eglfs* backend.

udev autoloads the `galcore` Linux kernel module, which is the kernel
driver needed to use the GPU. You can verify that this kernel module
has been properly loaded:

```
# lsmod | grep galcore
galcore               319488  0
```

Then you can start the different Qt examples, for example:

```
# cd /sys/class/backlight/<your_backlight_device>
# cat max_brightness > brightness
# /usr/lib/qt/examples/opengl/hellogl2/hellogl2
```

By default it will use HDMI if a monitor is plugged in or DSI
otherwise (on the DK2). You can control the display used by Qt using a
Qt-specific KMS/DRM configuration file, see [the Qt
documentation](https://doc.qt.io/qt-5/embedded-linux.html#eglfs-with-the-eglfs-kms-backend)
for details.

## STM32MP135

The STM32MP135 SoC does not have a GPU. Therefore, OpenGL support is
not available. Qt5 is therefore compiled to use the *linuxfb* backend.

You can start various Qt examples. After enabling the backlight, you
can start any Qt examples:

```
# cd /sys/class/backlight/<your_backlight_device>
# cat max_brightness > brightness
# /usr/lib/qt/examples/gui/analogclock/analogclock
```
