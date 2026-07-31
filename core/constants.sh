#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Global Constants
#

readonly NMAWW_HOME="/usr/local/share/nmaww"
readonly NMAWW_CONFIG_DIR="${HOME}/.config/nmaww"
readonly NMAWW_LOG_DIR="${HOME}/.local/share/nmaww/logs"
readonly NMAWW_CACHE_DIR="${HOME}/.cache/nmaww"

readonly NMAWW_DEFAULT_MANAGED_ROLE="managed"
readonly NMAWW_DEFAULT_MONITOR_ROLE="monitor"

readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1

readonly REQUIRED_COMMANDS=(
    ip
    iw
    awk
    grep
    sed
    systemctl
)
