#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Network Service
#

NETWORK_TIMEOUT=10

network_save_session() {

    save_session

}

network_set_unmanaged() {

    local interface="${1}"

    [[ -n "${interface}" ]] || return 1

    nmcli device set "${interface}" managed no

}

network_set_managed() {

    local interface="${1}"

    [[ -n "${interface}" ]] || return 1

    nmcli device set "${interface}" managed yes

}

network_is_managed() {

    local interface="${1}"

    [[ -n "${interface}" ]] || return 1

    nmcli -g GENERAL.NM-MANAGED device show "${interface}" \
        | grep -qi "^yes$"

}

network_is_unmanaged() {

    local interface="${1}"

    [[ -n "${interface}" ]] || return 1

    nmcli -g GENERAL.NM-MANAGED device show "${interface}" \
        | grep -qi "^no$"

}

wait_for_network_manager() {

    local timeout="${NETWORK_TIMEOUT}"
    local counter=0

    while (( counter < timeout ))
    do

        if nmcli -t -f RUNNING general status 2>/dev/null \
            | grep -qi "^running"; then
            return 0
        fi

        sleep 1

        ((counter++))

    done

    return 1

}

restart_network_services() {

    if [[ "${EUID}" -ne 0 ]]; then

        write_log "Skipping network service restart (root privileges required)."

        return 0

    fi

    systemctl restart wpa_supplicant || return 1

    systemctl restart NetworkManager || return 1

    wait_for_network_manager

}

network_restore_management() {

    load_session || return 1

    [[ -n "${WIFI_INTERFACE}" ]] || return 1

    case "${WIFI_NM_MANAGED}" in

        yes)
            network_set_managed "${WIFI_INTERFACE}"
            ;;

        no)
            network_set_unmanaged "${WIFI_INTERFACE}"
            ;;

        *)
            write_log "Unknown NetworkManager ownership state."
            return 1
            ;;

    esac

}

reconnect_saved_profile() {

    load_session || return 1

    [[ -z "${WIFI_PROFILE}" ]] && return 1

    nmcli connection up "${WIFI_PROFILE}"

}

verify_network() {

    nmcli -t -f DEVICE,STATE device \
        | grep -q ":connected"

}
