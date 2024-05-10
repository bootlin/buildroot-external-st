# RAUC OTA support

Applicable platforms: STM32MP257-EV1, STM32MP157-DK1, STM32MP157-DK2, STM32MP135-DK

OTA support is only enabled in the *demo* configurations.

RAUC is configured to use symmetric with two rootfs.0 and rootfs.1
partition.


Use `rauc status` command to see the current boot state.
```
# rauc status
=== System Info ===
Compatible:  stm32mp157d-dk1-mx
Variant:
Booted from: rootfs.0 (A)

=== Bootloader ===
Activated: rootfs.0 (A)
zsh:1: command not found: :w
=== Slot States ===
o [rootfs.1] (/dev/mmcblk0p6, raw, inactive)
	bootname: B
	boot status: good

x [rootfs.0] (/dev/mmcblk0p5, raw, booted)
	bootname: A
	boot status: good

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
 20% Determining slot states done.
 20% Checking bundle
 20% Verifying signature
 40% Verifying signature done.
[  562.642672] loop0: detected capacity change from 0 to 98716
 40% Checking bundle done.
[  562.688265] loop0: detected capacity change from 98716 to 98712
 40% Checking manifest contents
 60% Checking manifest contents done.
[  562.746322] device-mapper: verity: sha256 using implementation "stm32-sha256"
 60% Determining target install group
 80% Determining target install group done.
 80% Updating slots
 80% Checking slot rootfs.1
 90% Checking slot rootfs.1 done.
 90% Copying image to rootfs.1
 99% Copying image to rootfs.1 done.
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
Compatible:  stm32mp157d-dk1-mx
Variant:
Booted from: rootfs.1 (B)

=== Bootloader ===
Activated: rootfs.1 (B)

=== Slot States ===
x [rootfs.1] (/dev/mmcblk0p6, raw, booted)
	bootname: B
	boot status: good

o [rootfs.0] (/dev/mmcblk0p5, raw, inactive)
	bootname: A
	boot status: good
```

You can look at the [Rauc documentation](https://rauc.readthedocs.io/en/latest/index.html)
to discover all the update features offered by RAUC.
