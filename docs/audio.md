# Using audio

Applicable platforms: STM32MP157-DK1, STM32MP157-DK2.

Audio is enabled in the *demo* configurations, with some ALSA
utilities installed in the root filesystem.

Get started with:

```
# modprobe snd_soc_cs42l51_i2c
# alsactl restore
```

These two commands load the audio codec kernel module and the ALSA
setup configuration for the soundcard. You just need to plug you
headphones to the Jack connector and play a sound.

```
# aplay /usr/share/sounds/alsa/Front_Center.wav
```
