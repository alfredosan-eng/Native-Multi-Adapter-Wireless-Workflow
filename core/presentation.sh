
#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Presentation Layer
#

describe_signal() {

    local signal="${1}"
    local value

    [[ -z "${signal}" ]] && {
        echo "--"
        return
    }

    value="$(echo "${signal}" | awk '{ print $1 }')"

    if (( value >= -50 )); then
        echo "${signal} (Excellent)"
        return
    fi

    if (( value >= -60 )); then
        echo "${signal} (Very Good)"
        return
    fi

    if (( value >= -70 )); then
        echo "${signal} (Good)"
        return
    fi

    if (( value >= -80 )); then
        echo "${signal} (Fair)"
        return
    fi

    if (( value >= -90 )); then
        echo "${signal} (Weak)"
        return
    fi

    echo "${signal} (Very Weak)"

}
