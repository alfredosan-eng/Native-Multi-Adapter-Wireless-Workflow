#!/usr/bin/env bash

require_command() {

    if ! command_exists "$1"; then

        log_error "Dependency not found: $1"

        exit 1

    fi

}

require_interface() {

    if ! interface_exists "$1"; then

        log_error "Wireless interface '$1' not found."

        exit 1

    fi

}

validate_environment() {

    require_command ip
    require_command iw
    require_command ethtool

}

