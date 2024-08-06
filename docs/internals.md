# Internal details

## Minimal configurations

In this section, we describe step by step the minimal Buildroot
configuration
[st_stm32mp157f_dk2_defconfig](/configs/st_stm32mp157f_dk2_defconfig)
which targets the STM32MP157F Discovery Kit 2 platform. The other
Buildroot configurations for the other platforms are very similar.

```
BR2_arm=y
BR2_cortex_a7=y
```

Obviously, this tells Buildroot to build a system for the ARM
architecture, and more precisely for a Cortex-A7 based processor. This
will ensure the cross-compilation toolchain targets the correct CPU
architecture and specific CPU core.

```
BR2_TOOLCHAIN_EXTERNAL=y
BR2_TOOLCHAIN_EXTERNAL_BOOTLIN=y
BR2_TOOLCHAIN_EXTERNAL_BOOTLIN_ARMV7_EABIHF_GLIBC_STABLE=y
```

We decide to use external toolchain. This choice has been made to
reduce the build time of the overall system, and use a well-known
toolchain provided by Bootlin. We use Bootlin stable toolchain instead of
ARM toolchain because ST components are a bit too old in version to bnuild
the latest version of ARM toolchain.

```
BR2_GLOBAL_PATCH_DIR="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/patches/"
```

We need to apply one patch to the Linux kernel, which is located in
`board/stmicroelectronics/common/patches/`. This configuration
option tells Buildroot where to find the patches to apply.

```
BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_MDEV=y
```

This option enables *mdev* (a minimal re-implementation of *udev*
which is part of BusyBox) which takes care of automatically loading
kernel modules, adjusting `/dev` nodes permissions, and more.

```
BR2_ROOTFS_OVERLAY="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/overlay/"
```

This tells Buildroot to copy the contents of
[board/stmicroelectronics/stm32mp1/overlay](/board/stmicroelectronics/stm32mp1/overlay)
into the root filesystem. The important file that this copies to the
root filesystem is `/boot/extlinux.conf`, which tells the U-Boot
bootloader how to boot the Linux system (which Linux kernel image to
load, which Device Tree to use, which kernel arguments to pass). It
also adds the Wifi firmware and the sound configuration files but
these are only used in the *demo* configurations, not the minimal
ones.

```
BR2_ROOTFS_POST_BUILD_SCRIPT="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/post-build.sh"
```

This tells Buildroot to run
[board/stmicroelectronics/common/post-build.sh](/board/stmicroelectronics/common/post-build.sh)
at the end of the rootfs generation. This script update the
extlinux.conf of the overlay to use the correct Device Tree file at
boot.

```
BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/post-image.sh"
```

This tells Buildroot to run
[board/stmicroelectronics/common/post-image.sh](/board/stmicroelectronics/common/post-image.sh)
at the end of the build. This script produces the final `sdcard.img`
file using a tool called `genimage` and deploys the `flash.tsv` file to
flash the board with STM32 Cube Programmer.

```
BR2_ROOTFS_POST_SCRIPT_ARGS="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/genimage.cfg"
```

This is an argument passed to the scripts. It is used by `post-image.sh`
to know which genimage config to use.

```
BR2_LINUX_KERNEL=y
BR2_LINUX_KERNEL_CUSTOM_TARBALL=y
BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION="$(call github,STMicroelectronics,linux)v6.1-stm32mp-r2.tar.gz"
BR2_LINUX_KERNEL_DEFCONFIG="multi_v7"
BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="$(LINUX_DIR)/arch/arm/configs/fragment-01-multiv7_cleanup.config $(LINUX_DIR)/arch/arm/configs/fragment-02-multiv7_addons.config $(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/linux-disable-etnaviv.config"
BR2_LINUX_KERNEL_DTS_SUPPORT=y
BR2_LINUX_KERNEL_INTREE_DTS_NAME="stm32mp157f-dk2"
BR2_LINUX_KERNEL_INSTALL_TARGET=y
BR2_LINUX_KERNEL_NEEDS_HOST_OPENSSL=y
```

