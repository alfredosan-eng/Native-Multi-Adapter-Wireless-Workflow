#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Version Information
#

readonly NMAWW_NAME="Native Multi-Adapter Wireless Workflow"
readonly NMAWW_SHORT_NAME="NMAWW"
readonly NMAWW_VERSION="0.1.0-alpha"
readonly NMAWW_AUTHOR="Alfredo San"
readonly NMAWW_LICENSE="MIT"

get_framework_version() {
    echo "${NMAWW_VERSION}"
}

print_version() {
    cat << EOF
${NMAWW_NAME}
Version : ${NMAWW_VERSION}
Author  : ${NMAWW_AUTHOR}
License : ${NMAWW_LICENSE}
EOF
}
