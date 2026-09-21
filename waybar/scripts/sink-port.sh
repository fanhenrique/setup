#!/bin/bash

mapfile -t SINKS < <(
    pactl list short sinks |
    awk '{print $2}'
)

(( ${#SINKS[@]} <= 1 )) && exit 0

CURRENT=$(pactl get-default-sink)

NEXT=0

for i in "${!SINKS[@]}"; do
    if [[ "${SINKS[$i]}" == "$CURRENT" ]]; then
        NEXT=$(( (i + 1) % ${#SINKS[@]} ))
        break
    fi
done

NEW="${SINKS[$NEXT]}"

pactl set-default-sink "$NEW"