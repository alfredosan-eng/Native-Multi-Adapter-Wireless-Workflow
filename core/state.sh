#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# State Engine
#

framework_state() {

    local interface

    for interface in $(discover_adapters)
    do

        echo "INTERFACE=${interface}"

        echo "DRIVER=$(get_adapter_driver "${interface}")"

        echo "PHY=$(get_adapter_phy "${interface}")"

        echo "MODE=$(get_adapter_mode "${interface}")"

        echo "STATE=$(get_adapter_operstate "${interface}")"

        echo "CONNECTED=$(interface_connected "${interface}" && echo YES || echo NO)"

        echo "METRIC=$(interface_metric "${interface}")"

        echo "SUPPORTS_MONITOR=$(adapter_supports_monitor "${interface}" && echo YES || echo NO)"

        echo "SUPPORTS_MANAGED=$(adapter_supports_managed "${interface}" && echo YES || echo NO)"

        echo

    done

    echo "PREFERRED=$(preferred_interface)"

}

state_get() {

    local interface="${1}"
    local field="${2}"

    framework_state | awk -F= \
        -v iface="${interface}" \
        -v key="${field}" '

        $1=="INTERFACE"{
            current=$2
        }

        current==iface && $1==key{
            print $2
            exit
        }

    '
}

state_list() {

    framework_state

}

state_exists() {

    local interface="${1}"

    framework_state | grep -q "^INTERFACE=${interface}$"

}
