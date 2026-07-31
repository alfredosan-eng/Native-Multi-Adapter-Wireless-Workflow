#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Privilege Manager
#

require_root() {

    if [[ "${EUID}" -ne 0 ]]; then
        log_error "This operation requires root privileges."
        exit "${EXIT_FAILURE}"
    fi
}

require_user() {

    if [[ "${EUID}" -eq 0 ]]; then
        log_warning "Running as root."
    fi
}

current_uid() {
    id -u
}

current_gid() {
    id -g
}
