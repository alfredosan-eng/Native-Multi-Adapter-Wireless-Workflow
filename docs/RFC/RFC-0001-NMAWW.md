# RFC-0001

# Native Multi-Adapter Wireless Workflow (NMAWW)

**Status:** Draft

**Version:** 1.0

**Authors:** Alfredo San

**License:** MIT

**Date:** July 2026

---

# Abstract

This Request for Comments (RFC) defines the Native Multi-Adapter Wireless Workflow (NMAWW), an orchestration framework that enables Linux systems to operate multiple wireless adapters simultaneously while preserving native networking capabilities.

Rather than replacing existing Linux networking components, NMAWW coordinates wireless interfaces with distinct operational roles, allowing packet capture, wireless auditing, reconnaissance, internet connectivity, and administrative tasks to coexist within a single workflow.

The objective is to standardize an operational model for multi-adapter wireless environments using native Linux capabilities.

---

# Table of Contents

1. Motivation
2. Problem Statement
3. Current Linux Workflow
4. Design Goals
5. Architecture
6. Workflow
7. Compatibility
8. Implementation
9. Limitations
10. Future Work
11. References

---

# 1. Motivation

Modern wireless security assessments frequently require several concurrent activities:

- Maintaining stable Internet connectivity
- Passive wireless reconnaissance
- Packet capture
- Wireless auditing
- Network administration
- Traffic analysis

Although Linux fully supports multiple wireless adapters, there is no standardized operational workflow that defines how those adapters should cooperate.

As a result, professionals often create temporary scripts, manually switch interface modes, or interrupt ongoing operations to perform unrelated tasks.

NMAWW proposes a native orchestration framework that assigns dedicated operational roles to wireless adapters while preserving compatibility with existing Linux networking components.

---

# 2. Problem Statement

Current Linux wireless workflows rely primarily on managing a single wireless adapter or manually coordinating multiple adapters without a defined operational model.

Common operational limitations include:

- Switching interfaces between managed and monitor modes.
- Interrupting Internet connectivity during wireless assessments.
- Manually assigning interface responsibilities.
- Repeating configuration tasks across different tools.
- Lack of persistent role management for wireless interfaces.

While these behaviors are technically supported by Linux, they require manual coordination that becomes increasingly complex as the number of wireless adapters and concurrent tasks grows.

The absence of a standardized orchestration layer leads to inconsistent workflows, reduced operational efficiency, and unnecessary interruptions during wireless security operations.

---

# 3. Current Linux Workflow

A typical Linux wireless assessment follows a sequential workflow centered around a single wireless adapter.

The operator usually performs tasks in the following order:

1. Disconnect the wireless interface from the network.
2. Enable monitor mode.
3. Perform packet capture or wireless reconnaissance.
4. Disable monitor mode.
5. Reconnect to the wireless network.
6. Resume Internet-dependent activities.

When multiple adapters are available, Linux provides the necessary capabilities to operate them simultaneously. However, the operating system does not define a native orchestration model that assigns persistent roles or coordinates concurrent wireless operations.

Consequently, professionals often depend on manual interface management and ad hoc scripts, resulting in workflows that vary between users and environments.

---

# 4. Design Goals

NMAWW has been designed around the following engineering principles:

- Preserve native Linux networking behavior.
- Avoid modifying kernel components or wireless drivers.
- Maintain compatibility with existing networking tools.
- Assign persistent operational roles to wireless adapters.
- Enable simultaneous managed and monitor mode operations.
- Minimize manual interface switching.
- Provide a predictable and repeatable workflow.
- Remain modular and easily extensible.
- Require minimal system configuration.
- Integrate naturally into existing Linux environments.

These principles ensure that NMAWW complements the Linux networking stack rather than replacing or abstracting it.

---

# 5. Architecture

NMAWW introduces a logical orchestration layer that coordinates multiple wireless adapters without modifying the native Linux networking stack.

Each wireless interface is assigned a persistent operational role according to its intended purpose.

Example role assignment:

| Interface | Mode | Primary Role |
|-----------|------|--------------|
| wlan0 | Managed | Internet Connectivity |
| wlan1 | Monitor | Passive Reconnaissance |
| wlan2 | Monitor | Packet Capture |
| wlan3 | Managed | Administrative Operations |

