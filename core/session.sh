#!/usr/bin/env bash

SESSION_FILE="${NMAWW_HOME:-$(pwd)}/runtime/session.env"

save_session() {

    local interface="${1:-}"
    local mode
    local profile
    local managed

    [[ -n "${interface}" ]] || return 1

    mode=""

    if [[ -n "${interface}" ]]; then
        mode="$(get_adapter_mode "${interface}")"
    fi

    profile=""

    if [[ -n "${interface}" ]]; then

        profile="$(nmcli -t -f NAME,DEVICE connection show --active \
            | awk -F: -v iface="${interface}" '$2==iface {print $1; exit}')"

    fi

    managed="no"

    if [[ -n "${interface}" ]]; then

        if network_is_managed "${interface}"; then
            managed="yes"
        fi

    fi

    mkdir -p "$(dirname "${SESSION_FILE}")"

    {
        printf 'WIFI_INTERFACE=%q\n' "${interface}"
        printf 'WIFI_MODE=%q\n' "${mode}"
        printf 'WIFI_PROFILE=%q\n' "${profile}"
        printf 'WIFI_NM_MANAGED=%q\n' "${managed}"
    } > "${SESSION_FILE}"

}

load_session() {

    [[ -f "${SESSION_FILE}" ]] || return 1

    # shellcheck disable=SC1090
    source "${SESSION_FILE}"

}
