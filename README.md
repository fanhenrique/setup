# Setup

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

## Brightness

The [`brightness.sh`](./brightness.sh) script changes the screen brightness.

See the help message for more usage details.

```bash
./brightness.sh --help
```

Example:

Increases brightness by 10% on monitor connected via HDMI-1.

```bash
./brigtness --up --step 10 --monitor HDMI-1
```

Decreases brightness by 5% on monitor connected via eDP-1.

```bash
./brigtness --down --step 5 --monitor eDP-1
```

## Keyboard

### Keyboard configuration

Generate the `keyboard` file by `dpkg-reconfigure keyboard-configuration` command and restart the `keyboard-setup` service.

Or copy the [`keyboard`](./keyboard) file to `/etc/default/` and restart the `keyboard-setup` service.

```bash
sudo dpkg-reconfigure keyboard-configuration
sudo service keyboard-setup restart
```

> See Debian wiki for more informations: https://wiki.debian.org/Keyboard

### Remap keys

Change this line in `/usr/share/X11/xkb/symbols/us` file.

```bash
# remove
key <AC11> { [ dead_acute, dead_diaeresis, apostrophe, quotedbl ] };

# add
key <AC11> { [ apostrophe,  quotedbl, dead_acute, dead_diaeresis ] };
```

## Dark theme GTK

See Arch wiki for more information: https://wiki.archlinux.org/title/GTK

### GTK 3

Copy the [`gtk-3.0`](./gtk-3.0) directory to `$HOME/.config/`

### GTK 4

```bash
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

