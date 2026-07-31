#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# ANSI Color Definitions
#

readonly COLOR_RESET="\033[0m"

readonly COLOR_BLACK="\033[0;30m"
readonly COLOR_RED="\033[0;31m"
readonly COLOR_GREEN="\033[0;32m"
readonly COLOR_YELLOW="\033[0;33m"
readonly COLOR_BLUE="\033[0;34m"
readonly COLOR_MAGENTA="\033[0;35m"
readonly COLOR_CYAN="\033[0;36m"
readonly COLOR_WHITE="\033[0;37m"

readonly COLOR_BOLD="\033[1m"

color_echo() {

    local color="$1"
    shift

    printf "%b%s%b\n" "${color}" "$*" "${COLOR_RESET}"
}

success() {
    color_echo "${COLOR_GREEN}" "$*"
}

info() {
    color_echo "${COLOR_CYAN}" "$*"
}

warning() {
    color_echo "${COLOR_YELLOW}" "$*"
}

error() {
    color_echo "${COLOR_RED}" "$*"
}
