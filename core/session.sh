#!/usr/bin/env bash

SESSION_FILE="${NMAWW_HOME:-$(pwd)}/runtime/session.env"

save_session() {

    local interface
    local mode
    local profile
    local managed

    interface="$(monitor_candidate)"

    if [[ -z "${interface}" ]]; then

        interface="$(nmcli -t -f DEVICE,TYPE,STATE device \
            | awk -F: '$2=="wifi" && $3=="connected" {print $1; exit}')"

    fi

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

    cat > "${SESSION_FILE}" <<EOF
WIFI_INTERFACE=${interface}
WIFI_MODE=${mode}
WIFI_PROFILE=${profile}
WIFI_NM_MANAGED=${managed}
EOF

}

load_session() {

    [[ -f "${SESSION_FILE}" ]] || return 1

    # shellcheck disable=SC1090
    source "${SESSION_FILE}"

}
