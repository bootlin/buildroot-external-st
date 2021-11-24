# Internal details

## Minimal configurations

In this section, we describe step by step the minimal Buildroot
configuration
[st_stm32mp157c_dk2_defconfig](/configs/st_stm32mp157c_dk2_defconfig) targeting
the Discovery Kit 2. The
[st_stm32mp157a_dk1_defconfig](/configs/st_stm32mp157a_dk1_defconfig)
configuration targeting the Discovery Kit 1 is very similar.

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
```

We decide to use external toolchain. This choice has been made to improve
the build time face to the user experience of building its own toolchain.

```
BR2_ROOTFS_OVERLAY="board/stmicroelectronics/stm32mp157c-dk2/overlay/"
```

This tells Buildroot to copy the contents of
[board/stmicroelectronics/stm32mp157/dk2-overlay](/board/stmicroelectronics/stm32mp157/dk2-overlay)
into the root filesystem. The only file that this copies to the root
filesystem is `/boot/extlinux.conf`, which tells the U-Boot bootloader
how to boot the Linux system (which Linux kernel image to load, which
Device Tree to use, which kernel arguments to pass).

```
BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp157/post-image.sh"
```

This tells Buildroot to run
[board/stmicroelectronics/stm32mp157/post-image.sh](/board/stmicroelectronics/stm32mp157/post-image.sh)
at the end of the build. This script produces the final `sdcard.img`
file using a tool called `genimage`.

```
BR2_LINUX_KERNEL=y
BR2_LINUX_KERNEL_CUSTOM_GIT=y
BR2_LINUX_KERNEL_CUSTOM_REPO_URL="https://github.com/STMicroelectronics/linux.git"
BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION="v5.10-stm32mp-r1"
BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp157/linux.config"
BR2_LINUX_KERNEL_DTS_SUPPORT=y
BR2_LINUX_KERNEL_INTREE_DTS_NAME="stm32mp157c-dk2"
BR2_LINUX_KERNEL_INSTALL_TARGET=y
```

This set of options tells Buildroot to build a Linux kernel, with the
source code fetched using Git from the repository at
[https://github.com/STMicroelectronics/linux](https://github.com/STMicroelectronics/linux). The
Git tag `v5.10-stm32mp-r1` will be used as the kernel version. The
kernel will be configured using the configuration file at
[board/stmicroelectronics/stm32mp157/linux.config](/board/stmicroelectronics/stm32mp157/linux.config). A
Device Tree file called `stm32mp157c-dk2.dtb` will be produced, whose
source file is provided together with the Linux kernel source
code. Finally, the kernel image will be installed to the target root
filesystem, in `/boot`.

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
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_GIT=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_REPO_URL="https://github.com/STMicroelectronics/arm-trusted-firmware.git"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_REPO_VERSION="v2.4-stm32mp"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_PLATFORM="stm32mp1"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_FIP=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_UBOOT_AS_BL33=y
BR2_TARGET_ARM_TRUSTED_FIRMWARE_UBOOT_BL33_IMAGE="u-boot-nodtb.bin"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="STM32MP_SDMMC=1 AARCH32_SP=sp_min DTB_FILE_NAME=stm32mp157c-dk2.dtb BL33_CFG=$(BINARIES_DIR)/u-boot.dtb STM32MP_USB_PROGRAMMER=1"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_IMAGES="*.stm32 fip.bin"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_NEEDS_DTC=y
```

