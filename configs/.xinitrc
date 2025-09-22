#!/bin/sh
setxkbmap cz
pulseaudio --start
exec i3
