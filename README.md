# Setup

## Packeges

xsel curl sed zenity
exa xclip redshift
feh scrot htop batcat
python3
nautilus bitwarden keepassxc transmission pulseaudio
google-chrome-stable
vlc obs-studio shotcut gimp

## i3

The [i3](https://i3wm.org/) is a tiling window manager for X11, is free and open source software to GNU/Linux e BSD operating systems.

### Configuration

For all users, the configuration is in `etc/i3/config`. For specific users, the configuration is in `$HOME/.config/i3/config`.

To generate the default i3 configuration, use:

```bash
i3-config-wizard
```

Copy the [`i3/`](./i3) directory to`$HOME/.config/`.

> See [i3 User’s Guide](https://i3wm.org/docs/userguide.html) for a complete reference.

### Finding the name of a key

To add the new bindsym, use the following command and press the key whose name you want to know:

```bash
xev -event keyboard
```

### i3blocks

[i3blocks](https://github.com/vivien/i3blocks) is a feed generator for text based status bars.
It executes your command lines and generates a status line from their output.
Commands are scheduled at configured time intervals, upon signal reception or on clicks.
The generated line is meant to be displayed by the i3 window manager through its i3bar component, as an alternative to i3status (default i3bar).

Copy the [`i3blocks/`](./i3blocks) directory to `$HOME/.config/`.

## Network Manager

Network managers via terminal.
`nmcli` `nmtui`

See Arch and Debian wiki for more information:

Arch: https://wiki.archlinux.org/title/NetworkManager

Debian: https://wiki.debian.org/NetworkManager

## Aliases

Copy the [`.bash_aliases`](./.bash_aliases) file to `$HOME`.

Uncomment this block in `$HOME/.bashrc`.

```bash
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

## Monitors

The [`monitors.sh`](./monitors.sh) script sets the resolution, refresh rate, and positioning of the monitors.

Copy the `monitors.sh` file to `$HOME`.

To start the system with this configuration, add the following line to `$HOME/.xsessionrc`.

```bash
if [ -f ~/monitors.sh ]; then
    . ~/monitors.sh
fi
```

## Monitor Control

Control brightness of monitors.

[monitorctl](https://github.com/fanhenrique/monitorctl)

## Keyboard

See in this repository: https://github.com/fanhenrique/crkbd

## Dark theme GTK

See Arch wiki for more information: https://wiki.archlinux.org/title/GTK

### GTK 3

Copy the [`gtk-3.0`](./gtk-3.0) directory to `$HOME/.config/`

### GTK 4

```bash
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

## VSCodium Settings

Copy the [`VSCodium/settings.json`](settings.json) file
and [`VSCodium/keybindings.json`](keybindings.json) file
to `$HOME/.config/VSCodium/User` directory.

## Blue filter

Script to change the brightness and redshift.

Set default values ​​for `BRIGHTNESS` and `REDSHIFT` in `blue_filter.sh`

`-b/--brightness=[0.0-1.0]`

`-r/--redshift=[1000-25000]`

```
bf -b 0.7 -r 3800
```

# Manually Installed Programs

## Google Chrome

[Google Chrome](https://www.google.com/intl/pt-BR/chrome/)

## Bitwarden

[Bitwarden](https://bitwarden.com)

## VSCodium 

[VSCodium](https://vscodium.com/)

## Github CLI

[Github CLI](https://cli.github.com/)

## Pyenv

[Pyenv](https://github.com/pyenv/pyenv) lets you easily switch between multiple versions of Python.
It's simple, unobtrusive, and follows the UNIX tradition of single-purpose tools that do one thing well.
