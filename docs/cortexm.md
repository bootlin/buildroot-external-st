# Use the Firmware examples for the Cortex M4 or Cortex M33

Applicable platforms: STM32MP157-DK1, STM32MP157-DK2, STM32MP257-EV1

The different platforms have different Cortex M family coprocessor:
* STM32MP157-DK1 and STM32MP157-DK2: Cortex M4
* STM32MP257-EV1: Cortex M33

The Firmware examples for the CM4 from [STM32CubeMP1](https://github.com/STMicroelectronics/STM32CubeMP1.git)
or the CM33 from [STM32CubeMP2](https://github.com/STMicroelectronics/STM32CubeMP2.git)
are enabled in the *demo* configuration.
All examples built are installed in the path `/usr/lib/Cube-M4-examples/`
or `/usr/lib/Cube-M33-examples/`

## Cortex M4
We will use the *GPIO_EXTI* application for the example as it is easy to
test.

```
# cd /usr/lib/Cube-M4-examples/GPIO_EXTI/
# ./fw_cortex_m4.sh start
fw_cortex_m4.sh: fmw_name=GPIO_EXTI.elf
[  284.342266] remoteproc remoteproc0: powering up m4
[  284.346258] remoteproc remoteproc0: Booting fw image GPIO_EXTI.elf, size
197496
[  284.353331] remoteproc remoteproc0: header-less resource table
[  284.358929] remoteproc remoteproc0: no resource table found for this
firmware
[  284.366048] remoteproc remoteproc0: header-less resource table
[  284.371881] remoteproc remoteproc0: remote processor m4 is now up
```

This run the *GPIO_EXTI* example on the Cortex M4 processor.
Test the behavior of the CM4 application by Pushing the *USER1* button to
toggle the state of the *LED7*.

```
# ./fw_cortex_m4.sh stop
fw_cortex_m4.sh: fmw_name=GPIO_EXTI.elf
[  293.167161] remoteproc remoteproc0: warning: remote FW shutdown without
ack
[  293.172769] remoteproc remoteproc0: stopped remote processor m4
```

To stop the example running on the M4 processor.

## Cortex M33
We will use the *USBPD_DRP_UCSI* application for the example as it is the
one used in OpenST distribution.

```
# /usr/lib/Cube-M33-examples/USBPD_DRP_UCSI/fw_cortex_m33.sh start
fw_cortex_m33.sh: fmw_name=USBPD_DRP_UCSI_CM33_NonSecure_sign.bin
[   18.436576] remoteproc remoteproc0: powering up m33
[   18.554765] remoteproc remoteproc0: Booting fw image USBPD_DRP_UCSI_CM33_NonSecure_sign.bin, size 153148
[   18.559710] rproc-virtio rproc-virtio.1.auto: assigned reserved memory node vdev0buffer@812fa000
[   18.568169] virtio_rpmsg_bus virtio0: rpmsg host is online
[   18.573088] rproc-virtio rproc-virtio.1.auto: registered virtio0 (type 7)
[   18.579978] remoteproc remoteproc0: remote processor m33 is now up
[   19.267503] virtio_rpmsg_bus virtio0: creating channel rpmsg-intc addr 0x400
[   19.277735] virtio_rpmsg_bus virtio0: creating channel rpmsg_i2c addr 0x401
[   19.279321] rpmsg_i2c virtio0.rpmsg_i2c.-1.1025: new channel: 0x401 -> 0x401!

```

This run the *USBPD_DRP_UCSI* example on the Cortex M33 processor which
emulate a stm32mp25-typec usb role switch to detect if the USB-C CN15 is
plugged as a device or a host.

```
# /usr/lib/Cube-M33-examples/USBPD_DRP_UCSI/fw_cortex_m33.sh -t ns_s start
fw_cortex_m33.sh: fmw_name=USBPD_DRP_UCSI_CM33_NonSecure_tfm_sign.bin
[   46.067010] remoteproc remoteproc0: powering up m33
[   46.197826] remoteproc remoteproc0: Booting fw image USBPD_DRP_UCSI_CM33_NonSecure_tfm_sign.bin, size 286164
[   46.203151] rproc-virtio rproc-virtio.1.auto: assigned reserved memory node vdev0buffer@812fa000
[   46.211593] virtio_rpmsg_bus virtio0: rpmsg host is online
[   46.216540] rproc-virtio rproc-virtio.1.auto: registered virtio0 (type 7)
[   46.223546] remoteproc remoteproc0: remote processor m33 is now up
[   47.105247] virtio_rpmsg_bus virtio0: creating channel rpmsg-intc addr 0x400
[   47.115483] virtio_rpmsg_bus virtio0: creating channel rpmsg_i2c addr 0x401
[   47.117061] rpmsg_i2c virtio0.rpmsg_i2c.-1.1025: new channel: 0x401 -> 0x401!

```

You can also use the above command to run the firmware containing
TrustedFirmware-M and the *USBPD_DRP_UCSI* example.

```
# stm32_usbotg_eth_config.sh start
Start usb gadget
[   35.933516] using random self ethernet address
[   35.933578] using random host ethernet address
[   35.963935] usb0: HOST MAC ec:16:02:e2:af:1a
[   35.963998] usb0: MAC f6:87:0a:a3:dc:96
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
...
6: usb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
    link/ether f6:87:0a:a3:dc:96 brd ff:ff:ff:ff:ff:ff

```

Test the behavior of the CM33 application by running
`stm32_usbotg_eth_config.sh` script which will configure USB configfs to
have the USB-C as a USB rndis gadget.
If you plug the USB-C to your computer you will see a new network
interface.

```
# stm32_usbotg_eth_config.sh stop
Stop usb gadget
# /usr/lib/Cube-M33-examples/USBPD_DRP_UCSI/fw_cortex_m33.sh stop
[  687.531875] ucsi-stm32g0-i2c 1-0035: i2c write 35, 08 error: -110
[  687.728373] remoteproc remoteproc0: stopped remote processor m33
```

To stop the example running on the M33 processor.
