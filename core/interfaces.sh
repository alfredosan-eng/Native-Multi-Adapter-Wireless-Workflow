#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Interface Manager
#

list_wireless_interfaces() {

    iw dev | awk '$1=="Interface"{print $2}'
}

count_wireless_interfaces() {

    list_wireless_interfaces | wc -l
}

interface_exists() {

    local interface="$1"

    ip link show "${interface}" >/dev/null 2>&1
}

interface_state() {

    local interface="$1"

    ip -o link show "${interface}" | awk '{print $9}'
}

interface_driver() {

    local interface="$1"

    ethtool -i "${interface}" 2>/dev/null \
        | awk -F': ' '/driver/{print $2}'
}

interface_mode() {

    local interface="$1"

    iw dev "${interface}" info 2>/dev/null \
        | awk '/type/{print $2}'
}

print_interfaces() {

    printf "%-12s %-10s %-12s %-20s\n" \
        "Interface" "State" "Mode" "Driver"

    printf "%s\n" \
        "----------------------------------------------------------------"

    local iface

    while read -r iface
    do
        printf "%-12s %-10s %-12s %-20s\n" \
            "${iface}" \
            "$(interface_state "${iface}")" \
            "$(interface_mode "${iface}")" \
            "$(interface_driver "${iface}")"
    done < <(list_wireless_interfaces)
}

interface_count() {

    count_wireless_interfaces
}

primary_interface() {

    list_wireless_interfaces | head -n1
}

secondary_interface() {

    list_wireless_interfaces | sed -n '2p'
}

monitor_interface() {

    local iface

    while read -r iface
    do
        [[ -z "${iface}" ]] && continue

        if [[ "$(interface_mode "${iface}")" == "monitor" ]]; then
            echo "${iface}"
            return
        fi

    done < <(list_wireless_interfaces)
}

managed_interfaces() {

    local iface

    while read -r iface
    do
        [[ -z "${iface}" ]] && continue

        if [[ "$(interface_mode "${iface}")" != "monitor" ]]; then
            echo "${iface}"
        fi

    done < <(list_wireless_interfaces)
}

default_monitor_interface() {

    local iface

    iface="$(monitor_interface)"

    if [[ -n "${iface}" ]]; then
        echo "${iface}"
    else
        primary_interface
    fi
}

default_managed_interface() {

    local iface

    iface="$(secondary_interface)"

    if [[ -n "${iface}" ]]; then
        echo "${iface}"
    else
        primary_interface
    fi
}
