#!/usr/bin/env bash
#
# ==============================================================================
# Native Multi-Adapter Wireless Workflow
# Professional Installer
# ==============================================================================
#
# Author : Alfredo San
# Project: NMAWW
#
# Installs:
#
#   /usr/local/bin/wireless
#   /usr/local/share/nmaww/
#
# ==============================================================================

set -euo pipefail

PROJECT_NAME="Native Multi-Adapter Wireless Workflow"
PROJECT_SHORT="NMAWW"

VERSION="0.1.0"

INSTALL_PREFIX="/usr/local"

BIN_DIR="${INSTALL_PREFIX}/bin"

SHARE_DIR="${INSTALL_PREFIX}/share/nmaww"

FRAMEWORK_DIR="${SHARE_DIR}/framework"

CORE_DIR="${SHARE_DIR}/core"

LAUNCHER="wireless"

################################################################################
# COLORS
################################################################################

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

################################################################################
# UI
################################################################################

banner() {

clear

echo -e "${CYAN}"

cat << "EOF"

███╗   ██╗███╗   ███╗ █████╗ ██╗    ██╗██╗    ██╗
████╗  ██║████╗ ████║██╔══██╗██║    ██║██║    ██║
██╔██╗ ██║██╔████╔██║███████║██║ █╗ ██║██║ █╗ ██║
██║╚██╗██║██║╚██╔╝██║██╔══██║██║███╗██║██║███╗██║
██║ ╚████║██║ ╚═╝ ██║██║  ██║╚███╔███╔╝╚███╔███╔╝
╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝  ╚══╝╚══╝

Native Multi-Adapter Wireless Workflow

Professional Installer

EOF

echo -e "${RESET}"

}

################################################################################
# LOGGING
################################################################################

info() {

echo -e "${BLUE}[*]${RESET} $1"

}

success() {

echo -e "${GREEN}[+]${RESET} $1"

}

warning() {

echo -e "${YELLOW}[!]${RESET} $1"

}

error() {

echo -e "${RED}[-]${RESET} $1"

}

################################################################################
# ROOT
################################################################################

check_root() {

if [[ "$EUID" -ne 0 ]]
then

    error "Run this installer using sudo."

    exit 1

fi

}

################################################################################
# OS DETECTION
################################################################################

detect_distribution() {

if [[ -f /etc/os-release ]]
then

    source /etc/os-release

    DISTRO="${ID}"
    DISTRO_NAME="${PRETTY_NAME}"

else

    error "Unsupported Linux distribution."

    exit 1

fi

success "Detected: ${DISTRO_NAME}"

}

################################################################################
# DEPENDENCIES
################################################################################

REQUIRED_PACKAGES=(

aircrack-ng
iw
wireless-tools
ethtool
pciutils
usbutils

)

MISSING_PACKAGES=()

check_dependencies() {

info "Checking dependencies..."

for package in "${REQUIRED_PACKAGES[@]}"
do

    if ! dpkg -s "$package" >/dev/null 2>&1
    then

        MISSING_PACKAGES+=("$package")

    fi

done

}
################################################################################
# INSTALL MISSING PACKAGES
################################################################################

