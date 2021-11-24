# Using audio

Audio is enabled in the *demo* configurations, with some alsa-utils tools.

```
# modprobe snd_soc_cs42l51_i2c
# alsactl restore
```

These two commands load the audio codec module and the alsa setup
configuration for the soundcard. You just need to plug you
headphones to the Jack connector and play a sound.

```
# aplay /usr/share/sounds/alsa/Front_Center.wav
```
