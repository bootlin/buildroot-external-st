# Using Bluetooth

Applicable platforms: STM32MP157-DK2, STM32MP135-DK.

Bluetooth support is only enabled in the *demo* configurations.

Use the `bluetoothctl` command to scan and connect close Bluetooth devices.
```
# bluetoothctl
Agent registered
[CHG] Controller 43:43:A1:12:1F:AC Pairable: yes
[bluetooth]# power on
Changing power on succeeded
[CHG] Controller 43:43:A1:12:1F:AC Powered: yes
[bluetooth]# scan on
Discovery started
[CHG] Controller 43:43:A1:12:1F:AC Discovering: yes
[NEW] Device xx:xx:xx:xx:xx:xx device1
[NEW] Device xx:xx:xx:xx:xx:xx device2
[bluetooth]# scan off
[bluetooth]# connect xx:xx:xx:xx:xx:xx
```

The full BlueZ stack is installed as part of the *demo*
configuration. See the [BlueZ](http://www.bluez.org/) website for more
details.