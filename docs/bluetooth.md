# Using Bluetooth

This only applies to the Discovery Kit 2, with its *demo* configuration.

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

Of course, if necessary, Buildroot supports adding network management
tools such as *Network Manager* or *Connman*.
