#!/usr/bin/env bash

cmd_help() {

    banner

cat << END

Usage:

    wireless <command>

Available Commands

    status      Show wireless interface status
    monitor     Enable Monitor Mode
    station     Restore Managed Mode
    restore     Restore networking
    scan        Scan nearby networks
    capture     Capture WPA/WPA2 handshakes
    deauth      Send deauthentication frames
    version     Show framework version
    help        Show this help

END

}

