#!/bin/bash

sudo
xorg
i3
bash-completion
lightdm
gnome-ternimal
gnome-calculator
firefox-esr
pavucontrol
gedit
wget
lm-sensors
python3-pip
ncal
obs-studio
bc #math comand line
ntp #Network Time Protocol
google-chrome-stable

# Install packages
sudo apt update && apt install \
    xsel curl sed zenity \
    exa bat redshift \
    feh scrot xclip htop \
    i3blocks i3lock \
    gnome-disk-utility \
    network-manager-gnome \
    git \
    nautilus  keepassxc transmission pulseaudio \
    vlc obs-studio shotcut gimp \

# Flatpack install and add the Flathub repository
sudo apt install flatpak  && \
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Discord via Flatpak
flatpak install flathub com.discordapp.Discord
#https://flathub.org/apps/com.discordapp.Discord

# Install Bitwarden via Flatpak
flatpak install flathub com.bitwarden.desktop
#https://flathub.org/apps/com.bitwarden.desktop


# Conceder privileios sudo para usuarios

# Packages with Manual Installation

sublimetext
#https://www.sublimetext.com/docs/linux_repositories.html#apt


github-cli

#https://github.com/cli/cli/blob/trunk/docs/install_linux.md

codium

#https://vscodium.com/#install

pyenv

#https://github.com/pyenv/pyenv

docker

#https://docs.docker.com/engine/install/debian/
