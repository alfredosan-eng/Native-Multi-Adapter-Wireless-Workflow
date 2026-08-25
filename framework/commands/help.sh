#!/usr/bin/env bash

cmd_help() {

    banner

cat << 'END'

Usage:

    wireless <command> [arguments]

Available Commands

    status                Show wireless interface status
    monitor [interface]   Enable Monitor Mode
    restore               Restore the previous wireless session
    version               Show framework version
    help                  Show this help


Command Reference

    wireless version

        Display the current framework version.

    wireless help

        Display this command reference.

    wireless status

        Show the current wireless environment, including
        interface state, mode, driver, channel, signal,
        connectivity and adapter roles.

    sudo wireless monitor [interface]

        Enable Monitor Mode on the specified interface.

        Example:

            sudo wireless monitor wlan0

    sudo wireless restore

        Restore the wireless environment to the previous
        session state.


END

}
