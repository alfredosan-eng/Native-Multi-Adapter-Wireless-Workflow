#!/usr/bin/env bash

restore_preflight() {

    local monitor

    monitor="$(active_monitor_interface)"

    if [[ -z "${monitor}" ]]; then
        log_error "No active Monitor interface found."
        return 1
    fi

    echo
    echo "========== Restore Preflight =========="
    echo
    echo "Monitor Interface : ${monitor}"
    echo "Preferred IF      : $(preferred_interface)"
    echo "Internet          : $(internet_available && echo YES || echo NO)"
    echo
    echo "Preflight OK"
    echo

    return 0

}

execute_restore() {

    local interface

    load_session || return 1

    interface="${WIFI_INTERFACE:-}"

    [[ -n "${interface}" ]] || return 1

    ip link set "${interface}" down || return 1

    iw dev "${interface}" set type managed || {
        ip link set "${interface}" up
        return 1
    }

    ip link set "${interface}" up || return 1

    network_restore_management || return 1

    if [[ -n "${WIFI_PROFILE:-}" ]]; then
        nmcli connection up "${WIFI_PROFILE}" ifname "${interface}" || return 1
    fi

}

verify_restore() {

    local active_profile

    load_session || return 1

    [[ -n "${WIFI_INTERFACE:-}" ]] || return 1

    if [[ -n "$(active_monitor_interface)" ]]; then
        return 1
    fi

    if [[ "$(get_adapter_mode "${WIFI_INTERFACE}")" != "${WIFI_MODE}" ]]; then
        return 1
    fi

    case "${WIFI_NM_MANAGED}" in

        yes)
            network_is_managed "${WIFI_INTERFACE}" || return 1
            ;;

        no)
            network_is_unmanaged "${WIFI_INTERFACE}" || return 1
            ;;

        *)
            return 1
            ;;

    esac

    if [[ -n "${WIFI_PROFILE:-}" ]]; then

        active_profile="$(
            nmcli -t -f NAME,DEVICE connection show --active \
                | awk -F: -v iface="${WIFI_INTERFACE}" \
                    '$2==iface {print $1; exit}'
        )"

        [[ "${active_profile}" == "${WIFI_PROFILE}" ]] || return 1

    fi

    if ! internet_available; then
        return 1
    fi

    return 0

}

show_restore_success() {

    echo
    echo "Wireless Environment Restored"
    echo
    echo "Preferred Interface : $(preferred_interface)"
    echo "Internet Available  : YES"
    echo

    log_info "Wireless environment restored."

}

cmd_restore() {

    require_root

    run_workflow \
        "Restore Wireless Environment" \
        restore_preflight \
        execute_restore \
        verify_restore \
        show_restore_success

}
