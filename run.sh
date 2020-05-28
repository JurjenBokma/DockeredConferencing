#!/bin/sh

DUSER=docker
DHOME=/home/docker

# Heuristic: sometimes my /dev/video0 is suddenly /dev/video1.
# But the camera I use is alwas the first one. YMMV.
VIDEODEV_1ST="$(find /dev/ -maxdepth 1 -name video\*|sort|head -1)"

docker run \
     --rm \
     -it \
     --net host \
     --cpuset-cpus 0 \
     --memory 512mb \
     --device=/dev/bus/usb:/dev/bus/usb \
     --device=/dev/input/by-id/usb-Logitech_Logitech_USB_Headset-event-if03 \
     --device=/dev/input/by-id/usb-046d_09a4_7D317E10-event-if00 \
     --device=/dev/dri:/dev/dri \
     --device=${VIDEODEV_1ST}:${VIDEODEV_1ST} \
     --security-opt seccomp=chromium.json \
     --group-add=video \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     -v "$HOME/.Xauthority:${DHOME}/.Xauthority:rw" \
     -e DISPLAY=unix$DISPLAY \
     -v $HOME/.config/google-chrome/:/data \
     -v $HOME/.config/skypeforlinux:${DHOME}/.config/skypeforlinux \
     -v $HOME/.config/discord:${DHOME}/.config/discord \
     -v $HOME/.config/bluejeans-v2:${DHOME}/.config/bluejeans-v2 \
     -v $HOME/.config/Wire:${DHOME}/.config/Wire \
     -v $HOME/.config/Slack:${DHOME}/.config/Slack \
     -v $HOME/.config/fontconfig:${DHOME}/.config/fontconfig \
     -v $HOME/.config/gtk-3.0:${DHOME}/.config/gtk-3.0 \
     -v $HOME/.config/pulse:${DHOME}/.config/pulse \
     -v $HOME/Downloads:${DHOME}/Downloads \
     -v /var/run/docker.sock:/var/run/docker.sock \
     --name skype_experiment \
     skype:latest
