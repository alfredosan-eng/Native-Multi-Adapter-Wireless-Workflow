#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Hardware Discovery Service
#

discover_adapters() {

    find /sys/class/net \
        -maxdepth 1 \
        -type l \
        | xargs -n1 basename \
        | grep '^wl' \
        | sort

}

get_adapter_driver() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    basename "$(readlink "/sys/class/net/${interface}/device/driver")"

}

get_adapter_phy() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    basename "$(readlink "/sys/class/net/${interface}/phy80211")"

}

get_adapter_mac() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    cat "/sys/class/net/${interface}/address"

}

get_adapter_state() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    cat "/sys/class/net/${interface}/operstate" \
        | tr '[:lower:]' '[:upper:]'

}

get_adapter_operstate() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    cat "/sys/class/net/${interface}/operstate" 2>/dev/null \
        | tr '[:lower:]' '[:upper:]'

}

get_adapter_mode() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    iw dev "${interface}" info 2>/dev/null \
        | awk '/type/ { print toupper($2) }'

}

get_link_information() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    iw dev "${interface}" link 2>/dev/null

}

get_adapter_frequency() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    get_link_information "${interface}" \
        | awk '/freq:/ { print int($2) }'

}

get_adapter_signal() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    get_link_information "${interface}" \
        | awk '/signal:/ { print $2 " " $3 }'

}

get_adapter_rx_bitrate() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    get_link_information "${interface}" \
        | awk -F': ' '/rx bitrate:/ { print $2 }'

}

get_adapter_tx_bitrate() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    get_link_information "${interface}" \
        | awk -F': ' '/tx bitrate:/ { print $2 }'

}

get_adapter_ssid() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    get_link_information "${interface}" \
        | awk -F': ' '/SSID:/ { print $2 }'

}

get_adapter_bssid() {

    local interface="${1}"

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    get_link_information "${interface}" \
        | awk '/Connected to/ { print $3 }'

}

get_adapter_channel() {

    local interface="${1}"
    local frequency

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    frequency="$(get_adapter_frequency "${interface}")"

    [[ -z "${frequency}" ]] && return 0

    #
    # 2.4 GHz
    #

    if (( frequency >= 2412 && frequency <= 2472 )); then
        echo $(( (frequency - 2407) / 5 ))
        return
    fi

    #
    # Channel 14
    #

    if (( frequency == 2484 )); then
        echo "14"
        return
    fi

    #
    # 5 GHz
    #

    if (( frequency >= 5000 && frequency <= 5900 )); then
        echo $(( (frequency - 5000) / 5 ))
        return
    fi

}

get_adapter_band() {

    local interface="${1}"
    local frequency

    if [[ -z "${interface}" ]]; then
        return 1
    fi

    frequency="$(get_adapter_frequency "${interface}")"

    [[ -z "${frequency}" ]] && return 0

    if (( frequency >= 2412 && frequency <= 2484 )); then
        echo "2.4 GHz"
        return
    fi

    if (( frequency >= 5000 && frequency < 5955 )); then
        echo "5 GHz"
        return
    fi

    if (( frequency >= 5955 && frequency <= 7115 )); then
        echo "6 GHz"
        return
    fi

    echo "UNKNOWN"

}

inventory_hardware() {

    local interface

    for interface in $(discover_adapters)
    do

        printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n' \
            "${interface}" \
            "$(state_get "${interface}" DRIVER)" \
            "$(state_get "${interface}" PHY)" \
            "$(get_adapter_mac "${interface}")" \
            "$(state_get "${interface}" STATE)" \
            "$(state_get "${interface}" MODE)" \
            "$(get_adapter_band "${interface}")" \
            "$(get_adapter_channel "${interface}")" \
            "$(get_adapter_signal "${interface}")" \
            "$(get_adapter_ssid "${interface}")" \
            "$(get_adapter_bssid "${interface}")" \
            "$(get_adapter_rx_bitrate "${interface}")" \
            "$(get_adapter_tx_bitrate "${interface}")"

    done

}