This set of options tells Buildroot to build a Linux kernel, with the
source code fetched using Git from the repository at
[https://github.com/STMicroelectronics/linux](https://github.com/STMicroelectronics/linux). The
Git tag `v6.1-stm32mp-r2` will be used as the kernel version. The
kernel will be configured using the configuration file
[multi_v7_defconfig](https://github.com/STMicroelectronics/linux/arch/arm/configs/multi_v7_defconfig)
extended with three configuration fragments:

1. [fragment-01-multiv7_cleanup.config](https://github.com/STMicroelectronics/linux/arch/arm/configs/fragment-01-multiv7_cleanup.config),
which comes from the ST kernel tree, and that disables a number of
kernel drivers/features that are not needed on STM32MP1

2. [fragment-02-multiv7_addons.config](https://github.com/STMicroelectronics/linux/arch/arm/configs/fragment-02-multiv7_addons.config),
which comes from the ST kernel tree, and which enables a few
additional kernel drivers/features taht are relevant on STM32MP1

3. [linux-disable-etnaviv.config](/board/stmicroelectronics/common/linux-disable-etnaviv.config),
which comes from this `BR2_EXTERNAL`, and is in charge of disabling
the Etnaviv GPU kernel driver, as we use the proprietary GPU driver
provided by ST instead.

The option `BR2_LINUX_KERNEL_INTREE_DTS_NAME` indicates that the
`stm32mp157f-dk2.dtb` Device Tree file will be produced and should be
used. Finally `BR2_LINUX_KERNEL_INSTALL_TARGET=y` tells that the
kernel image should be installed to the target root filesystem, in
`/boot`.

```
BR2_TARGET_ROOTFS_EXT2=y
BR2_TARGET_ROOTFS_EXT2_4=y
BR2_TARGET_ROOTFS_EXT2_SIZE="120M"
# BR2_TARGET_ROOTFS_TAR is not set
```

This set of options tell Buildroot to generate an *ext4* filesystem
image for the root filesystem, and to not build the default filesystem
image, which is a tarball (`.tar`).

```
BR2_TARGET_ARM_TRUSTED_FIRMWARE=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_TARBALL=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_TARBALL_LOCATION="$(call github,STMicroelectronics,arm-trusted-firmware)v2.8-stm32mp-r2.tar.gz"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_PLATFORM="stm32mp1"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_FIP=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_BL32_OPTEE=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_UBOOT_AS_BL33=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_UBOOT_BL33_IMAGE="u-boot-nodtb.bin"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="STM32MP_SDMMC=1 AARCH32_SP=optee DTB_FILE_NAME=stm32mp157f-dk2.dtb BL33_CFG=$(BINARIES_DIR)/u-boot.dtb STM32MP_USB_PROGRAMMER=1 STM32MP1_OPTEE_IN_SYSRAM=1 OPENSSL_DIR=$(BR2_HOST_DIR)"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_IMAGES="*.stm32 fip.bin"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_NEEDS_DTC=y
```

These options tell Buildroot how to build TF-A, the Trusted
Firmware. It is retrieved from the Git repository at
[https://github.com/STMicroelectronics/arm-trusted-firmware](https://github.com/STMicroelectronics/arm-trusted-firmware),
using version `v2.8-stm32mp-r2`. TF-A is configured for the `stm32mp1`
platform with OP-TEE as BL32, and we use the mechanism of
[FIP](https://trustedfirmware-a.readthedocs.io/en/latest/getting_started/tools-build.html)
images. The Device Tree file being used in TF-A comes from the TF-A
source code, and is named `stm32mp157f-dk2.dtb`.

```
BR2_PACKAGE_OPTEE_CLIENT=y
BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL=y
BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL_LOCATION="$(call github,OP-TEE,optee_client)3.19.0.tar.gz"
...
BR2_TARGET_OPTEE_OS=y
BR2_TARGET_OPTEE_OS_CUSTOM_TARBALL=y
BR2_TARGET_OPTEE_OS_CUSTOM_TARBALL_LOCATION="$(call github,STMicroelectronics,optee_os)3.19.0-stm32mp-r2.tar.gz"
BR2_TARGET_OPTEE_OS_NEEDS_DTC=y
BR2_TARGET_OPTEE_OS_NEEDS_PYTHON_CRYPTOGRAPHY=y
BR2_TARGET_OPTEE_OS_PLATFORM="stm32mp1"
BR2_TARGET_OPTEE_OS_PLATFORM_FLAVOR="157F_DK2"
BR2_TARGET_OPTEE_OS_ADDITIONAL_VARIABLES="CFG_STM32MP1_OPTEE_IN_SYSRAM=y"
```

These options configure the build of OP-TEE as a trusted execution
environment, as well as the user-space OP-TEE client programs.
It is fetched from the Git repository
[https://github.com/STMicroelectronics/optee_os](https://github.com/STMicroelectronics/optee_os),
in version `3.19.0-stm32mp-r2`. The platform is `stm32mp1` and its flavor
is `157F_DK2`

```
BR2_TARGET_UBOOT=y
BR2_TARGET_UBOOT_BUILD_SYSTEM_KCONFIG=y
BR2_TARGET_UBOOT_CUSTOM_TARBALL=y
BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION="$(call github,STMicroelectronics,u-boot)v2022.10-stm32mp-r2.tar.gz"
BR2_TARGET_UBOOT_BOARD_DEFCONFIG="stm32mp15"
BR2_TARGET_UBOOT_NEEDS_PYLIBFDT=y
# BR2_TARGET_UBOOT_FORMAT_BIN is not set
BR2_TARGET_UBOOT_FORMAT_CUSTOM=y
BR2_TARGET_UBOOT_FORMAT_CUSTOM_NAME="u-boot-nodtb.bin u-boot.dtb"
BR2_TARGET_UBOOT_CUSTOM_MAKEOPTS="DEVICE_TREE=stm32mp157f-dk2"
```

These options tell Buildroot how to build U-Boot: it is fetched from
the Git repository at
[https://github.com/STMicroelectronics/u-boot](https://github.com/STMicroelectronics/u-boot),
in version `v2022.10-stm32mp-r2`. The configuration used is
`stm32mp15`, and we install both the `u-boot-nodtb.bin` and
`u-boot.dtb` images as both are used for the TF-A build. The Device
Tree file used comes from the U-Boot source code, and is named
`stm32mp157f-dk2`.

```
BR2_PACKAGE_HOST_BMAP_TOOLS=y
```

This option tells Buildroot to build the `bmap` utility for the host. This
is used to produce block map files alongside the image.

```
BR2_PACKAGE_HOST_GENIMAGE=y
```

This last option tells Buildroot to build the `genimage` utility for
the host, as it is used to produce the SD card image.

What is not visible in this configuration are all the defaults that
Buildroot has: it will by default integrate Busybox in the root
filesystem image, and use a number of sane defaults to build a basic
embedded Linux system.

## Demo configurations

In this section, we describe the demo configuration
[st_stm32mp157f_dk2_demo_defconfig](/configs/st_stm32mp157f_dk2_demo_defconfig)
for the STM32MP157F Discovery Kit 2. Here as well, all other *demo*
configurations for the other platforms are very similar.

```
BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_EUDEV=y
```

This option enables *eudev* instead of *mdev* selected by the basic
configuration. It manages devices node and handles all user space actions
when adding or removing devices.

```
BR2_ROOTFS_POST_BUILD_SCRIPT="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/post-build.sh $(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/post-build-demo.sh"
BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/post-image.sh $(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/generate-rauc-bundle.sh"
BR2_ROOTFS_POST_SCRIPT_ARGS="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/genimage-demo.cfg"
```

Add demo post-build and post-image scripts in addition of basic scripts
alongside with genimage-demo args to tell which partition configuration
to use.

```
BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="$(LINUX_DIR)/arch/arm/configs/fragment-01-multiv7_cleanup.config $(LINUX_DIR)/arch/arm/configs/fragment-02-multiv7_addons.config $(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/linux-disable-etnaviv.config $(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/common/linux-enable-rauc.config"
```

Add `linux-enable-rauc.config` Linux fragment configuration to enable
RAUC requirements.

```
BR2_TARGET_GENERIC_ROOT_PASSWD="root"
```

This option sets the root password to `root`. The root password has to
be set to a non-empty value to connect to the board through SSH.

```
BR2_LINUX_KERNEL_INTREE_DTS_NAME="stm32mp157f-dk2-mx"
BR2_LINUX_KERNEL_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/linux-dts/*"
BR2_LINUX_KERNEL_DTB_OVERLAY_SUPPORT=y
```

The demo configurations use a Linux kernel Device Tree file produced
by STM32 Cube MX. These two options tell Buildroot where to find these
Device Tree files, and which one to use. The last option enables the
`-@` Device Tree compiler build option, which produces Device Tree
files with slightly more information, making it possible for the
U-Boot bootloader to automatically tweak the Device Tree files passed
to the Linux kernel when booting.

```
BR2_PACKAGE_OPTEE_EXAMPLES=y
BR2_PACKAGE_OPTEE_EXAMPLES_CUSTOM_TARBALL=y
BR2_PACKAGE_OPTEE_EXAMPLES_CUSTOM_TARBALL_LOCATION="$(call github,linaro-swg,optee_examples)3.19.0.tar.gz"
BR2_PACKAGE_OPTEE_TEST=y
BR2_PACKAGE_OPTEE_TEST_CUSTOM_TARBALL=y
BR2_PACKAGE_OPTEE_TEST_CUSTOM_TARBALL_LOCATION="$(call github,OP-TEE,optee_test)3.19.0.tar.gz"
```

These options enable OP-TEE tests and examples using the same version
as OP-TEE OS from ST.

```
BR2_PACKAGE_ALSA_UTILS=y
BR2_PACKAGE_ALSA_UTILS_AMIXER=y
BR2_PACKAGE_ALSA_UTILS_APLAY=y
BR2_PACKAGE_ALSA_UTILS_SPEAKER_TEST=y
```

These options enable alsa-utils and examples.

```
BR2_PACKAGE_DEJAVU=y
BR2_PACKAGE_QT5=y
BR2_PACKAGE_QT5BASE_EXAMPLES=y
BR2_PACKAGE_QT5BASE_GUI=y
BR2_PACKAGE_QT5BASE_OPENGL_LIB=y
BR2_PACKAGE_QT5BASE_EGLFS=y
BR2_PACKAGE_QT5BASE_FONTCONFIG=y
```

These options enable a font (*DejaVu*) and the QT5 graphical toolkit.

```
BR2_PACKAGE_DROPBEAR=y
```

This option enables the dropbear SSH server.

```
BR2_PACKAGE_LINUX_FIRMWARE=y
BR2_PACKAGE_LINUX_FIRMWARE_BRCM_BCM43XXX=y
BR2_PACKAGE_MURATA_CYW_FW=y
BR2_PACKAGE_MURATA_CYW_FW_CYW43430=y
```

These options enable the installation of the firmware file needed for
the WiFi and Bluetooth chips.

```
BR2_PACKAGE_GCNANO_BINARIES=y
```

This option enables the installation of the closed-source user-space
library that provide OpenGL support.

```
BR2_PACKAGE_LIBUBOOTENV=y
```

This option enable tools to read and write the U-boot environment from
Linux. These are required to have the [OTA](/docs/ota.md) working
properly.

```
BR2_PACKAGE_LIBDRM_INSTALL_TESTS=y
```

This option, which implies `BR2_PACKAGE_LIBDRM=y` installs the
`modetest` utility that we use for [display testing](/docs/display.md).

```
BR2_PACKAGE_BLUEZ_TOOLS=y
BR2_PACKAGE_BLUEZ5_UTILS=y
BR2_PACKAGE_BLUEZ5_UTILS_CLIENT=y
```

These options install the user-space utilities to manage and configure
Bluetooth.

```
BR2_PACKAGE_IW=y
BR2_PACKAGE_WIRELESS_REGDB=y
BR2_PACKAGE_WPA_SUPPLICANT=y
BR2_PACKAGE_WPA_SUPPLICANT_AP_SUPPORT=y
BR2_PACKAGE_WPA_SUPPLICANT_WIFI_DISPLAY=y
BR2_PACKAGE_WPA_SUPPLICANT_AUTOSCAN=y
BR2_PACKAGE_WPA_SUPPLICANT_EAP=y
BR2_PACKAGE_WPA_SUPPLICANT_CLI=y
BR2_PACKAGE_WPA_SUPPLICANT_PASSPHRASE=y
```

These options install the user-space utilities to manage and configure
WiFi, as well as the wireless regulatory database.

```
BR2_PACKAGE_RAUC=y
BR2_PACKAGE_RAUC_DBUS=y
BR2_PACKAGE_RAUC_GPT=y
BR2_PACKAGE_RAUC_NETWORK=y
BR2_PACKAGE_RAUC_STREAMING=y
BR2_PACKAGE_RAUC_JSON=y
```

These options install the rauc tool for [OTA](/docs/ota.md).

```
BR2_TARGET_ROOTFS_SQUASHFS=y
```

This option tells Buildroot to generate a *squashfs* read-only filesystem
image for the root filesystem.

```
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/tfa-dts/*"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="STM32MP_SDMMC=1 AARCH32_SP=optee DTB_FILE_NAME=stm32mp157f-dk2-mx.dtb BL33_CFG=$(BINARIES_DIR)/u-boot.dtb STM32MP_USB_PROGRAMMER=1 STM32MP1_OPTEE_IN_SYSRAM=1 OPENSSL_DIR=$(BR2_HOST_DIR)"
```

These options customize the build of TF-A to use a Device Tree file
produced by STM32Cube MX, called `stm32mp157f-dk2-mx.dtb`.

```
BR2_TARGET_OPTEE_OS_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/optee-dts/*"
BR2_TARGET_OPTEE_OS_ADDITIONAL_VARIABLES="CFG_EMBED_DTB_SOURCE_FILE=stm32mp157f-dk2-mx.dts CFG_STM32MP15=y CFG_DRAM_SIZE=0x20000000 CFG_STM32MP1_OPTEE_IN_SYSRAM=y"
```

These options customize the build of OPTEE-OS to use a Device Tree file
produced by STM32 Cube MX, called `stm32mp157f-dk2-mx`. The option
`CFG_EMBED_DTB_SOURCE_FILE=stm32mp157f-dk2-mx.dts CFG_STM32MP15=y` has been
added to OPTEE-OS make options, to build the external devicetree.

```
BR2_TARGET_UBOOT_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/uboot-dts/*"
BR2_TARGET_UBOOT_CUSTOM_MAKEOPTS="dtb-y=stm32mp157f-dk2-mx.dtb DEVICE_TREE=stm32mp157f-dk2-mx"
```

These options customize the build of U-Boot to use a Device Tree file
produced by STM32 Cube MX, called `stm32mp157f-dk2-mx`. The option
`dtb-y=stm32mp157f-dk2-mx.dtb` has been added to U-boot make options, to
build the external devicetree.

```
BR2_PACKAGE_HOST_GENEXT2FS=y
```

This option enables `genext2fs` tool, to be able to generate *ext4*
partition with `genimage`.

```
BR2_PACKAGE_HOST_RAUC=y
```

This option enables `rauc` tool for the host to generate a RAUC update
bundle.

```
BR2_PACKAGE_M4PROJECTS=y
```

This option enables the installation of the Firmware examples for the Cortex
M4 from [STM32CubeMP1](https://github.com/STMicroelectronics/STM32CubeMP1.git).

```
BR2_PACKAGE_HOST_UBOOT_TOOLS=y
BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE=y
BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp1/uEnv.txt"
BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SIZE="0x2000"
BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_REDUNDANT=y
```

These options generate an image of the U-Boot environment, ready to be
flashed, based on the environment defined as a text file in
`board/stmicroelectronics/stm32mp1/uEnv.txt`.

## Organization of the `BR2_EXTERNAL` tree

* `board/`
  * `stmicroelectronics/`
    * `common/`
      * [`ca.key.pem`](/board/stmicroelectronics/common/ca.key.pem),
        a private CA key used to generate signed RAUC bundle.
      * [`generate-rauc-bundle.sh`](/board/stmicroelectronics/common/generate-rauc-bundle.sh),
        the script executed by Buildroot for demo configuration at the end
        of the rootfs generation. It generates the rauc bundle using the
        manifest.raucm.
      * [`linux-disable-etnaviv.config`](/board/stmicroelectronics/common/linux-disable-etnaviv.config),
        a Linux kernel configuration file fragment that disables the
        Etnaviv GPU driver.
      * [`linux-enable-rauc.config`](/board/stmicroelectronics/common/linux-enable-rauc.config),
        a Linux kernel configuration file fragment that enables the
        requisite kernel driver to use RAUC.
      * [`manifest.raucm`](/board/stmicroelectronics/common/manifest.raucm),
        RAUC manifest to describe the bundle content and the purpose of
        each included image.
      * [`patches`](/board/stmicroelectronics/common/patches), which
        contains one patch for the Linux kernel, fixing a module
        loading issue for the audio codec driver.
      * [`post-build.sh`](/board/stmicroelectronics/common/post-build.sh),
        the script executed by Buildroot at the end of the rootfs generation
        to produce update the `extlinux.conf` with the right devicetree name.
      * [`post-image.sh`](/board/stmicroelectronics/common/post-image.sh),
        the script executed by Buildroot at the end of the build to
        produce the SD card image and deploy the flash.tsv file.
      * [`uboot-enable-squashfs.config`](/board/stmicroelectronics/common/uboot-enable-squashfs.config),
        a U-boot configuration file fragment that enables the SquashFS
        support.
    * `stm32mp1/`
      * [`tfa-dts/`](/board/stmicroelectronics/stm32mp1/tfa-dts), Device
        Tree files produced by STM32 Cube MX for TF-A. Only used by
        the demo configurations.
      * [`overlay/`](/board/stmicroelectronics/stm32mp1/overlay/),
        the boot filesytem overlay for the basic configurations. It
        contributes `/boot/extlinux.conf` to the root filesystem to select
        the right devicetree name.
      * [`overlay-demo/`](/board/stmicroelectronics/stm32mp1/overlay-demo/),
        the boot filesytem overlay for the demo configurations. It
        contributes `/boot/extlinux.conf` to the root filesystem to select
        the right devicetree name. It also adds the Wifi firmware, the
        sound configuration files and RAUC configuration files.
      * [`linux-dts/`](/board/stmicroelectronics/stm32mp1/linux-dts),
        Device Tree files produced by STM32 Cube MX for Linux. Only
        used by the demo configurations.
      * [`uboot-dts/`](/board/stmicroelectronics/stm32mp1/uboot-dts),
        Device Tree files produced by STM32 Cube MX for U-Boot. Only
        used by the demo configurations.
      * [`optee-dts/`](/board/stmicroelectronics/stm32mp1/optee-dts),
        Device Tree files produced by STM32 Cube MX for OPTEE-OS. Only
        used by the demo configurations.
      * [`flash.tsv`](/board/stmicroelectronics/stm32mp1/flash.tsv),
        configuration file for the STM32 Cube Programmer. Only valid
        for SD card flashing.
      * [`genimage.cfg`](/board/stmicroelectronics/stm32mp1/genimage.cfg),
        configuration file for the `genimage` utility, which produces
        the final `sdcard.img` SD card image. It describes the
        partition layout of the SD card. Only used by basic configurations.
      * [`genimage-demo.cfg`](/board/stmicroelectronics/stm32mp1/genimage-demo.cfg),
        configuration file for the `genimage` utility, which produces
        the final `sdcard.img` SD card image. It describes the
        partition layout of the SD card. Only used by demo configurations.
      * [`linux-enable-fbdev-emul.config`](/board/stmicroelectronics/stm32mp1/linux-enable-fbdev-emul.config),
        a Linux kernel configuration file fragment that enables the
        *fbdev* emulation of the DRM subsystem, which is needed on the
        STM32MP135 platform to be able to use the *linuxfb* backend of
        Qt5, in the absence of GPU/OpenGL
      * [`post-build-demo.sh`](/board/stmicroelectronics/stm32mp2/post-build-demo.sh),
        the script executed by Buildroot at the end of the rootfs
        generation for the demo configuration.
      * [`uEnv.txt`](/board/stmicroelectronics/stm32mp1/uEnv.txt), the
        U-boot environment which contains definitions needed to
        properly support OTA.
    * `stm32mp2/`
      * [`fip-ddr_usb.bin`](/board/stmicroelectronics/stm32mp2/fip-ddr_usb.bin),
        pre-compiled DDR FIP image built with STM32MP_USB_PROGRAMMER=1
        in order to be able to flash the SD card (we unfortunately
        cannot build a single FIP image that can be used for flashing
        and on storage, due to memory size limitations)
      * [`fip_usb.bin`](/board/stmicroelectronics/stm32mp2/fip_usb.bin),
        pre-compiled FIP image built with STM32MP_USB_PROGRAMMER=1 in
        order to be able to flash the SD card
      * [`flash.tsv`](/board/stmicroelectronics/stm32mp2/flash.tsv),
        configuration file for the STM32 Cube Programmer. Only valid
        for SD card flashing.
      * [`genimage.cfg`](/board/stmicroelectronics/stm32mp2/genimage.cfg),
        configuration file for the `genimage` utility, which produces
        the final `sdcard.img` SD card image. It describes the
        partition layout of the SD card. Only used by basic configurations.
      * [`genimage-demo.cfg`](/board/stmicroelectronics/stm32mp2/genimage-demo.cfg),
        configuration file for the `genimage` utility, which produces
        the final `sdcard.img` SD card image. It describes the
        partition layout of the SD card. Only used by demo configurations.
      * [`linux-dts/`](/board/stmicroelectronics/stm32mp2/linux-dts),
        Device Tree files imported from
        [dt-stm32mp repository](https://github.com/STMicroelectronics/dt-stm32mp).
      * [`optee-dts/`](/board/stmicroelectronics/stm32mp2/optee-dts),
        Device Tree files imported from
        [dt-stm32mp repository](https://github.com/STMicroelectronics/dt-stm32mp).
      * [`overlay/`](/board/stmicroelectronics/stm32mp2/overlay/),
        the boot filesytem overlay for the basic configurations. It
        contributes `/boot/extlinux.conf` to the root filesystem to select
        the right devicetree name.
      * [`overlay-demo/`](/board/stmicroelectronics/stm32mp2/overlay-demo/),
        the boot filesytem overlay for the demo configurations. It
        contributes `/boot/extlinux.conf` to the root filesystem to select
        the right devicetree name. It also adds the Wifi firmware, the
        sound configuration files and RAUC configuration files.
      * [`post-build-demo.sh`](/board/stmicroelectronics/stm32mp2/post-build-demo.sh),
        the script executed by Buildroot at the end of the rootfs
        generation for the demo configuration.
      * [`tfa-dts/`](/board/stmicroelectronics/stm32mp2/tfa-dts), Device
        Device Tree files imported from
        [dt-stm32mp repository](https://github.com/STMicroelectronics/dt-stm32mp).
        Tree files produced by STM32 Cube MX for TF-A. Only used by
        the demo configurations.
      * [`tf-a-stm32mp257f-ev1_usb.stm32`](/board/stmicroelectronics/stm32mp2/tf-a-stm32mp257f-ev1_usb.stm32),
        the ddr fip image generated with STM32MP_USB_PROGRAMMER=1 TF-A
        build option to be able to flash the SD card.
      * [`uboot-dts/`](/board/stmicroelectronics/stm32mp2/uboot-dts),
        Device Tree files imported from
        [dt-stm32mp repository](https://github.com/STMicroelectronics/dt-stm32mp).
      * [`uEnv.txt`](/board/stmicroelectronics/stm32mp2/uEnv.txt), the
        U-boot environment which contains definitions needed to
        properly support OTA.
* [`package/m4projects`](/package/m4projects), a Buildroot package
  that builds and installs all the Cortex-M4 examples of the
  [STM32CubeMP1](https://github.com/STMicroelectronics/STM32CubeMP1.git)
  sources. It uses a [python
  script](/package/m4projects/parse_project_config.py) as a wrapper to
  transform the .project and .cproject files readable by the dedicated
  [Makefile](/package/m4projects/Makefile.stm32).
* [`package/m33projects`](/package/m33projects), a Buildroot package
  that builds and installs all the Cortex-M33 examples of the
  [STM32CubeMP2](https://github.com/STMicroelectronics/STM32CubeMP2.git)
  sources. It uses a [shell
  script](/package/m33projects/st_copro_firmware_signature.sh) to sign the
  firmware before installing it.
* `configs/`
  * [`st_stm32mp157d_dk1_defconfig`](/configs/st_stm32mp157d_dk1_defconfig),
    minimal configurations for the STM32MP1 DK1
  * [`st_stm32mp157d_dk1_demo_defconfig`](/configs/st_stm32mp157d_dk1_demo_defconfig),
    demo configurations for the STM32MP1 DK1
  * [`st_stm32mp157f_dk2_defconfig`](/configs/st_stm32mp157f_dk2_defconfig),
    minimal configurations for the STM32MP1 DK2
  * [`st_stm32mp157f_dk2_demo_defconfig`](/configs/st_stm32mp157f_dk2_demo_defconfig),
    demo configurations for the STM32MP1 DK2
  * [`st_stm32mp135f_dk_defconfig`](/configs/st_stm32mp135f_dk_defconfig),
    minimal configurations for the STM32MP1 DK
  * [`st_stm32mp135f_dk_demo_defconfig`](/configs/st_stm32mp135f_dk_demo_defconfig),
    demo configurations for the STM32MP1 DK
  * [`st_stm32mp257f_ev1_defconfig`](/configs/st_stm32mp257f_ev1_defconfig),
    minimal configurations for the STM32MP2 EV1
  * [`st_stm32mp257f_ev1_demo_defconfig`](/configs/st_stm32mp257f_ev1_demo_defconfig),
    demo configurations for the STM32MP2 EV1
* `docs`, documentation
* `Config.in`, top-level Config.in file mandatory in all `BR2_EXTERNAL`
  trees. Indicate the location of the Config.in file from our `m4projects`
  and `m33projects` packages.
* `README.md`
* `external.desc`, mandatory in all `BR2_EXTERNAL` trees, gives a name
  and description for the `BR2_EXTERNAL` tree
* `external.mk`, mandatory in all `BR2_EXTERNAL` trees, indicate the
  location of `*.mk` file from new packages.

## Changes compared to upstream Buildroot

The `st/2024.02.3` branch of this `BR2_EXTERNAL` is designed to work
with Buildroot 2024.02.3. However, we needed a few changes compared to
upstream Buildroot 2024.02.10, which can be seen at
[https://github.com/bootlin/buildroot/commits/st/2024.02.3](https://github.com/bootlin/buildroot/commits/st/2024.02.3). We
have just 11 changes on top of Buildroot 2024.02.3, and they can easily
be rebased on top of the latest Buildroot 2024.02.x to continue to
benefit from the security fixes provided by the Buildroot community.

Here are the 11 changes:

* Update the `gcnano-binaries` package to a newer version and to support
  arm64. This package contains the closed-source OpenGL user-space
  libraries, which need to be in sync with the kernel side.
  This patch has been submitted to upstream Buildroot.

* Add support for host python-intelhex package in preparation of the
  support for Trusted-Firmware-M. This patch has been submitted to
  upstream Buildroot.

* Add support for host python-click package in preparation of the
  support for Trusted-Firmware-M. This patch has been submitted to
  upstream Buildroot.

* Add support for host python-cbor2 package in preparation of the
  support for Trusted-Firmware-M. This patch has been submitted to
  upstream Buildroot.

* Add support for TrustedFirmware-M which is implementing the Secure
  Processing Environment (SPE) for Armv8-M, Armv8.1-M architectures.
  This patch has been submitted to upstream Buildroot.

* Add support for custom tarball source in optee-client to be able to
  match the OPTEE-OS custom tarball version. This patch has been
  submitted to upstream Buildroot.

* Add support for custom tarball source in optee-test to be able to
  match the OPTEE-OS custom tarball version. This patch has been
  submitted to upstream Buildroot.

* Add support for custom tarball source in optee-examples to be able to
  match the OPTEE-OS custom tarball version. This patch has been
  submitted to upstream Buildroot.

* Add support to build OP-TEE OS with host-cmake as the new version of
  OP-TEE OS from ST need cmake to build its scmi firmware. This patch has been
  submitted to upstream Buildroot.

* Update linux to manage vendor name subfolder directory for
  BR2_LINUX_KERNEL_CUSTOM_DTS_PATH. It adds support to build
  devicetree files which are organize under vendor subdirectories like
  for arm and arm64 architectures, such as
  arch/<arch>/boot/dts/<vendor>/. This patch has been submitted to
  upstream Buildroot.

* Bump arm-gnu-toolchain package to 13.2.rel1 release version.
  This patch is already in upstream Buildroot.
