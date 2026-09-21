#!/bin/bash

mapfile -t SOURCES < <(
    pactl list short sources |
    awk '$2 !~ /\.monitor$/ {print $2}'
)

(( ${#SOURCES[@]} <= 1 )) && exit 0

CURRENT=$(pactl get-default-source)

NEXT=0

for i in "${!SOURCES[@]}"; do
    if [[ "${SOURCES[$i]}" == "$CURRENT" ]]; then
        NEXT=$(( (i + 1) % ${#SOURCES[@]} ))
        break
    fi
done

NEW="${SOURCES[$NEXT]}"

pactl set-default-source "$NEW"