#!/usr/bin/env bash

command_exists() {

    command -v "$1" >/dev/null 2>&1

}

interface_exists() {

    ip link show "$1" >/dev/null 2>&1

}

interface_state() {

    cat "/sys/class/net/$1/operstate" 2>/dev/null

}

interface_driver() {

    ethtool -i "$1" 2>/dev/null | awk '/driver:/ {print $2}'

}

interface_mode() {

    iw dev "$1" info 2>/dev/null | awk '/type/ {print $2}'

}

is_monitor_mode() {

    [[ "$(interface_mode "$1")" == "monitor" ]]

}

print_separator() {

    printf '%*s\n' "${COLUMNS:-70}" '' | tr ' ' '-'

}

