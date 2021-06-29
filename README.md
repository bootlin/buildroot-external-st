# StMicroelectonics external tree

This repository contains the ST external tree to customize Buildroot.
It contains defconfig to configures Builroot with Kernel, U-boot and TFA
from STMicroelectronics.

## How to

Clone the Buildroot original repository alongside to this repository.
Move to the Buildroot directory.

Configure Buildroot to use the external tree and select the wanted
defconfig.

```bash
buildroot/ $ make BR2_EXTERNAL=/path/to/st_external_tree st_stm32mp157c_dk2_defconfig
```

Compile Buildroot as usual

```bash
buildroot/ $ make
```

## References

https://buildroot.org/downloads/manual/manual.html#outside-br-custom
