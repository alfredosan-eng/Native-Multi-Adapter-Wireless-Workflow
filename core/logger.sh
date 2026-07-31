#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Logging Engine
#

create_log_directory() {
    mkdir -p "${NMAWW_LOG_DIR}"
}

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

log_info() {
    printf "[INFO ] %s %s\n" "$(timestamp)" "$*"
}

log_warning() {
    printf "[WARN ] %s %s\n" "$(timestamp)" "$*"
}

log_error() {
    printf "[ERROR] %s %s\n" "$(timestamp)" "$*" >&2
}

log_success() {
    printf "[ OK  ] %s %s\n" "$(timestamp)" "$*"
}

write_log() {
    local logfile="${NMAWW_LOG_DIR}/nmaww.log"

    create_log_directory

    printf "%s %s\n" "$(timestamp)" "$*" >> "${logfile}"
}
