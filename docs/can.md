# Using the CAN bus

Applicable platforms: STM32MP257-EV1.

Tool for testing the CAN bus are only included in the *demo* configurations.

You can perform a loopback test on one of the CAN bus ports. First, configure
the bitrates and enable loopback:

```
# ip link set can0 up type can bitrate 1000000 dbitrate 2000000 fd on loopback on
```

The `can-utils` package is included in the demo rootfs. You can send messages on
the CAN port with `cansend` and receive them with `candump`.

```
# candump can0 -L &
# cansend can0 116#CA.FE.DE.CA.00.01.02.03
(0946711043.871236) can0 116#CAFEDECA00010203
(0946711043.871221) can0 116#CAFEDECA00010203
```

