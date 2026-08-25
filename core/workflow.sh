#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Workflow Engine
#

run_workflow() {

    local workflow_name="${1}"
    local preflight="${2}"
    local execute="${3}"
    local verify="${4}"
    local success="${5}"
    local transaction_interface="${6:-}"

    if [[ -n "${transaction_interface}" ]]; then

        transaction_begin "${transaction_interface}" || return "${EXIT_FAILURE}"

    fi

    if ! "${preflight}"; then
        log_error "${workflow_name}: Preflight failed."
        return "${EXIT_FAILURE}"
    fi

    if ! "${execute}"; then
        workflow_fail "${workflow_name}" "Execution failed."
        return "${EXIT_FAILURE}"
    fi

    if ! "${verify}"; then
        workflow_fail "${workflow_name}" "Verification failed."
        return "${EXIT_FAILURE}"
    fi

    transaction_commit

    if ! "${success}"; then
        log_warning "${workflow_name}: Success handler returned an error."
    fi

    return "${EXIT_SUCCESS}"

}

workflow_fail() {

    local workflow="${1}"
    local message="${2}"

    log_error "${workflow}: ${message}"

    transaction_rollback

    return "${EXIT_FAILURE}"

}
