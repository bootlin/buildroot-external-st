# Using Qt5 examples

The Qt5 graphical toolkit is enabled in the *demo* configurations,
together with a number of example applications. Note that only the
base Qt5 modules are enabled in the *demo* configurations, but
Buildroot supports several additional Qt5 modules if necessary.

The Qt5 examples are installed in the target at
`/usr/lib/qt/examples/`.

Qt5 is compiled with OpenGL support. udev autoload the
`galcore` Linux kernel module, which is the kernel driver needed to
use the GPU. You can verify the good load of this module with the `lsmod`
command:

```
# lsmod | grep galcore
galcore               319488  0
```

Then you can start the different Qt examples, for example:

```
# /usr/lib/qt/examples/opengl/hellogl2/hellogl2
```

By default it will use HDMI if a monitor is plugged in or DSI
otherwise (on the DK2). You can control the display used by Qt using a
Qt-specific KMS/DRM configuration file, see [the Qt
documentation](https://doc.qt.io/qt-5/embedded-linux.html#eglfs-with-the-eglfs-kms-backend)
for details.


