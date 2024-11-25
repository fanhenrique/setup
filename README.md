# Setup

### i3

The [i3](https://i3wm.org/) is a tiling window manager for X11, is free and open source software to GNU/Linux e BSD operating systems.

#### configuration

For all users, the configuration is in `etc/i3/config`. For specific users, the configuration is in `/home/<user>/.config/i3/config`.

To generate the default i3 configuration, use:

```bash
i3-config-wizard
```

**Please see https://i3wm.org/docs/userguide.html for a complete reference**

Copy the [`i3/`](./i3) diretory to the`/home/<user>/.config/` path.

#### Finding the name of a key

To add the new bindsym, use the following command and press the key whose name you want to know:

```bash
xev -event keyboard
```

### .bash_aliases

Copy [`.bash_aliases`](./.bash_aliases) to `/home/<user>`.

Uncomment this block in `/home/<user>/.bashrc`.

```bash
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

### Monitors

The [`monitors.sh`](./monitors.sh) script sets the resolution, refresh rate, and positioning of the monitors.

Copy `monitors.sh` to `/home/<user>`.

To start the system with this configuration, add the following line to `/home/<user>/.xsessionrc`.

```bash
if [ -f ~/monitors.sh ]; then
    . ~/monitors.sh
fi
```

### Brightness

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

