
#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Role Engine
#

monitor_candidate() {

    local interface

    if [[ -n "${NMAWW_MONITOR_INTERFACE:-}" ]]; then

        for interface in $(discover_adapters)
        do

            [[ "${interface}" != "${NMAWW_MONITOR_INTERFACE}" ]] && continue

            echo "${interface}"
            return

        done

        return 1

    fi

    for interface in $(discover_adapters)
    do

        [[ "$(state_get "${interface}" SUPPORTS_MONITOR)" != "YES" ]] && continue

        echo "${interface}"
        return 0

    done

    return 1

}

active_monitor_interface() {

    local interface

    for interface in $(discover_adapters)
    do

        [[ "$(get_adapter_mode "${interface}")" != "MONITOR" ]] && continue

        echo "${interface}"
        return 0

    done

    return 1

}

internet_candidate() {

    local interface
    local monitor

    monitor="$(monitor_candidate)"

    for interface in $(discover_adapters)
    do

        [[ "${interface}" == "${monitor}" ]] && continue

        [[ "$(state_get "${interface}" SUPPORTS_MANAGED)" != "YES" ]] && continue

        echo "${interface}"
        return

    done

}

show_adapter_roles() {

    local interface

    for interface in $(discover_adapters)
    do

        echo
        echo "Interface : ${interface}"
        echo "Driver    : $(state_get "${interface}" DRIVER)"
        echo "Mode      : $(state_get "${interface}" MODE)"
        echo "Connected : $(state_get "${interface}" CONNECTED)"

        if [[ "${interface}" == "$(active_monitor_interface)" ]]; then
            echo "Role      : MONITOR"
        else
            echo "Role      : MANAGED"
        fi

    done

}

monitor_preflight() {

    local monitor
    local internet
    local preferred

    monitor="$(monitor_candidate)"
    preferred="$(preferred_interface)"
    internet="$(internet_available && echo YES || echo NO)"

    echo
    echo "========== Monitor Preflight =========="
    echo
    echo "Internet         : ${internet}"
    echo "Preferred IF     : ${preferred}"
    echo "Monitor Candidate: ${monitor}"
    echo

    if [[ -z "${monitor}" ]]; then
        echo "ERROR: No monitor candidate."
        return 1
    fi

    if [[ "${monitor}" == "${preferred}" ]]; then
        echo "ERROR: Monitor candidate is the preferred interface."
        return 1
    fi

    echo "Preflight OK"

}
