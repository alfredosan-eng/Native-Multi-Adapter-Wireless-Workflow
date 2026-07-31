#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Bootstrap
#

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Core Components

source "${BOOTSTRAP_DIR}/constants.sh"
source "${BOOTSTRAP_DIR}/colors.sh"
source "${BOOTSTRAP_DIR}/common.sh"
source "${BOOTSTRAP_DIR}/version.sh"
source "${BOOTSTRAP_DIR}/logger.sh"
source "${BOOTSTRAP_DIR}/config.sh"
source "${BOOTSTRAP_DIR}/utils.sh"
source "${BOOTSTRAP_DIR}/validation.sh"
source "${BOOTSTRAP_DIR}/privilege.sh"
source "${BOOTSTRAP_DIR}/interfaces.sh"
source "${BOOTSTRAP_DIR}/commands/loader.sh"

bootstrap_framework() {

    validate_framework

    load_configuration

    write_log "Framework initialized."

    return "${EXIT_SUCCESS}"
}
