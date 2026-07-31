#!/usr/bin/env bash

#
# Native Multi-Adapter Wireless Workflow
# Common Functions
#

banner() {

cat << "EOF"

===========================================================
 Native Multi-Adapter Wireless Workflow
===========================================================

EOF

}

print_separator() {

    printf '%*s\n' "${COLUMNS:-70}" '' | tr ' ' '-'

}
