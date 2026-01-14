# RAUC OTA support

OTA support is only enabled in the *demo* configurations.

RAUC is configured to use a symmetric configuration with two partitions:
rootfs.0 and rootfs.1.
The boot slot selection is performed using
[FWU metadata](https://documentation-service.arm.com/static/660be6391bc22b03bca92702)
at the TF-A level. Therefore, it is possible to update the U-Boot
image during an OTA process.

Use `rauc status` command to see the current boot state.
```
# rauc status
=== System Info ===
Compatible:  stm32mp157f-dk2-mx
Variant:
Booted from: fip.0 (A)

=== Bootloader ===
Activated: fip.0 (A)

=== Slot States ===
x [fip.0] (/dev/disk/by-partlabel/fip-a, raw, booted)
      bootname: A
      boot status: good
    [rootfs.0] (/dev/disk/by-partlabel/rootfs-a, raw, active)

o [fip.1] (/dev/disk/by-partlabel/fip-b, inactive)
      bootname: B
      boot status: good
    [rootfs.1] (/dev/disk/by-partlabel/rootfs-b, raw, inactive)
```

Buildroot generates an update bundle in the image directory:
`output/images/rootfs.raucb`.
To deploy this RAUC update bundle onto the target board, employ
connectivity options such as WiFi, USB, or any applicable method.
Once transferred, utilize the `rauc info` command to glean information from
the update bundle, like its content and configuration.

```
# rauc info /mnt/rootfs.raucb
rauc-Message: 00:01:12.201: Config option 'statusfile=<path>/per-slot' unset, falling back to per-slot status
rauc-Message: 00:01:12.202: Using per-slot statusfile
rauc-Message: 00:01:12.203: valid /etc/rauc/system.conf found, using it
rauc-Message: 00:01:12.203: Reading bundle: /mnt/rootfs.raucb
rauc-Message: 00:01:12.252: Verifying bundle signature...
rauc-Message: 00:01:12.547: Verified inline signature by 'O = Bootlin, CN = rauc-demo'
Compatible:	'stm32mp157d-dk1-mx'
Version:	'2023.02.6-3-gae4a6e0c24'
Description:	'(null)'
Build:		'(null)'
Hooks:		''
Bundle Format:	verity
  Verity Salt:	'c88b391fa796abe2911e30fc66faa45189693d486f48001351be619d83bcc1c6'
  Verity Hash:	'b861d8c44839515de6ca2cb0411810f6bfc2638c31437b471f743287b53a8bc7'
  Verity Size:	397312

1 Image:
  [rootfs]
	Filename:  rootfs.squashfs
	Checksum:  e098279524c721c1365b84084251c0fc54959e2dac17719282027d929bcc3def
	Size:      50573312
	Hooks:

Certificate Chain:
 0 Subject: O = Bootlin, CN = rauc-demo
   Issuer: O = Bootlin, CN = rauc-demo
   SPKI sha256: F3:02:8A:1A:92:B2:8C:66:E4:64:D8:7B:70:6C:61:71:EA:73:31:D7:B0:84:D2:D8:64:1C:63:20:3F:5A:B8:6C
   Not Before: Dec  6 10:49:57 2023 GMT
   Not After:  Dec  5 10:49:57 2027 GMT

```

Use `rauc install` command to install the new rootfs and reboot.
```
# rauc install /mnt/rootfs.raucb
installing
  0% Installing
  0% Determining slot states
 10% Determining slot states done.
 10% Checking bundle
 10% Verifying signature
[   70.117552] loop0: detected capacity change from 0 to 161781
 20% Verifying signature done.
 20% Checking bundle done.
[   70.130741] loop0: detected capacity change from 161781 to 161776
[   70.164820] device-mapper: verity: sha256 using implementation "stm32-sha256"
 20% Checking manifest contents
 30% Checking manifest contents done.
 30% Determining target install group
 40% Determining target install group done.
 40% Updating slots
 40% Checking slot rootfs.1
 43% Checking slot rootfs.1 done.
 43% Copying image to rootfs.1
...
 70% Copying image to rootfs.1 done.
 70% Checking slot fip.1 (B)
 73% Checking slot fip.1 (B) done.
 73% Copying image to fip.1
...
 99% Copying image to fip.1 done.
 99% Updating slots done.
100% Installing done.
idle
Installing `/mnt/rootfs.raucb` succeeded
# reboot
```

Then use `rauc status` command to verify the boot partition.
```
# rauc status
=== System Info ===
Compatible:  stm32mp157f-dk2-mx
Variant:
Booted from: fip.1 (B)

=== Bootloader ===
Activated: fip.1 (B)

=== Slot States ===
o [fip.0] (/dev/disk/by-partlabel/fip-a, raw, inactive)
      bootname: A
      boot status: good
    [rootfs.0] (/dev/disk/by-partlabel/rootfs-a, raw, inactive)

x [fip.1] (/dev/disk/by-partlabel/fip-b, booted)
      bootname: B
      boot status: good
    [rootfs.1] (/dev/disk/by-partlabel/rootfs-b, raw, active)
```

You can look at the [Rauc documentation](https://rauc.readthedocs.io/en/latest/index.html)
to discover all the update features offered by RAUC.
