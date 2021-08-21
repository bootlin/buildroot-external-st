# Using OP-TEE

In the *demo* configurations, OP-TEE is automatically started at boot
time by TF-A, and runs as the Trusted Execution Environment. See [this
page](https://wiki.st.com/stm32mpu/wiki/OP-TEE_overview) on the
ST32MP1 Wiki for an overview of OP-TEE on STM32MP1.

From Linux, OP-TEE can be tested using a few [example OP-TEE
applications](https://optee.readthedocs.io/en/latest/building/gits/optee_examples/optee_examples.html).

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