The orchestration layer is responsible for:

- Discovering available wireless adapters.
- Validating adapter capabilities.
- Assigning operational roles.
- Coordinating concurrent wireless activities.
- Preserving native Linux networking behavior.
- Preventing role conflicts between interfaces.

NMAWW does not replace NetworkManager, wireless drivers, or existing Linux networking utilities. Instead, it provides a standardized coordination model built on top of native Linux capabilities.

---

# 6. Workflow

The NMAWW operational workflow is based on assigning stable responsibilities to each wireless adapter instead of dynamically changing interface modes throughout an assessment.

A typical execution flow is:

1. Detect all available wireless adapters.
2. Validate driver compatibility and supported capabilities.
3. Assign operational roles to each interface.
4. Configure managed and monitor mode interfaces.
5. Verify interface availability.
6. Execute concurrent wireless operations.
7. Monitor interface health and operational status.
8. Restore interfaces when the workflow completes.

By maintaining dedicated roles for each adapter, NMAWW minimizes operational interruptions and enables continuous Internet connectivity alongside wireless security activities.

This workflow remains fully compatible with existing Linux networking utilities and does not require modifications to the kernel or wireless drivers.

---

# 7. Compatibility

NMAWW is designed to operate as a native orchestration layer without replacing or modifying existing Linux networking components.

The framework is intended to remain compatible with:

- Linux wireless drivers supporting managed and monitor modes.
- NetworkManager.
- systemd-networkd.
- wpa_supplicant.
- iwd.
- Aircrack-ng suite.
- Wireshark.
- tcpdump.
- Nmap.
- Bettercap.
- Kismet.
- Native Linux networking utilities.

Because NMAWW relies on standard Linux networking interfaces, it does not require kernel patches, custom drivers, or proprietary components.

Its architecture is distribution-agnostic and is intended to be portable across modern Linux distributions, including Kali Linux, Debian, Ubuntu, Fedora, Arch Linux, and others.

---

# 8. Implementation

The reference implementation of NMAWW is intentionally lightweight and relies entirely on native Linux components.

The current implementation includes:

- Automatic wireless adapter discovery.
- Role-based interface assignment.
- Managed and monitor mode coexistence.
- Driver capability validation.
- Modular command architecture.
- Bash-based implementation.
- Configuration persistence.
- Health verification modules.
- Logging and diagnostics.

NMAWW follows a modular architecture that allows additional functionality to be incorporated without modifying the core orchestration model.

Future implementations may provide alternative frontends or integrations while preserving the same operational workflow defined by this RFC.

---

# 9. Limitations

NMAWW is designed as an orchestration framework and intentionally remains within the boundaries of native Linux networking capabilities.

The current implementation does not:

- Modify kernel behavior.
- Replace existing networking services.
- Introduce proprietary drivers.
- Bypass hardware limitations.
- Alter regulatory domain restrictions.
- Replace established wireless security tools.

The effectiveness of NMAWW depends on the capabilities of the installed wireless adapters and their corresponding Linux drivers.

Hardware that does not support monitor mode, packet injection, or simultaneous multi-adapter operation will continue to be subject to those limitations.

---

# 10. Future Work

The long-term objective of NMAWW is to establish a standardized operational model for native multi-adapter wireless environments on Linux.

Future development will focus on:

- Expanding automated hardware compatibility detection.
- Improving role assignment intelligence.
- Strengthening health monitoring and diagnostics.
- Increasing automated testing coverage.
- Supporting additional Linux networking environments.
- Enhancing configuration management.
- Simplifying deployment and packaging.
- Encouraging community contributions and external integrations.

The architecture has been intentionally designed to allow incremental improvements while preserving backward compatibility with the core orchestration model.

---

# 11. References

The concepts described in this RFC are based on existing Linux networking capabilities and established open-source technologies, including:

- Linux Kernel Wireless Subsystem
- cfg80211
- mac80211
- nl80211
- NetworkManager
- systemd-networkd
- wpa_supplicant
- iwd
- Aircrack-ng Suite
- Wireshark
- tcpdump
- Nmap
- Bettercap
- Kismet

NMAWW does not replace these technologies. Instead, it defines a standardized orchestration model that coordinates their use within multi-adapter wireless environments.
