# Setup

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

