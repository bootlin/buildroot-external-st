# Using WiFi

Applicable platforms: STM32MP157-DK2, STM32MP135-DK.

WiFi support is only enabled in the *demo* configurations.

The `brcmfmac` Linux kernel module for Wifi is autoloaded, thanks to
*udev*.

You can verify that it has been correctly loaded with the `lsmod`
command:

```
# lsmod | grep brcmfmac
brcmfmac              212992  0
```

Then you can scan access points with `iw` command, connect to them
with `wpa_supplicant`, and get an IP address using the `udhcpc` DHCP
client.

```
# ip link set wlan0 up
# iw dev wlan0 scan
# wpa_passphrase $SSID $PSK > /data/wpa_supplicant.conf
# wpa_supplicant -i wlan0 -c /data/wpa_supplicant.conf -B
# udhcpc -i wlan0 -q
```

Of course, if necessary, Buildroot supports adding network management
tools such as *Network Manager*, *Connman* or *systemd-networkd*.
