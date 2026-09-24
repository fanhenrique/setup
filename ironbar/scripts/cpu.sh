#!/bin/bash

SIGNAL=4
CPU_STATE_FILE="/dev/shm/ironbar-cpu-${UID}"

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_total=$((idle + iowait))

usage="0.0"

if [[ -f "$CPU_STATE_FILE" ]]; then
    read -r last_total last_idle < "$CPU_STATE_FILE"

    dt=$((total - last_total))
    di=$((idle_total - last_idle))

    if ((dt > 0 && di >= 0 && dt >= di)); then
        usage=$(awk -v dt="$dt" -v di="$di" \
            'BEGIN { printf "%.1f", ((dt - di) / dt) * 100 }')
    fi
fi

printf "%s %s\n" "$total" "$idle_total" > "$CPU_STATE_FILE"

printf 'CPU %s%%\n' "$usage"