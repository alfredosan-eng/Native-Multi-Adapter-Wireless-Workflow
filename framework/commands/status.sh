#!/usr/bin/env bash

cmd_status() {

    validate_environment

    local connected_ssid=""
    local connected_bssid=""
    local rx_rate=""
    local tx_rate=""

    banner

    print_separator

    printf "%-10s %-8s %-10s %-14s %-6s %-8s %-4s %-10s\n" \
        "Interface" \
        "State" \
        "Mode" \
        "Driver" \
        "PHY" \
        "Band" \
        "Ch" \
        "Signal"

    print_separator

    while IFS='|' read -r \
        iface \
        driver \
        phy \
        mac \
        state \
        mode \
        band \
        channel \
        signal \
        ssid \
        bssid \
        rx \
        tx
    do

        [[ -z "${iface}" ]] && continue

        printf "%-10s %-8s %-10s %-14s %-6s %-8s %-4s %-10s\n" \
            "${iface}" \
            "${state}" \
            "${mode}" \
            "${driver}" \
            "${phy}" \
            "${band:---}" \
            "${channel:---}" \
            "$(describe_signal "${signal}")"

        if [[ -n "${ssid}" ]]; then
            connected_ssid="${ssid}"
            connected_bssid="${bssid}"
            rx_rate="${rx}"
            tx_rate="${tx}"
        fi

    done < <(inventory_hardware)

    print_separator

echo

echo "Detected Interfaces : $(discover_adapters | wc -l)"

echo "Preferred Interface : $(preferred_interface)"

echo "Internet Available  : $(internet_available && echo YES || echo NO)"

echo "Gateway             : $(preferred_gateway)"

echo

echo "Wireless Roles"

show_adapter_roles
}
