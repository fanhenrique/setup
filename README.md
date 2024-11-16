# Setup

### .bash_aliases

Uncomment this block in `/home/<user>/.bashrc`.

```shell
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

### Brightness

The (brightness.sh)[./brightness.sh] script changes the screen brightness.

```
Usage: ./brightness.sh [OPTIONS...]

Brightness options:
  -u, --up              Up brightness
  -d, --down            Down brightness
  -r, --reset           Reset brightness to 1.0
  -s, --step [number]   Step brightness (percentage) [default 5]

Monitor options:
  -m, --monitor         Monitor
  -f, --find            Find monitor name

  -h, --help            Show this help message
```

Example:

Increases brightness by 10% on monitor connected via HDMI-1.
```
./brigtness --up --step 10 --monitor HDMI-1
```

Decreases brightness by 5% on monitor connected via eDP-1.
```
./brigtness --down --step 5 --monitor eDP-1
```

