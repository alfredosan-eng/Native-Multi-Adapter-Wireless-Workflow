#!/usr/bin/env bash

set -euo pipefail

PROJECT_SHORT="NMAWW"

BIN_DIR="/usr/local/bin"
LAUNCHER="${BIN_DIR}/wireless"

SUDO_LAUNCHER="/usr/bin/wireless"

SHARE_DIR="/usr/local/share/nmaww"

check_root() {

    if [[ "$EUID" -ne 0 ]]
    then
        printf 'ERROR: Run this uninstaller using sudo.\n' >&2
        exit 1
    fi

}

remove_installation() {

    printf '\n'
    printf 'Removing NMAWW installation...\n'
    printf '\n'

    if [[ -L "${SUDO_LAUNCHER}" ]] && \
       [[ "$(readlink -f "${SUDO_LAUNCHER}")" == "${LAUNCHER}" ]]
    then
        rm -f "${SUDO_LAUNCHER}"
        printf 'Removed system launcher link.\n'
    fi

    if [[ -f "${LAUNCHER}" ]]
    then
        rm -f "${LAUNCHER}"
        printf 'Removed launcher.\n'
    fi

    if [[ -d "${SHARE_DIR}" ]]
    then
        rm -rf "${SHARE_DIR}"
        printf 'Removed framework files.\n'
    fi

}

verify_removal() {

    if [[ -e "${LAUNCHER}" ]]
    then
        printf 'ERROR: Launcher removal failed.\n' >&2
        exit 1
    fi

    if [[ -d "${SHARE_DIR}" ]]
    then
        printf 'ERROR: Framework removal failed.\n' >&2
        exit 1
    fi

    printf '\n'
    printf 'NMAWW was successfully uninstalled.\n'
    printf '\n'

}

main() {

    check_root
    remove_installation
    verify_removal

}

main "$@"
