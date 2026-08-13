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
    scan        Scan nearby networks [UNDER DEVELOPMENT]
    capture     Capture WPA/WPA2 handshakes [UNDER DEVELOPMENT]
    deauth      Deauthentication module [UNDER DEVELOPMENT]
    version     Show framework version
    help        Show this help

END

}
