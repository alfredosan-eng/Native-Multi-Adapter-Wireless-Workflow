# Native Multi-Adapter Wireless Workflow

<p align="center">

![Linux](https://img.shields.io/badge/Linux-Compatible-blue?style=for-the-badge&logo=linux)
![Bash](https://img.shields.io/badge/Bash-5.x-green?style=for-the-badge&logo=gnubash)
![Aircrack-ng](https://img.shields.io/badge/Aircrack--ng-Supported-red?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active%20Development-success?style=for-the-badge)

</p>

---

# Native Linux Wireless Auditing Framework

**Native Multi-Adapter Wireless Workflow (NMAWW)** is an open-source project that proposes a standardized methodology for performing wireless security assessments on Linux systems equipped with multiple Wi-Fi adapters.

Unlike traditional approaches that continuously switch a single adapter between **Managed Mode** and **Monitor Mode**, this framework assigns a dedicated operational role to each wireless interface, creating a more stable, reproducible, and professional workflow for wireless penetration testing.

The project includes:

- A native Bash CLI
- A reference implementation
- Engineering documentation
- Installation utilities
- Administrator documentation
- Architecture documentation
- Engineering Design Proposals (EDPs)

The long-term objective is not simply to distribute a script, but to establish an extensible framework for Linux wireless operations.

---

# Why this project exists

Most Linux wireless auditing tutorials assume that a single Wi-Fi adapter will be repeatedly switched between different operating modes.

Although functional, this workflow introduces several operational disadvantages:

- Internet connectivity is interrupted.
- NetworkManager continuously reconnects interfaces.
- Long captures become unstable.
- Multiple tools compete for the same interface.
- Switching modes repeatedly increases complexity.

Professional environments often use multiple adapters simultaneously.

This project formalizes that operational model and provides a repeatable workflow that minimizes interruptions while improving usability and consistency.

---

# Design Philosophy

The project follows five engineering principles.

## 1. Native Linux

No graphical interface.

No proprietary software.

The framework relies entirely on native Linux utilities and standard networking components.

Examples include:

- iproute2
- iw
- ethtool
- NetworkManager
- Aircrack-ng Suite

---

## 2. One Adapter, One Responsibility

Each wireless adapter performs a single role.

Example:

| Interface | Role |
|-----------|------|
| wlan0 | Monitor Mode |
| wlan1 | Internet Connectivity |

This separation significantly reduces operational conflicts.

---

## 3. Minimal Dependencies

The project intentionally avoids unnecessary frameworks.

Everything is implemented using Bash and native Linux tools.

This allows the framework to remain:

- Lightweight
- Portable
- Transparent
- Easy to audit
- Easy to modify

---

## 4. Documentation First

Documentation is considered part of the software.

Every feature should include:

- Administrator documentation
- Architecture documentation
- Engineering rationale
- Operational examples

The repository is intended to serve as both a software project and a learning resource.

---

## 5. Modularity

Every command is designed to remain independent.

Future releases will allow commands to become individual modules without requiring changes to the core architecture.

---

# Key Features

✔ Native Bash CLI

✔ Multi-adapter wireless workflow

✔ Monitor Mode management

✔ Managed Mode restoration

✔ Wireless scanning

✔ WPA/WPA2 handshake capture

✔ Deauthentication support

✔ Interface diagnostics

✔ Modular architecture

✔ Open-source reference implementation

✔ Administrator Guide

✔ Engineering Design Proposal

✔ Architecture documentation

✔ Easy installation

✔ Linux-first design

---

# Repository Structure

```text
Native-Multi-Adapter-Wireless-Workflow/
│
├── README.md
├── LICENSE
├── CHANGELOG.md
├── ROADMAP.md
├── VERSION
├── install.sh
│
├── reference-implementation/
│   └── wireless
│
├── docs/
│   ├── Administrator_Guide.md
│   ├── Administrator_Guide.pdf
│   ├── ARCHITECTURE.md
│   ├── EDP-0001.md
│   └── DESIGN_DECISIONS.md
│
├── tests/
│
├── assets/
│
└── .github/
```

---

# Requirements

The framework targets modern Linux distributions.

## Operating System

- Kali Linux
- Ubuntu
- Debian
- Linux Mint
- Parrot OS
- Arch Linux (community supported)

---

## Required Packages

- bash
- iproute2
- iw
- ethtool
- NetworkManager
- aircrack-ng

---

## Hardware

Recommended:

- Two Wi-Fi adapters

Minimum:

- One monitor-mode compatible adapter

---

## Permissions

Most commands require root privileges because they manipulate wireless interfaces.

---

# Installation

Clone the repository.

```bash
git clone https://github.com/YOUR_USERNAME/Native-Multi-Adapter-Wireless-Workflow.git
```

Enter the project directory.

```bash
cd Native-Multi-Adapter-Wireless-Workflow
```

Grant execution permissions.

```bash
chmod +x install.sh
```

Run the installer.

```bash
./install.sh
```

The installer will:

- Verify required dependencies
- Install the `wireless` command
- Configure executable permissions
- Validate the installation
- Display post-installation instructions

No manual modifications to `.bashrc` or `.zshrc` are required.

---

# Verify Installation

```bash
wireless help
```

Expected output:

```text
Native Multi-Adapter Wireless Workflow

Available Commands

Usage:

    wireless <command>

    status      Show wireless interface status
    monitor     Switch wlan0 to Monitor Mode
    station     Restore wlan0 to Managed Mode
    restore     Restart networking services
    scan        Scan nearby wireless networks
    capture     Capture WPA/WPA2 handshake
    deauth      Send deauthentication frames
    version     Display application version
    help        Display this help

```

---
