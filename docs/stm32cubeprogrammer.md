# Using STM32 Cube Programmer

Applicable platforms: STM32MP157-DK1, STM32MP157-DK2, STM32MP135-DK, STM32MP257F-EV1.

[STM32 Cube
Programmer](https://www.st.com/en/development-tools/stm32cubeprog.html)
is a utility provided by ST that allows to reflash an STM32MPU
platform directly from your PC. It is particularly useful if the
storage used on your STM32MPU platform is non-removable, such as an
eMMC or NAND flash. STM32 Cube Programmer uses USB connectivity with
the STM32MPU platform to do the reflashing, and it works even if the
STM32MPU platform has no software installed.

To get started, download STM32 Cube Programmer from the [ST
website](https://www.st.com/en/development-tools/stm32cubeprog.html). It
unfortunately requires having an account on *st.com*. We tested with
version 2.17.0, and the below instructions assume that STM32 Cube
Programmer is installed in the `$HOME/stm32cube` folder.

As the STM32MP157-DK1/DK2 or the STM32MP135F-DK do not provide any
non-removable storage device, our demonstration will use the SD card:
STM32 Cube Programmer will be used to reflash the SD card, with the SD
card inserted in the STM32MPU platform.

Follow these steps:

1. Switch the boot mode switch SW1 to USB boot
   - STM32MP157: BOOT0 and BOOT2 to OFF
   - STM32MP135: BOOT0, BOOT1 and BOOT2 to OPEN
   - STM32MP257: BOOT0, BOOT1, BOOT2 and BOOT3 to OPEN
2. Plug a second USB-C cable on CN7 on the STM32MP157/135 or CN15 on the
   STM32MP257F-EV1.
3. Run these commands to flash the SDCard:
```bash
$ cd output/images/
$ sudo ~/stm32cube/bin/STM32_Programmer_CLI -c port=usb1 -w flash.tsv
```
4. Switch back the boot mode switch to SD boot
   - STM32MP157: BOOT0 and BOOT2 to ON
   - STM32MP135: BOOT0 to ON, BOOT1 to OPEN, BOOT2 to ON
   - STM32MP257: BOOT0 to ON, BOOT1, BOOT2 and BOOT3 to OPEN
5. Reboot the platform

The `flash.tsv` file has been produced by Buildroot and tells STM32
Cube Programmer what to flash. If you want to reflash an eMMC storage
device instead, this `flash.tsv` file will have to be adapted.

Additional information:

* [STM32 Cube Programmer on the ST
  Wiki](https://wiki.st.com/stm32mpu/wiki/STM32CubeProgrammer), the
  best source of information

* A [blog
  post](https://bootlin.com/blog/building-a-linux-system-for-the-stm32mp1-implementing-factory-flashing/
  "Factory flashing a STM32") from Bootlin giving more details on
  STM32 Cube Programmer usage.

* The [STM32 Cube Programmer user
  manual](https://www.st.com/resource/en/user_manual/dm00403500-stm32cubeprogrammer-software-description-stmicroelectronics.pdf
  "STM32CubeProgrammer User Manual").
