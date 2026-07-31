#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Command Loader
#

load_commands() {

    local command_dir="$1"

    [[ -d "${command_dir}" ]] || {
        log_error "Command directory not found: ${command_dir}"
        return "${EXIT_FAILURE}"
    }

    local module

    for module in "${command_dir}"/*.sh
    do
        [[ -f "${module}" ]] || continue
        source "${module}"
    done

    return "${EXIT_SUCCESS}"
}
