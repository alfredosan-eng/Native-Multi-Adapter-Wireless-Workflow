#!/usr/bin/env bash

cmd_status() {

    validate_environment

    banner

    print_separator

    printf "%-12s %-10s %-12s %-18s\n" \
        "Interface" \
        "State" \
        "Mode" \
        "Driver"

    print_separator

    while read -r iface
    do

        [[ -z "$iface" ]] && continue

        printf "%-12s %-10s %-12s %-18s\n" \
            "$iface" \
            "$(interface_state "$iface")" \
            "$(interface_mode "$iface")" \
            "$(interface_driver "$iface")"

    done < <(list_wireless_interfaces)

    print_separator

    echo

    echo "Detected Interfaces : $(interface_count)"
    echo "Primary Interface   : $(primary_interface)"

    if [[ -n "$(secondary_interface)" ]]; then
        echo "Secondary Interface : $(secondary_interface)"
    fi

    if [[ -n "$(monitor_interface)" ]]; then
        echo "Monitor Interface   : $(monitor_interface)"
    fi

}

