# Using audio

Audio is enabled in the *demo* configurations, with some alsa-utils tools.

```
# modprobe snd_soc_cs42l51_i2c
[  133.725330] cs42l51 0-004a: Cirrus Logic CS42L51, Revision: 01
```

This command loads the audio codec module. Then you just need to plug you
headphones to the Jack connector and play a sound.

```
# aplay /usr/share/sounds/alsa/Front_Center.wav
```
