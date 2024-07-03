# Release notes

## openstlinux-6.1-buildroot-2024.02.3-mpu-v24.06.26

Changes in this release:

- Based on Buildroot 2024.02.3

- Based on the BSP components of ST's 5.1 BSP: Linux 6.1, U-Boot
  2022.10, TF-A 2.8, OP-TEE 3.19, gcnano-binaries 6.4.15

- Remove support for STM32MP157A-DK1 and STM32MP157C-DK2 board.

- Add support for STM32MP257F-EV1 board.

- Add support for Trusted-Firmware-M

- Add support for m33projects package to build Cortex M33 application
  examples.

## openstlinux-6.1-buildroot-2023.02.10-mp1-v23.11.15

Changes in this release:

- Based on Buildroot 2023.02.10

- Based on last revision on the BSP components of ST, no change in major
  version.

- Addition of starter package for easy accessibility of prebuilt images.

- Add support for OTA with RAUC tool. The OTA configuration is using two
  rootfs partition containing the read only root file system and an
  additional data read write partition. The boot switch is managed by
  U-boot with custom environment.

## openstlinux-6.1-buildroot-2023.02-mp1-v23.06.21

Changes in this release:

- Based on Buildroot 2023.02.2

- Based on the BSP components of ST's 5.0 BSP: Linux 6.1, U-Boot
  2022.10, TF-A 2.8, OP-TEE 3.19, gcnano-binaries 6.4.13

- Addition of `wireless-regdb` in the demo images for WiFi operation

- Fix of a kernel issue that prevented the proper auto-loading of the
  audio codec driver
