# StMicroelectonics external tree

This repository contains the ST external tree to customize Buildroot.
It contains defconfig to configures Builroot with Kernel, U-boot and TFA
from STMicroelectronics.

## Description of the present defconfig available

* st\_stm32mp157c\_dk2\_defconfig

A small skeleton defconfig with only the basics configurations to make a DK2 boot properly.

* st\_stm32mp157c\_dk2\_demo\_defconfig

A much exhaustive defconfig with lots of features enabled.  
Here is the list of features enabled:
  * gcano-binaries to provide Opengl
  * Qt5 with some examples

**The DK1 defconfigs have the same pattern**

## How to

This external tree currently depends on our own Buildroot repository because there are few commit added to follow the ST needs.
The aim is to merge these additionnal commits to the mainline Buildroot in order to remove the dependency to our Buildroot repository.  
  
Clone the Buildroot from Bootlin github repository alongside to this repository.  
Move to the Buildroot directory.  
Checkout to the same branch as this repository.

```bash
$ git clone git@github.com:bootlin/buildroot.git
$ cd buildroot
buildroot/ $ git checkout st/2021.02
```

Configure Buildroot to use the external tree and select the wanted defconfig.

```bash
buildroot/ $ make BR2_EXTERNAL=/path/to/st_external_tree st_stm32mp157c_dk2_defconfig
```

Compile Buildroot as usual

```bash
buildroot/ $ make
```

## Demo image
The demo image has several features enabled, see the list above.
In this paragraph we will show you how to use them.

### Test DSI and HDMI Display
You can test the DSI and the HDMI display with the _modetest_ command.  
First you need to find the ids of the display connectors, then show the test image on the dedicated display.

```bash
# modetest -c
...
Connectors:
id      encoder status          name            size (mm)       modes   encoders
32      0       connected       HDMI-A-1        480x270         5       31
  modes:
        index name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot
  #0 1280x720 60.00 1280 1390 1430 1650 720 725 730 750 74250 flags: phsync, pvsync; type: driver
  #1 1280x720 50.00 1280 1720 1760 1980 720 725 730 750 74250 flags: phsync, pvsync; type: driver
  #2 800x600 75.00 800 816 896 1056 600 601 604 625 49500 flags: phsync, pvsync; type: driver
  #3 720x576 50.00 720 732 796 864 576 581 586 625 27000 flags: nhsync, nvsync; type: driver
  #4 720x480 59.94 720 736 798 858 480 489 495 525 27000 flags: nhsync, nvsync; type: driver
...
34      0       connected       DSI-1           52x86           1       33
  modes:
        index name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot
  #0 480x800 50.00 480 578 610 708 800 815 825 839 29700 flags: ; type: preferred, driver
...

# modetest -s 34:480x800
# modetest -s 32:1280x720
``` 

### Qt examples

You can find the Qt examples at this path: _/usr/lib/qt/examples/_  
To use it you first need to load the galcore module.

```bash
# modprobe galcore
# /usr/lib/qt/examples/hellogl2/hellogl2
```

By default it will use HDMI if plugged or DSI otherwise. 
You can select the wanted display by using a KMS/DRM configuration file.  
You can see more information here: https://doc.qt.io/qt-5/embedded-linux.html#eglfs-with-the-eglfs-kms-backend

## References

https://buildroot.org/downloads/manual/manual.html#outside-br-custom  
https://bootlin.com/blog/tag/stm32mp1/
