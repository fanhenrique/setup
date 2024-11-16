#!/bin/bash

# Primary monitor - Connected via HDMI
xrandr --auto --output HDMI-1 --primary --mode 1920x1080 --rate 60.0 

# Secondary monitor
xrandr --auto --output eDP-1 --mode 1366x768 --rate 60.0 --right-of HDMI-1
