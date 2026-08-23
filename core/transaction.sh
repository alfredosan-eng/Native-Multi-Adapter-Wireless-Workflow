#!/usr/bin/env bash

transaction_begin() {

    local interface="${1:-}"

    [[ -n "${interface}" ]] || return 1

    write_log "Transaction started."

    network_save_session "${interface}"

}

transaction_verify() {

    verify_network

}

transaction_commit() {

    write_log "Transaction committed."

}

transaction_rollback() {

    write_log "Transaction rollback."

    if ! network_restore_management; then
        write_log "Failed to restore NetworkManager ownership."
    fi

    if ! reconnect_saved_profile; then
        write_log "Failed to reconnect saved profile."
    fi

    if ! restart_network_services; then
        write_log "Failed to restart network services."
    fi

}

transaction_verify_mode() {

    local interface="${1}"

    [[ "$(get_adapter_mode "${interface}")" == "MONITOR" ]]

}

transaction_verify_connectivity() {

    internet_available

}