These options tell Buildroot how to build TF-A, the Trusted
Firmware. It is retrieved from the Git repository at
[https://github.com/STMicroelectronics/arm-trusted-firmware](https://github.com/STMicroelectronics/arm-trusted-firmware),
using version `v2.4-stm32mp`. TF-A is configured for the `stm32mp1`
platform, and we use the mechanism of
[FIP](https://trustedfirmware-a.readthedocs.io/en/latest/getting_started/tools-build.html)
images. The Device Tree file being used in TF-A comes from the TF-A
source code, and is named `stm32mp157c-dk2.dtb`.

```
BR2_TARGET_UBOOT=y
BR2_TARGET_UBOOT_BUILD_SYSTEM_KCONFIG=y
BR2_TARGET_UBOOT_CUSTOM_GIT=y
BR2_TARGET_UBOOT_CUSTOM_REPO_URL="https://github.com/STMicroelectronics/u-boot.git"
BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION="v2020.10-stm32mp"
BR2_TARGET_UBOOT_BOARD_DEFCONFIG="stm32mp15_trusted"
# BR2_TARGET_UBOOT_FORMAT_BIN is not set
BR2_TARGET_UBOOT_FORMAT_CUSTOM=y
BR2_TARGET_UBOOT_FORMAT_CUSTOM_NAME="u-boot-nodtb.bin u-boot.dtb"
BR2_TARGET_UBOOT_CUSTOM_MAKEOPTS="DEVICE_TREE=stm32mp157c-dk2"
```

These options tell Buildroot how to build U-Boot: it is fetched from
the Git repository at
[https://github.com/STMicroelectronics/u-boot](https://github.com/STMicroelectronics/u-boot),
in version `v2020.10-stm32mp`. The configuration used is
`stm32mp15_trusted`, and we install both the `u-boot-nodtb.bin` and
`u-boot.dtb` images as both are used for the TF-A build. The Device
Tree file used comes from the U-Boot source code, and is named
`stm32mp157c-dk2`.

```
BR2_PACKAGE_HOST_GENIMAGE=y
```

This last option tells Buildroot to build the `genimage` utility for
the host, as it is used to produce the SD card image.

What is not visible in this configuration are all the defaults that
Buildroot has: it will by default build a toolchain based on the
uClibc-ng C library, integrate Busybox in the root filesystem image,
and use a number of sane defaults to build a basic embedded Linux
system.

## Demo configurations

In this section, we describe the demo configuration
[st_stm32mp157c_dk2_demo_defconfig](/configs/st_stm32mp157c_dk2_demo_defconfig)
for the Discovery Kit 2. Here as well,
[st_stm32mp157a_dk1_demo_defconfig](/configs/st_stm32mp157a_dk1_demo_defconfig)
for the DK1 is very similar. We only describe the differences compared
to the minimal configuration.

```
BR2_LINUX_KERNEL_INTREE_DTS_NAME="stm32mp157c-dk2-mx"
BR2_LINUX_KERNEL_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp157/linux-dts/*"
```

The demo configurations use a Linux kernel Device Tree file produced
by STM32 Cube MX. These two options tell Buildroot where to find these
Device Tree files, and which one to use.

```
BR2_PACKAGE_DEJAVU=y
BR2_PACKAGE_QT5=y
BR2_PACKAGE_QT5BASE_EXAMPLES=y
BR2_PACKAGE_QT5BASE_GUI=y
BR2_PACKAGE_QT5BASE_OPENGL_LIB=y
BR2_PACKAGE_QT5BASE_LINUXFB=y
BR2_PACKAGE_QT5BASE_EGLFS=y
BR2_PACKAGE_QT5BASE_FONTCONFIG=y
```

These options enable a font (*DejaVu*) and the QT5 graphical toolkit.

```
BR2_PACKAGE_LINUX_FIRMWARE=y
BR2_PACKAGE_LINUX_FIRMWARE_BRCM_BCM43XXX=y
```

These options enable the installation of the firmware file needed for
the WiFi chip.

```
BR2_PACKAGE_GCNANO_BINARIES=y
```

This option enables the installation of the closed-source user-space
library that provide OpenGL support.

```
BR2_PACKAGE_LIBDRM_INSTALL_TESTS=y
```

This option, which implies `BR2_PACKAGE_LIBDRM=y` installs the
`modetest` utility that we use for [display testing](/docs/display.md).

```
BR2_PACKAGE_IW=y
BR2_PACKAGE_WPA_SUPPLICANT=y
BR2_PACKAGE_WPA_SUPPLICANT_AP_SUPPORT=y
BR2_PACKAGE_WPA_SUPPLICANT_WIFI_DISPLAY=y
BR2_PACKAGE_WPA_SUPPLICANT_AUTOSCAN=y
BR2_PACKAGE_WPA_SUPPLICANT_EAP=y
BR2_PACKAGE_WPA_SUPPLICANT_CLI=y
BR2_PACKAGE_WPA_SUPPLICANT_PASSPHRASE=y
```

These options install the user-space utilities to manage and configure
WiFi.

```
BR2_PACKAGE_OPTEE_EXAMPLES=y
BR2_PACKAGE_OPTEE_TEST=y
...
BR2_TARGET_OPTEE_OS=y
BR2_TARGET_OPTEE_OS_CUSTOM_GIT=y
BR2_TARGET_OPTEE_OS_CUSTOM_REPO_URL="https://github.com/STMicroelectronics/optee_os.git"
BR2_TARGET_OPTEE_OS_CUSTOM_REPO_VERSION="fa707f1f54c633c57279529a06238305d246a21b"
BR2_TARGET_OPTEE_OS_PLATFORM="stm32mp1"
BR2_TARGET_OPTEE_OS_PLATFORM_FLAVOR="157C_DK2"
```

These options configure the build of OP-TEE as a trusted execution
environment, as well as the user-space OP-TEE examples and test
programs.

```
BR2_TARGET_ARM_TRUSTED_FIRMWARE_BL32_OPTEE=y
..
BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp157/tfa-dts/*"
BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="STM32MP_SDMMC=1 AARCH32_SP=optee DTB_FILE_NAME=stm32mp157c-dk2-mx.dtb STM32MP_USB_PROGRAMMER=1"
```

These options customize the build of TF-A to load OP-TEE as a trusted
execution environment, and to use a Device Tree file produced by STM32
Cube MX, called `codestm32mp157c-dk2-mx.dtb`.

```
BR2_TARGET_UBOOT_CUSTOM_DTS_PATH="$(BR2_EXTERNAL_ST_PATH)/board/stmicroelectronics/stm32mp157/uboot-dts/*"
BR2_TARGET_UBOOT_CUSTOM_MAKEOPTS="dtb-y=stm32mp157c-dk2-mx.dtb DEVICE_TREE=stm32mp157c-dk2-mx"
```

These options customize the build of U-Boot to use a Device Tree file
produced by STM32 Cube MX, called `stm32mp157c-dk2-mx`. The option
`dtb-y=stm32mp157c-dk2-mx.dtb` has been added to U-boot make options, to
build the external devicetree.

```
BR2_PACKAGE_M4PROJECTS=y
```

This option enables the installation of the Firmware examples for the Cortex
M4 from [STM32CubeMP1](https://github.com/STMicroelectronics/STM32CubeMP1.git).

## Organization of the `BR2_EXTERNAL` tree

* `board/`
  * `stmicroelectronics/`
    * `stm32mp157/`
      * [`tfa-dts/`](/board/stmicroelectronics/stm32mp157/tfa-dts), Device
        Tree files produced by STM32 Cube MX for TF-A. Only used by
        the demo configurations.
      * [`dk1-overlay/`](/board/stmicroelectronics/stm32mp157/dk1-overlay/),
        the root filesytem overlay for the DK1 configurations. Only used by
        the demo configurations. It contributes `/boot/extlinux.conf` to the
        root filesystem to select the devicetree generated by STM32 Cube MX.
      * [`dk2-overlay/`](/board/stmicroelectronics/stm32mp157/dk2-overlay/),
        the root filesytem overlay for the DK2 configurations. Only used by
        the demo configurations. It contributes `/boot/extlinux.conf` to the
        root filesystem to select the devicetree generated by STM32 Cube MX.
        It adds also the Wifi firmware configuration file.
      * [`linux-dts/`](/board/stmicroelectronics/stm32mp157/linux-dts),
        Device Tree files produced by STM32 Cube MX for Linux. Only
        used by the demo configurations.
      * [`uboot-dts/`](/board/stmicroelectronics/stm32mp157/uboot-dts),
        Device Tree files produced by STM32 Cube MX for U-Boot. Only
        used by the demo configurations.
      * [`flash.tsv`](/board/stmicroelectronics/stm32mp157/flash.tsv),
        configuration file for the STM32 Cube Programmer. Only valid
        for SD card flashing.
      * [`genimage.cfg`](/board/stmicroelectronics/stm32mp157/genimage.cfg),
        configuration file for the `genimage` utility, which produces
        the final `sdcard.img` SD card image. It describes the
        partition layout of the SD card.
      * [`linux.config`](/board/stmicroelectronics/stm32mp157/linux.config),
        the Linux kernel configuration file.
      * [`post-image.sh`](/board/stmicroelectronics/stm32mp157/post-image.sh),
        the script executed by Buildroot at the end of the build to
        produce the SD card image.
* `package/m4projects`
  Add support to a m4projects package. This package builds and installs all
  the examples of the [STM32CubeMP1](https://github.com/STMicroelectronics/STM32CubeMP1.git)
  sources for the DK2 board. It uses a [python script](/package/m4projects/parse_project_config.py)
  as a wrapper to transform the .project and .cproject files readable by
  the dedicated [Makefile](/package/m4projects/Makefile.stm32).
* `configs/`
  * [`st_stm32mp157a_dk1_defconfig`](/configs/st_stm32mp157a_dk1_defconfig),
    minimal configuration for the DK1
  * [`st_stm32mp157a_dk1_demo_defconfig`](/configs/st_stm32mp157a_dk1_demo_defconfig),
    demo configuration for the DK1
  * [`st_stm32mp157c_dk2_defconfig`](/configs/st_stm32mp157c_dk2_defconfig),
    minimal configuration for the DK2
  * [`st_stm32mp157c_dk2_demo_defconfig`](/configs/st_stm32mp157c_dk2_demo_defconfig),
    demo configuration for the DK2
* `docs`, documentation
* `Config.in`, top-level Config.in file mandatory in all `BR2_EXTERNAL`
  trees. Indicate the location of the Config.in file from our m4projects
  package.
* `README.md`
* `external.desc`, mandatory in all `BR2_EXTERNAL` trees, gives a name
  and description for the `BR2_EXTERNAL` tree
* `external.mk`, mandatory in all `BR2_EXTERNAL` trees, indicate the
  location of `*.mk` file from new packages.

## Changes compared to upstream Buildroot

The `st/2021.02` branch of this `BR2_EXTERNAL` is designed to work
with Buildroot 2021.02. However, we needed a few changes compared to
upstream Buildroot 2021.02, which can be seen at
[https://github.com/bootlin/buildroot/commits/st/2021.02](https://github.com/bootlin/buildroot/commits/st/2021.02). We
have just 4 changes on top of Buildroot 2021.02, and they can easily
be rebased on top of the latest Buildroot 2021.02.x to continue to
benefit from the security fixes provided by the Buildroot community.

Here are the 3 changes:

* Update the `gcnano-binaries` package to a newer version. This
  package contains the closed-source OpenGL user-space libraries,
  which need to be in sync with the kernel side. This change has been
  accepted in upstream Buildroot.

* Improvement of the TF-A package to be able to use arbitrary
  out-of-tree Device Tree files, like was already possible for U-Boot
  or Linux. This change has been accepted in upstream Buildroot.

* Update the `arm-gnu-a-toolchain` package to a newer version. This pakage
  is needed to build Firmware examples for the Cortex M4. The old version
  had issue with the nano.spec files, which adds `-lc_nano` options without
  delivering the `c_nano` library.
