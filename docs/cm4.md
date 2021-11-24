# Use the Firmware examples for the CM4

The Firmware examples for the CM4 from [STM32CubeMP1](https://github.com/STMicroelectronics/STM32CubeMP1.git)
are enabled in the *demo* configuration.
All examples built are installed in the path `/usr/lib/Cube-M4-examples/`
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
