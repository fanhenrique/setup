#!/bin/bash

CACHE="/dev/shm/ironbar-network-cache"

# Format the transfer rate using bytes, KiB/s, or MiB/s.
format_rate() {
    local rate=$1

    if ((rate >= 1048576)); then
        printf "%4.1fM/s" "$(awk "BEGIN {print $rate/1048576}")"
    elif ((rate >= 1024)); then
        printf "%4.1fK/s" "$(awk "BEGIN {print $rate/1024}")"
    else
        printf "%4.0fB/s" "$rate"
    fi
}

get_interface() {
    ip route | awk '/^default/ {print $5; exit}'
}

get_ip() {
    local interface
    interface=$(get_interface)

    [[ -z "$interface" ]] && return

    ip -4 -o addr show dev "$interface" |
        awk '{print $4}' |
        cut -d/ -f1 |
        head -n1
}

get_rate() {
    local interface
    local rx
    local tx
    local now
    local old_time
    local old_rx
    local old_tx
    local dt
    local rx_rate
    local tx_rate

    interface=$(get_interface)

    [[ -z "$interface" ]] && return

    rx=$(<"/sys/class/net/$interface/statistics/rx_bytes")
    tx=$(<"/sys/class/net/$interface/statistics/tx_bytes")
    now=$(date +%s%N)

    if [[ ! -f "$CACHE" ]]; then
        printf '%s %s %s\n' "$now" "$rx" "$tx" > "$CACHE"
        return
    fi

    read -r old_time old_rx old_tx < "$CACHE"

    printf '%s %s %s\n' "$now" "$rx" "$tx" > "$CACHE"

    dt=$((now - old_time))

    ((dt <= 0)) && dt=1

    rx_rate=$(((rx - old_rx) * 1000000000 / dt))
    tx_rate=$(((tx - old_tx) * 1000000000 / dt))

    ((rx_rate < 0)) && rx_rate=0
    ((tx_rate < 0)) && tx_rate=0

    printf 'IN: %s OUT: %s\n' \
        "$(format_rate "$rx_rate")" \
        "$(format_rate "$tx_rate")"
}

case "$1" in
    interface)
        get_interface
        ;;

    ip)
        get_ip
        ;;

    rate)
        get_rate
        ;;
    *)
        echo "Usage: $0 {interface|ip|rate}"
        exit 1
        ;;
esac