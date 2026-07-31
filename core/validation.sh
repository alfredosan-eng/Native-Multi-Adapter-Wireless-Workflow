#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Validation Engine
#

validate_environment() {

    check_dependencies

    return "${EXIT_SUCCESS}"
}

validate_root() {

    if ! is_root; then
        log_error "Root privileges are required."
        exit "${EXIT_FAILURE}"
    fi
}

validate_interface_exists() {

    local interface="$1"

    if ! ip link show "${interface}" >/dev/null 2>&1; then
        log_error "Interface not found: ${interface}"
        return "${EXIT_FAILURE}"
    fi

    return "${EXIT_SUCCESS}"
}

validate_monitor_support() {

    local interface="$1"

    if iw dev "${interface}" info >/dev/null 2>&1; then
        return "${EXIT_SUCCESS}"
    fi

    return "${EXIT_FAILURE}"
}

validate_framework() {

    validate_environment

    return "${EXIT_SUCCESS}"
}
