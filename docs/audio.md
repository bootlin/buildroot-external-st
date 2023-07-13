# Using audio

Applicable platforms: STM32MP157-DK1, STM32MP157-DK2.

Audio is enabled in the *demo* configurations, with some ALSA
utilities installed in the root filesystem.

Get started with:

```
# alsactl restore
```

This command loads the ALSA setup configuration for the soundcard. You
just need to plug you headphones to the Jack connector and play a
sound.

```
# aplay /usr/share/sounds/alsa/Front_Center.wav
```
