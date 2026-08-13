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
source "${BOOTSTRAP_DIR}/hardware.sh"
source "${BOOTSTRAP_DIR}/parsers.sh"
source "${BOOTSTRAP_DIR}/capabilities.sh"
source "${BOOTSTRAP_DIR}/connectivity.sh"
source "${BOOTSTRAP_DIR}/state.sh"
source "${BOOTSTRAP_DIR}/roles.sh"
source "${BOOTSTRAP_DIR}/presentation.sh"
source "${BOOTSTRAP_DIR}/session.sh"
source "${BOOTSTRAP_DIR}/network.sh"
source "${BOOTSTRAP_DIR}/transaction.sh"
source "${BOOTSTRAP_DIR}/workflow.sh"
source "${BOOTSTRAP_DIR}/commands/loader.sh"

bootstrap_framework() {

    validate_framework

    load_configuration

    write_log "Framework initialized."

    return "${EXIT_SUCCESS}"
}
