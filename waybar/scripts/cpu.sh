#!/bin/bash

STATE_FILE="/dev/shm/waybar-cpu-${UID}"

STATE="/tmp/waybar-cpu-tooltip"

if [[ "$1" == "toggle" ]]; then
    if [[ -f "$STATE" ]]; then
        rm -f "$STATE"
        pkill -f "CPU_CORES_TOOLTIP"
    else
        touch "$STATE"

        zenity --info \
            --title="CPU_CORES_TOOLTIP" \
            --text="CPU 0: 12%\nCPU 1: 8%\nCPU 2: 27%" \
            --no-wrap &
    fi

    exit 0
fi


# Read CPU counters.
mapfile -t CPU_LINES < <(grep '^cpu[0-9]' /proc/stat)

# First run: initialize state.
if [[ ! -f "$STATE_FILE" ]]; then
    {
        for line in "${CPU_LINES[@]}"; do
            read -r cpu user nice system idle iowait irq softirq steal guest guest_nice <<< "$line"
            total=$((user + nice + system + idle + iowait + irq + softirq + steal))
            idle_total=$((idle + iowait))
            printf "%s %s\n" "$total" "$idle_total"
        done
    } > "$STATE_FILE"

    printf '{"text":"CPU --%%","class":["resource"]}\n'
    exit 0
fi

# Read previous counters.
mapfile -t OLD_LINES < "$STATE_FILE"

total_sum=0
idle_sum=0
tooltip=""

{
    for i in "${!CPU_LINES[@]}"; do
        line="${CPU_LINES[$i]}"

        read -r cpu user nice system idle iowait irq softirq steal guest guest_nice <<< "$line"

        total=$((user + nice + system + idle + iowait + irq + softirq + steal))
        idle_total=$((idle + iowait))

        read -r last_total last_idle <<< "${OLD_LINES[$i]}"

        dt=$((total - last_total))
        di=$((idle_total - last_idle))

        if ((dt > 0 && di >= 0 && dt >= di)); then
            usage=$(( (dt - di) * 100 / dt ))
        else
            usage=0
        fi

        # Save current counters.
        printf "%s %s\n" "$total" "$idle_total"

        if [[ "$cpu" == "cpu0" ]]; then
            total_sum=$((total_sum + (total - last_total)))
            idle_sum=$((idle_sum + (idle_total - last_idle)))
        fi

        tooltip+="CPU ${cpu#cpu}: ${usage}%\\n"
    done
} > "${STATE_FILE}.tmp"

mv "${STATE_FILE}.tmp" "$STATE_FILE"

# Calculate total CPU usage.
read -r total_last idle_last < <(
    awk '
        {
            total += $1
            idle += $2
        }
        END {
            print total, idle
        }
    ' "$STATE_FILE"
)

# Determine total CPU usage from all CPUs.
total_current=0
idle_current=0
total_previous=0
idle_previous=0

for i in "${!CPU_LINES[@]}"; do
    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice <<< "${CPU_LINES[$i]}"

    total_current=$((total_current + user + nice + system + idle + iowait + irq + softirq + steal))
    idle_current=$((idle_current + idle + iowait))

    read -r last_total last_idle <<< "${OLD_LINES[$i]}"

    total_previous=$((total_previous + last_total))
    idle_previous=$((idle_previous + last_idle))
done

dt=$((total_current - total_previous))
di=$((idle_current - idle_previous))

if ((dt > 0 && di >= 0 && dt >= di)); then
    usage=$(( (dt - di) * 100 / dt ))
else
    usage=0
fi

# Determine state class.
if ((usage >= 90)); then
    state="p90"
elif ((usage >= 80)); then
    state="p80"
elif ((usage >= 70)); then
    state="p70"
elif ((usage >= 60)); then
    state="p60"
elif ((usage >= 50)); then
    state="p50"
elif ((usage >= 40)); then
    state="p40"
elif ((usage >= 30)); then
    state="p30"
elif ((usage >= 20)); then
    state="p20"
elif ((usage >= 10)); then
    state="p10"
else
    state=""
fi

# Escape tooltip for JSON.
tooltip=${tooltip%\\n}

if [[ -n "$state" ]]; then
    printf '{"text":"CPU %d%%","class":["resource","%s"],"tooltip":"%s"}\n' \
        "$usage" "$state" "$tooltip"
else
    printf '{"text":"CPU %d%%","class":["resource"],"tooltip":"%s"}\n' \
        "$usage" "$tooltip"
fi