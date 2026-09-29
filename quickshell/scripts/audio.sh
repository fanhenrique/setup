#!/usr/bin/env bash

set -euo pipefail

STEP=5%

get_default_sink() {
    pactl get-default-sink
}

get_sink_description() {
    local sink="$1"

    pactl list sinks |
        awk -v sink="$sink" '
            $1 == "Name:" && $2 == sink {
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
        *"Built-in"*)
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
    pactl get-sink-volume @DEFAULT_SINK@ |
        awk 'NR == 1 {print $5}'
}

get_muted() {
    pactl get-sink-mute @DEFAULT_SINK@ |
        awk '{print $2}'
}

volume_up() {
    pactl set-sink-volume @DEFAULT_SINK@ +"$STEP"
    pactl set-sink-mute @DEFAULT_SINK@ 0
}

volume_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -"$STEP"
    pactl set-sink-mute @DEFAULT_SINK@ 0
}

toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

set_default_sink() {
    local sink="$1"

    pactl set-default-sink "$sink"

    while read -r id _; do
        pactl move-sink-input "$id" "$sink"
    done < <(
        pactl list short sink-inputs
    )
}

list_sinks() {
    local current

    current=$(get_default_sink)

    pactl list short sinks |
        while read -r _ name _; do
            description=$(get_sink_description "$name")

            volume=$(
                pactl get-sink-volume "$name" |
                    awk 'NR == 1 {print $5}'
            )

            muted=$(
                pactl get-sink-mute "$name" |
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

    current=$(get_default_sink)

    description=$(get_sink_description "$current")
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
            echo "Usage: $0 set-default <sink>" >&2
            exit 1
        fi

        set_default_sink "$2"
        ;;

    list)
        list_sinks
        ;;

    status)
        status
        ;;

    *)
        echo "Usage: $0 {volume-up|volume-down|mute|set-default|list|status}" >&2
        exit 1
        ;;
esac