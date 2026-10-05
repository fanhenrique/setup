#!/usr/bin/env bash

set -euo pipefail

STEP=5%

get_default_source() {
    pactl get-default-source
}

get_source_description() {
    local source="$1"

    pactl list sources |
        awk -v source="$source" '
            $1 == "Name:" && $2 == source {
                found = 1
            }

            found && $1 == "Description:" {
                $1 = ""
                sub(/^ /, "")
                print
                exit
            }
        '
}

short_name() {
    local name="$1"

    case "$name" in
        *"Built-in"*|*"Internal"*)
            echo "Interno"
            ;;

        *"USB"*)
            echo "USB"
            ;;

        *"HDMI"*|*"DisplayPort"*)
            echo "HDMI"
            ;;

        *)
            echo "$name" | awk '{print $1}'
            ;;
    esac
}

get_volume() {
    pactl get-source-volume @DEFAULT_SOURCE@ |
        awk 'NR == 1 {print $5}' |
        sed 's/.$//'
}

get_muted() {
    pactl get-source-mute @DEFAULT_SOURCE@ |
        awk '{print $2}'
}

volume_up() {
    pactl set-source-volume @DEFAULT_SOURCE@ +"$STEP"
    pactl set-source-mute @DEFAULT_SOURCE@ 0
}

volume_down() {
    pactl set-source-volume @DEFAULT_SOURCE@ -"$STEP"
    pactl set-source-mute @DEFAULT_SOURCE@ 0
}

toggle_mute() {
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

set_default_source() {
    local source="$1"

    pactl set-default-source "$source"
}

list_sources() {
    local current

    current=$(get_default_source)

    pactl list short sources |
        while read -r _ name _; do
            [[ "$name" == *.monitor ]] && continue

            description=$(get_source_description "$name")

            volume=$(
                pactl get-source-volume "$name" |
                    awk 'NR == 1 {print $5}'
            )

            muted=$(
                pactl get-source-mute "$name" |
                    awk '{print $2}'
            )

            if [[ "$name" == "$current" ]]; then
                is_default=yes
            else
                is_default=no
            fi

            printf '%s\t%s\t%s\t%s\t%s\n' \
                "$name" \
                "$description" \
                "$volume" \
                "$muted" \
                "$is_default"
        done
}

status() {
    local current
    local description
    local short
    local volume
    local muted

    current=$(get_default_source)

    description=$(get_source_description "$current")
    short=$(short_name "$description")
    volume=$(get_volume)
    muted=$(get_muted)

    printf '%s\n' "$current"
    printf '%s\n' "$short"
    printf '%s\n' "$volume"
    printf '%s\n' "$muted"
}

case "${1:-}" in
    volume-up)
        volume_up
        ;;

    volume-down)
        volume_down
        ;;

    mute)
        toggle_mute
        ;;

    set-default)
        if [[ $# -ne 2 ]]; then
            echo "Usage: $0 set-default <source>" >&2
            exit 1
        fi

        set_default_source "$2"
        ;;

    list)
        list_sources
        ;;

    status)
        status
        ;;

    *)
        echo "Usage: $0 {volume-up|volume-down|mute|set-default|list|status}" >&2
        exit 1
        ;;
esac