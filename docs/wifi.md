# Using WiFi

This only applies to the Discovery Kit 2, with its *demo* configuration.

To use Wifi you first need to load the `brcmfmac` Linux kernel module
with the firmware configuration. We can use the firmware configuration
provided by the `linux-firmware` package for the RaspberryPi 3:

```
# cp /lib/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt /lib/firmware/brcm/brcmfmac43430-sdio.txt
# modprobe brcmfmac
```

Then you can scan access points with `iw` command, connect to them
with `wpa_supplicant`, and get an IP address using the `udhcpc` DHCP
client.

```
# ip link set wlan0 up
# iw dev wlan0 scan
# wpa_passphrase $SSID $PSK > /etc/wpa_supplicant.conf
# wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -B
# udhcpc -i wlan0 -q
```

Of course, if necessary, Buildroot supports adding network management
tools such as *Network Manager*, *Connman* or *systemd-networkd*.
