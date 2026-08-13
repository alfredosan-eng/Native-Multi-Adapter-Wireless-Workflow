#!/usr/bin/env bash

restore_preflight() {

    local monitor

    monitor="$(active_monitor_interface)"

    if [[ -z "${monitor}" ]]; then
        log_error "No active Monitor interface found."
        return 1
    fi

    echo
    echo "========== Restore Preflight =========="
    echo
    echo "Monitor Interface : ${monitor}"
    echo "Preferred IF      : $(preferred_interface)"
    echo "Internet          : $(internet_available && echo YES || echo NO)"
    echo
    echo "Preflight OK"
    echo

    return 0

}

execute_restore() {

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

verify_restore() {

    if [[ -n "$(active_monitor_interface)" ]]; then
        return 1
    fi

    if ! internet_available; then
        return 1
    fi

    return 0

}

show_restore_success() {

    echo
    echo "Wireless Environment Restored"
    echo
    echo "Preferred Interface : $(preferred_interface)"
    echo "Internet Available  : YES"
    echo

    log_info "Wireless environment restored."

}

cmd_restore() {

    require_root

    run_workflow \
        "Restore Wireless Environment" \
        restore_preflight \
        execute_restore \
        verify_restore \
        show_restore_success

}
