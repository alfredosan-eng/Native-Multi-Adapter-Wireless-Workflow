#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Parser Engine
#

route_default() {

    ip route | grep "^default"

}

route_gateway() {

    route_default \
        | awk '{print $3}' \
        | head -1

}

route_device() {

    route_default \
        | awk '{

            for(i=1;i<=NF;i++)

                if($i=="dev")

                    print $(i+1)

        }'

}

route_metric() {

    local interface="${1}"

    route_default \
    | awk -v iface="${interface}" '

        $0 ~ "dev "iface {

            metric="0"

            for(i=1;i<=NF;i++){

                if($i=="metric"){

                    metric=$(i+1)

                }

            }

            print metric

        }

    '

}

route_preferred_device() {

    route_default \
    | awk '

        {

            dev=""

            metric=0

            for(i=1;i<=NF;i++){

                if($i=="dev")

                    dev=$(i+1)

                if($i=="metric")

                    metric=$(i+1)

            }

            print metric,dev

        }

    ' \
    | sort -n \
    | head -1 \
    | awk '{print $2}'

}

interface_has_ipv4() {

    local interface="${1}"

    ip -4 addr show "${interface}" \
        | grep -q "inet "

}

interface_carrier() {

    local interface="${1}"

    cat "/sys/class/net/${interface}/carrier" 2>/dev/null

}
