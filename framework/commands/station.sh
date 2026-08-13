#!/usr/bin/env bash

station_preflight() {

    local monitor

    monitor="$(active_monitor_interface)"

    if [[ -z "${monitor}" ]]; then
        log_error "No interface is currently in Monitor Mode."
        return 1
    fi

    if ! internet_available; then
        log_error "Internet connectivity is unavailable."
        return 1
    fi

    echo
    echo "========== Station Preflight =========="
    echo
    echo "Internet          : YES"
    echo "Preferred IF      : $(preferred_interface)"
    echo "Monitor Interface : ${monitor}"
    echo
    echo "Preflight OK"
    echo

    return 0

}

execute_station_mode() {

    local interface

    interface="$(active_monitor_interface)"

    [[ -n "${interface}" ]] || return 1

    ip link set "${interface}" down || return 1

	iw dev "${interface}" set type managed || {
    ip link set "${interface}" up
    return 1
}

	ip link set "${interface}" up || return 1

	network_set_managed "${interface}" || return 1

}

verify_station_transaction() {

    if [[ -n "$(active_monitor_interface)" ]]; then
        return 1
    fi

    if ! internet_available; then
        return 1
    fi

    return 0

}

show_station_success() {

    echo
    echo "Managed Mode Restored"
    echo
    echo "Internet Interface : $(preferred_interface)"
    echo

    log_info "Managed wireless environment restored."

}

cmd_station() {

    require_root

    run_workflow \
        "Station Mode" \
        station_preflight \
        execute_station_mode \
        verify_station_transaction \
        show_station_success

}
