#!/usr/bin/env bash

banner() {

    echo
    echo -e "${CYAN}${BOLD}${APP_NAME}${RESET}"
    echo -e "Version ${VERSION}"
    echo

}

log_info() {

    echo -e "${INFO}[INFO]${RESET} $*"

}

log_success() {

    echo -e "${SUCCESS}[ OK ]${RESET} $*"

}

log_warning() {

    echo -e "${WARNING}[WARN]${RESET} $*"

}

log_error() {

    echo -e "${ERROR}[FAIL]${RESET} $*" >&2

}

