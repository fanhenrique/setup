#!/bin/bash

# Detect the network interface used by the default route.
INTERFACE=""

if [[ -z "$INTERFACE" ]]; then
    INTERFACE=$(ip route | awk '/^default/ { print $5; exit }')
fi

# Exit if no network interface could be detected.
if [[ -z "$INTERFACE" ]]; then
    printf '<span foreground="#ee0d0d" weight="bold">network</span> <span foreground="#ee0d0d">down</span>\n'
    exit 0
fi

# Store network statistics in a temporary file specific to the interface.
CACHE="/dev/shm/waybar-network-${INTERFACE}"

# File used to indicate whether the network module is expanded.
STATE="/tmp/waybar-network-expanded"

# Signal used to force Waybar to refresh the module.
SIGNAL=7

# Toggle the expanded state when the module is clicked.
if [[ "$1" == "expandable" ]]; then
    if [[ -f "$STATE" ]]; then
        rm -f "$STATE"
    else
        touch "$STATE"
    fi

    pkill -RTMIN+"$SIGNAL" waybar
    exit 0
fi

# Interface operational state.
OPERSTATE="/sys/class/net/$INTERFACE/operstate"

# Format the transfer rate using bytes, KiB/s, or MiB/s.
format_rate() {
    local rate=$1

    # Display MiB/s for rates greater than or equal to 1 MiB/s.
    if ((rate >= 1048576)); then
        printf '<tt>%5.1f<b>M</b></tt>' "$(awk "BEGIN {print $rate/1048576}")"

    # Display KiB/s for rates greater than or equal to 1 KiB/s.
    elif ((rate >= 1024)); then
        printf '<tt>%5.1f<b>K</b></tt>' "$(awk "BEGIN {print $rate/1024}")"

    # Display bytes/s for lower transfer rates.
    else
        printf '<tt>%5.f<b>B</b></tt>' "$rate"
    fi
}

# Check whether the network interface is operational.
if [[ ! -r "$OPERSTATE" || $(<"$OPERSTATE") != "up" ]]; then
    printf '<span foreground="#ee0d0d" weight="bold">%s</span> <span foreground="#ee0d0d">down</span>\n' "$INTERFACE"
    exit 0
fi

# Files containing cumulative received and transmitted byte counters.
RX_FILE="/sys/class/net/$INTERFACE/statistics/rx_bytes"
TX_FILE="/sys/class/net/$INTERFACE/statistics/tx_bytes"

# Read the current network byte counters.
rx=$(<"$RX_FILE")
tx=$(<"$TX_FILE")

# Get the current time in nanoseconds.
now=$(date +%s%N)

# Initialize the cache on the first execution.
if [[ ! -f "$CACHE" ]]; then
    printf "%s %s %s\n" "$now" "$rx" "$tx" > "$CACHE"
    exit 0
fi

# Read the previous timestamp and byte counters.
read -r old_time old_rx old_tx < "$CACHE"

# Store the current values for the next execution.
printf "%s %s %s\n" "$now" "$rx" "$tx" > "$CACHE"

# Calculate the elapsed time in nanoseconds.
dt=$((now - old_time))

# Prevent division by zero.
if ((dt <= 0)); then
    dt=1
fi

# Calculate the number of bytes transferred since the previous measurement.
rx_bytes=$((rx - old_rx))
tx_bytes=$((tx - old_tx))

# Convert the transferred bytes into bytes per second.
rx_rate=$((rx_bytes * 1000000000 / dt))
tx_rate=$((tx_bytes * 1000000000 / dt))

# Display additional information when the module is expanded.
if [[ -f "$STATE" ]]; then

    # Get the IPv4 address assigned to the interface.
    IPADDR=$(ip -4 addr show "$INTERFACE" |
        awk '/inet / {print $2; exit}' |
        cut -d/ -f1)

    # Display interface name.
    printf '<span foreground="#00ff00" weight="bold">%s</span> ' "$INTERFACE"

    # Display IPv4 address.
    printf '<b>%s</b> ' "$IPADDR"

    # Display received data rate.
    printf '<b>↓</b>%s ' "$(format_rate "$rx_rate")"

    # Display transmitted data rate.
    printf '<b>↑</b>%s\n' "$(format_rate "$tx_rate")"

else

    # Display only the interface name in the collapsed state.
    printf '<span foreground="#00ff00" weight="bold">%s</span>\n' "$INTERFACE"
fi