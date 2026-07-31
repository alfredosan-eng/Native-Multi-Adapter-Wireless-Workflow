#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Utility Functions
#

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_command() {

    local cmd="$1"

    if ! command_exists "${cmd}"; then
        log_error "Required command not found: ${cmd}"
        exit "${EXIT_FAILURE}"
    fi
}

check_dependencies() {

    local cmd

    for cmd in "${REQUIRED_COMMANDS[@]}"
    do
        require_command "${cmd}"
    done
}

is_root() {
    [[ "${EUID}" -eq 0 ]]
}

current_user() {
    id -un
}

framework_home() {
    printf "%s\n" "${NMAWW_HOME}"
}
