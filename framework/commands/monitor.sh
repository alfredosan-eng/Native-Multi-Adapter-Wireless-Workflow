#!/usr/bin/env bash

execute_monitor_mode() {

    local interface

    interface="$(monitor_candidate)"

    [[ -n "${interface}" ]] || return 1

    network_set_unmanaged "${interface}" || return 1

    ip link set "${interface}" down || return 1

    iw dev "${interface}" set type monitor || {
        ip link set "${interface}" up
        network_set_managed "${interface}"
        return 1
    }

    ip link set "${interface}" up || return 1

}

show_monitor_success() {

    local interface

    interface="$(active_monitor_interface)"

    [[ -n "${interface}" ]] || return 1

    echo
    echo "Monitor Mode Enabled"
    echo
    echo "Monitor Interface : ${interface}"
    echo

}

verify_monitor_transaction() {

    local interface

    interface="$(active_monitor_interface)"

    [[ -n "${interface}" ]] || return 1

    if ! transaction_verify_mode "${interface}"; then
        return 1
    fi

    if ! transaction_verify_connectivity; then
        return 1
    fi

    return 0

}

cmd_monitor() {

    require_root

    run_workflow \
        "Monitor Mode" \
        monitor_preflight \
        execute_monitor_mode \
        verify_monitor_transaction \
        show_monitor_success

}
