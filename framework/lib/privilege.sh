#!/usr/bin/env bash

require_root() {

    if [[ $EUID -eq 0 ]]; then
        return
    fi

    log_info "Requesting administrator privileges..."

    exec sudo "$0" "$@"

}

