# Testing Suspend-to-RAM

Supported on all platforms.

```
# echo +20 > /sys/class/rtc/rtc0/wakealarm
# echo mem > /sys/power/state
[   83.628116] PM: suspend entry (deep)
[   83.630834] Filesystems sync: 0.000 seconds
[   83.635433] Freezing user space processes
[   83.639941] Freezing user space processes completed (elapsed 0.001 seconds)
[   83.645579] OOM killer disabled.
[   83.648848] Freezing remaining freezable tasks
[   83.654341] Freezing remaining freezable tasks completed (elapsed 0.000 seconds)
[   83.660730] printk: Suspending console(s) (use no_console_suspend to debug)
```

With theses commands the system is suspended and resumes 20 second later.
You can also push the `WAKE UP` button to wake up the board.

```
NOTICE:  CPU: STM32MP157FAC Rev.Z
NOTICE:  Model: STMicroelectronics STM32MP157F-DK2 Discovery Board
NOTICE:  Board: MB1272 Var4.0 Rev.C-02
NOTICE:  BL2: v2.10-stm32mp1-r1.0(release):custom()
NOTICE:  BL2: Built : 10:18:08, Jan  6 2025
NOTICE:  BL2: Booting BL32
[   83.852705] Disabling non-boot CPUs ...
[   83.854164] CPU1 killed.
[   83.855013] Enabling non-boot CPUs ...
[   83.857006] CPU1 is up
[   83.910619] usb usb2: root hub lost power or was reset
[   84.259445] onboard-usb-hub 2-1: reset high-speed USB device number 2 using ehci-platform
[   84.606387] OOM killer enabled.
[   84.609521] Restarting tasks ... done.
[   84.613633] random: crng reseeded on system resumption
[   84.618856] PM: suspend exit
```

Here is the wake up logs.

---
Notes:

The Bluetooth driver does not support suspend-to-RAM. To use Bluetooth
after a suspend-to-RAM operation, you must reload the `hci_uart` module
using the following commands:

```
# modprobe -r hci_uart
# modprobe hci_uart
```
