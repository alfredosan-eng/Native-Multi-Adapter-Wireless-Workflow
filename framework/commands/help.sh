#!/usr/bin/env bash

cmd_help() {

    banner

cat << END

Usage:

    wireless <command> [arguments]

Available Commands

    status                Show wireless interface status
    monitor [interface]   Enable Monitor Mode
    restore               Restore the previous wireless session
    normal                Return to the previous normal state
    version               Show framework version
    help                  Show this help

END

}