install_dependencies() {

if [[ ${#MISSING_PACKAGES[@]} -eq 0 ]]
then

    success "All dependencies are already installed."

    return

fi

echo

warning "Missing packages detected:"

printf "   - %s\n" "${MISSING_PACKAGES[@]}"

echo

read -rp "Install missing packages? [Y/n]: " ANSWER

ANSWER="${ANSWER:-Y}"

case "$ANSWER" in

    Y|y)

        apt update

        apt install -y "${MISSING_PACKAGES[@]}"

        ;;

    *)

        error "Installation cancelled."

        exit 1

        ;;

esac

}

################################################################################
# CREATE DIRECTORIES
################################################################################

create_directories() {

info "Creating installation directories..."

mkdir -p "${BIN_DIR}"

mkdir -p "${FRAMEWORK_DIR}"

mkdir -p "${CORE_DIR}"

success "Directories created."

}

################################################################################
# COPY FRAMEWORK
################################################################################

copy_framework() {

info "Installing framework..."

cp -R framework/* "${FRAMEWORK_DIR}/"

cp -R core/* "${CORE_DIR}/"

success "Framework installed."

}

################################################################################
# INSTALL LAUNCHER
################################################################################

install_launcher() {

info "Installing launcher..."

install -m755 bin/wireless "${BIN_DIR}/${LAUNCHER}"

success "Launcher installed."

}

################################################################################
# VERSION FILE
################################################################################

install_version() {

if [[ -f VERSION ]]
then

    cp VERSION "${SHARE_DIR}/VERSION"

fi

}

################################################################################
# CHANGELOG
################################################################################

install_changelog() {

if [[ -f CHANGELOG.md ]]
then

    cp CHANGELOG.md "${SHARE_DIR}/CHANGELOG.md"

fi

}

################################################################################
# README
################################################################################

install_readme() {

if [[ -f README.md ]]
then

    cp README.md "${SHARE_DIR}/README.md"

fi

}

################################################################################
# PERMISSIONS
################################################################################

set_permissions() {

info "Applying permissions..."

chmod -R 755 "${CORE_DIR}"

chmod -R 755 "${FRAMEWORK_DIR}"

chmod 755 "${BIN_DIR}/${LAUNCHER}"

success "Permissions applied."

}
################################################################################
# VERIFY INSTALLATION
################################################################################

verify_installation() {

info "Verifying installation..."

[[ -x "${BIN_DIR}/${LAUNCHER}" ]] || {
    error "Launcher installation failed."
    exit 1
}

[[ -d "${CORE_DIR}" ]] || {
    error "Core installation failed."
    exit 1
}

[[ -d "${FRAMEWORK_DIR}" ]] || {
    error "Framework installation failed."
    exit 1
}

success "Installation verified."

}

################################################################################
# SUMMARY
################################################################################

installation_summary() {

echo
echo "=============================================================="
echo " Installation completed successfully"
echo "=============================================================="
echo
echo "Project : ${PROJECT_NAME}"
echo "Version : ${VERSION}"
echo
echo "Launcher : ${BIN_DIR}/${LAUNCHER}"
echo "Core     : ${CORE_DIR}"
echo "Framework: ${FRAMEWORK_DIR}"
echo
echo "Run:"
echo
echo "    wireless help"
echo
echo "=============================================================="
echo

}

################################################################################
# PRE-INSTALLATION CHECKS
################################################################################

check_repository() {

info "Checking repository structure..."

REQUIRED_ITEMS=(

bin
framework
framework/commands

)

for item in "${REQUIRED_ITEMS[@]}"
do

    if [[ ! -e "$item" ]]
    then

        error "Missing required item: $item"

        exit 1

    fi

done

success "Repository structure verified."

}

################################################################################
# BACKUP EXISTING INSTALLATION
################################################################################

backup_previous_installation() {

if [[ ! -d "${SHARE_DIR}" ]]
then
    return
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_DIR="/tmp/nmaww_backup_${TIMESTAMP}"

warning "Existing installation detected."

info "Creating backup..."

mkdir -p "${BACKUP_DIR}"

cp -R "${SHARE_DIR}" "${BACKUP_DIR}/"

success "Backup created at: ${BACKUP_DIR}"

}

################################################################################
# REMOVE OLD INSTALLATION
################################################################################

remove_previous_installation() {

info "Removing previous installation..."

rm -rf "${SHARE_DIR}" 2>/dev/null || true

rm -f "${BIN_DIR}/${LAUNCHER}" 2>/dev/null || true

success "Previous installation removed."

}

################################################################################
# MAIN
################################################################################

main() {

banner

check_root

detect_distribution

check_repository

check_dependencies

install_dependencies

backup_previous_installation

remove_previous_installation

create_directories

copy_framework

install_launcher

install_version

install_changelog

install_readme

set_permissions

verify_installation

installation_summary

}

################################################################################
# ENTRY POINT
################################################################################

main "$@"
