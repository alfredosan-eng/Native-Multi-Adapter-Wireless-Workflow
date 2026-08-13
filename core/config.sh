#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Configuration Manager
#

CONFIG_FILE="${NMAWW_CONFIG_DIR}/nmaww.conf"

create_config_directory() {
    mkdir -p "${NMAWW_CONFIG_DIR}"
}

create_default_config() {

    create_config_directory

    if [[ ! -f "${CONFIG_FILE}" ]]; then

        cat > "${CONFIG_FILE}" << EOF
# NMAWW Configuration File

LOG_LEVEL=INFO

AUTO_DETECT=true

EOF

    fi
}

load_configuration() {

    create_default_config

    # shellcheck disable=SC1090
    source "${CONFIG_FILE}"
}

save_configuration() {

    cat > "${CONFIG_FILE}" << EOF


LOG_LEVEL=${LOG_LEVEL:-INFO}

AUTO_DETECT=${AUTO_DETECT:-true}
EOF

}
