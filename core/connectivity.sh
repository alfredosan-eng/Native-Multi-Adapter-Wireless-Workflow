#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Connectivity Engine
#

interface_has_carrier() {

    local interface="${1}"

    [[ "$(interface_carrier "${interface}")" == "1" ]]

}

interface_has_ip() {

    local interface="${1}"

    interface_has_ipv4 "${interface}"

}

interface_has_gateway() {

    local interface="${1}"

    [[ -n "$(route_metric "${interface}")" ]]

}

interface_metric() {

    local interface="${1}"

    route_metric "${interface}"

}

interface_connected() {

    local interface="${1}"

    interface_has_carrier "${interface}" &&
    interface_has_ip "${interface}" &&
    interface_has_gateway "${interface}"

}

preferred_interface() {

    route_preferred_device

}

preferred_gateway() {

    route_gateway

}

internet_available() {

    local iface

    iface="$(preferred_interface)"

    [[ -n "${iface}" ]] || return 1

    interface_connected "${iface}"

}

connected_interfaces() {

    local interface

    for interface in $(ip -o link show | awk -F': ' '{print $2}')
    do

        [[ "${interface}" == "lo" ]] && continue

        interface_connected "${interface}" && echo "${interface}"

    done

}
