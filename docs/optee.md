# Using OP-TEE

OP-TEE is automatically started at boot time by TF-A, and runs as the
Trusted Execution Environment. See
[this page](https://wiki.st.com/stm32mpu/wiki/OP-TEE_overview) on the
ST32MPU Wiki for an overview of OP-TEE on STM32MPU.

It should be noted that on STM32MP157 platforms, starting from its
Yocto BSP 5.0.0, ST has chosen to load OP-TEE into DDR instead of the
SYSRAM memory. As the DDR is not encrypted, ST has chosen to disable
the support of user Trusted Application (TA), breaking the usage of
OP-TEE from Linux user-space applications. In the current Buildroot
integration for STM32MP1 platforms, we have chosen to keep OP-TEE in
SYSRAM, preserving this functionality.

From Linux, OP-TEE can be tested using a few [example OP-TEE
applications](https://optee.readthedocs.io/en/latest/building/gits/optee_examples/optee_examples.html).
available only in the *demo* configuration.

```
# optee_example_hello_world
```

This is a very simple Trusted Application to answer a hello command
and increment an integer value.

```
# optee_example_random
```

Generates a random UUID using capabilities of TEE API.

```
# optee_example_aes
```

Runs an AES encryption and decryption from a TA using the
GlobalPlatform TEE Internal Core API. Non secure test application
provides the key, initial vector and ciphered data.
