#!/usr/bin/env bash

list_wireless_interfaces() {

    iw dev | awk '$1=="Interface"{print $2}'

}

interface_count() {

    list_wireless_interfaces | wc -l

}

primary_interface() {

    list_wireless_interfaces | head -n1

}

secondary_interface() {

    list_wireless_interfaces | sed -n '2p'

}

interface_mode() {

    iw dev "$1" info | awk '/type/ {print $2}'

}

monitor_interface() {

    while read -r iface
    do

        [[ -z "$iface" ]] && continue

        if [[ "$(interface_mode "$iface")" == "monitor" ]]; then

            echo "$iface"
            return

        fi

    done < <(list_wireless_interfaces)

}

managed_interfaces() {

    while read -r iface
    do

        [[ -z "$iface" ]] && continue

        if [[ "$(interface_mode "$iface")" != "monitor" ]]; then

            echo "$iface"

        fi

    done < <(list_wireless_interfaces)

}

default_monitor_interface() {

    if [[ -n "$(monitor_interface)" ]]; then

        monitor_interface

        return

    fi

    primary_interface

}

default_managed_interface() {

    if [[ -n "$(secondary_interface)" ]]; then

        secondary_interface

        return

    fi

    primary_interface

}

