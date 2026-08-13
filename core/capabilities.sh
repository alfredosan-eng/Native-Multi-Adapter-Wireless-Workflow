#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Capability Engine
#

get_phy_modes() {

    local interface="${1}"
    local phy

    [[ -z "${interface}" ]] && return 1

    phy="$(get_adapter_phy "${interface}")"

    [[ -z "${phy}" ]] && return 1

    iw "${phy}" info 2>/dev/null | awk '

    /Supported interface modes:/ {

        capture=1

        next

    }

    capture {

        if ($0 !~ /^[[:space:]]+\*/) {

            exit

        }

        line=$0

        sub(/^[[:space:]]+\*[[:space:]]*/, "", line)

        print line

    }

    '

}

adapter_supports_monitor() {

    local interface="${1}"

    get_phy_modes "${interface}" \
        | grep -qi "^monitor$"

}

adapter_supports_managed() {

    local interface="${1}"

    get_phy_modes "${interface}" \
        | grep -qi "^managed$"

}

adapter_supports_ap() {

    local interface="${1}"

    get_phy_modes "${interface}" \
        | grep -qi "^AP$"

}

adapter_supports_p2p() {

    local interface="${1}"

    get_phy_modes "${interface}" \
        | grep -qi "^P2P"

}

adapter_capabilities() {

    local interface="${1}"

    [[ -z "${interface}" ]] && return 1

    printf "Interface : %s\n" "${interface}"
    printf "Driver    : %s\n" "$(get_adapter_driver "${interface}")"
    printf "PHY       : %s\n" "$(get_adapter_phy "${interface}")"

    echo

    echo "Supported Modes"

    get_phy_modes "${interface}"

}
