# NMAWW Architecture

## Native Multi-Adapter Wireless Workflow

**Version:** 1.0

**Status:** Draft

**Author:** Alfredo San

**Date:** July 2026

---

# Executive Overview

The Native Multi-Adapter Wireless Workflow (NMAWW) architecture defines a modular orchestration framework designed to coordinate multiple wireless adapters using native Linux capabilities.

The framework has been intentionally designed to remain lightweight, modular, extensible, and distribution-independent while preserving full compatibility with the Linux networking stack.

Rather than replacing existing networking components, NMAWW introduces an orchestration layer that coordinates wireless interfaces according to predefined operational roles.

This document describes the architectural principles, execution flow, repository organization, and long-term design philosophy of the framework.

---

# Table of Contents

1. Design Philosophy
2. Architectural Principles
3. High-Level Architecture
4. Repository Structure
5. Core Layer
6. Framework Layer
7. Command Execution Flow
8. Configuration System
9. Logging System
10. Validation Layer
11. References

---

# 1. Design Philosophy

NMAWW has been designed around a simple engineering principle:

> **Linux already provides the necessary wireless capabilities. What is missing is a standardized orchestration model.**

Instead of introducing new networking technologies, proprietary drivers, or kernel modifications, the framework coordinates existing Linux components into a predictable and repeatable operational workflow.

The project prioritizes simplicity, modularity, maintainability, and interoperability with existing Linux networking utilities.

The architectural philosophy is based on the following principles:

- Preserve native Linux behavior.
- Build on top of existing networking components.
- Avoid kernel modifications.
- Keep the framework lightweight.
- Promote modular development.
- Enable incremental evolution.
- Maintain distribution independence.
- Encourage community contributions.

Every architectural decision within NMAWW follows these principles.

---

# 2. Architectural Principles

The architecture of NMAWW follows a layered design that separates framework responsibilities into independent and reusable components.

Each layer has a clearly defined purpose and communicates with adjacent layers through well-defined interfaces, minimizing coupling and simplifying future maintenance.

The primary architectural principles are:

- Separation of concerns.
- Single responsibility per component.
- Modular implementation.
- Reusable core services.
- Predictable execution flow.
- Explicit validation before execution.
- Configuration-driven behavior.
- Native Linux integration.
- Distribution-independent design.

The framework intentionally avoids embedding operational logic directly into command modules.

Instead, commands rely on shared services provided by the Core layer, ensuring consistent behavior across the entire framework.

This design reduces code duplication, simplifies testing, and allows future components to reuse the same infrastructure without modification.

---

# 3. High-Level Architecture

NMAWW is organized into multiple logical layers, each responsible for a specific aspect of framework execution.

```
+------------------------------------------------------+
|                  User Commands                       |
|  (status, monitor, restore, etc.)                    |
+---------------------------+--------------------------+
                            |
                            v
+------------------------------------------------------+
|                 Command Loader                       |
|          Dynamic command discovery and loading       |
+---------------------------+--------------------------+
                            |
                            v
+------------------------------------------------------+
|                     Core Layer                       |
|------------------------------------------------------|
| Bootstrap | Configuration | Validation | Interfaces  |
| Logging   | Utilities     | Version    | Privileges  |
+---------------------------+--------------------------+
                            |
                            v
+------------------------------------------------------+
|              Native Linux Networking                 |
|------------------------------------------------------|
| ip | iw | ethtool | NetworkManager | nl80211 | etc. |
+---------------------------+--------------------------+
                            |
                            v
+------------------------------------------------------+
|               Wireless Hardware                      |
|------------------------------------------------------|
| USB Adapters | PCIe Adapters | Internal Wi-Fi        |
+------------------------------------------------------+
```

The layered architecture separates user-facing functionality from infrastructure services and native Linux networking components.

Each layer has a single responsibility and communicates through clearly defined interfaces, improving maintainability and simplifying implementation and maintenance.

---

# 4. Repository Structure

The repository is organized to separate architectural responsibilities from operational components.

```
NMAWW/
│
├── bin/
│   └── wireless
│
├── core/
│   ├── bootstrap.sh
│   ├── colors.sh
│   ├── commands/
│   ├── common.sh
│   ├── config.sh
│   ├── constants.sh
│   ├── logger.sh
│   ├── privilege.sh
│   ├── utils.sh
│   ├── validation.sh
│   └── version.sh
│
├── framework/
│   └── commands/
│
├── config/
├── docs/
├── tests/
├── reports/
├── logs/
├── assets/
└── install.sh
```

The repository follows a layered organization that separates infrastructure services from executable commands and project documentation.

Each directory has a well-defined responsibility:

| Directory | Purpose |
|-----------|---------|
| **bin/** | Framework launcher and entry point. |
| **core/** | Shared services used throughout the framework. |
| **framework/commands/** | User-facing command modules. |
| **config/** | Configuration files and templates. |
| **docs/** | Technical documentation, RFCs, proposals, architecture, and testing. |
| **tests/** | Automated validation and integration tests. |
| **reports/** | Generated reports and execution results. |
| **logs/** | Runtime logging and diagnostics. |
| **assets/** | Images, diagrams, logos, and supporting resources. |

This structure enables the project to evolve without introducing tight coupling between components while maintaining a predictable organization for contributors.

---

# 5. Core Layer

The Core layer represents the foundation of the NMAWW framework.

It provides the shared services required by every command module and is responsible for initializing the execution environment before any operational task is performed.

The Core is intentionally designed to remain independent from individual command implementations.

Its primary responsibilities include:

- Framework initialization.
- Configuration management.
- Environment validation.
- Wireless interface management.
- Privilege verification.
- Logging and diagnostics.
- Version management.
- Command loading.
- Shared utility functions.

The Core follows a service-oriented design in which each component has a single responsibility.

Current Core components include:

| Component | Responsibility |
|-----------|----------------|
| **bootstrap.sh** | Initializes the framework and loads all core services. |
| **commands/loader.sh** | Dynamically loads command modules. |
| **config.sh** | Configuration management. |
| **constants.sh** | Global constants and framework defaults. |
| **logger.sh** | Logging and runtime diagnostics. |
| **privilege.sh** | Privilege validation. |
| **utils.sh** | Shared utility functions. |
| **validation.sh** | Environment validation. |
| **version.sh** | Framework version information. |
| **colors.sh** | Terminal color definitions. |
| **common.sh** | Shared presentation and formatting functions. |

This architecture ensures that command modules remain lightweight and focused solely on their operational responsibilities while relying on the Core for shared functionality.

---

# 6. Framework Layer

The Framework layer contains the operational command modules exposed to the end user.

Unlike the Core, which provides reusable infrastructure services, the Framework layer focuses exclusively on implementing user-facing functionality.

Each command is intentionally designed to remain lightweight by delegating shared responsibilities to the Core layer.

Current command modules include:

| Command | Purpose |
|---------|---------|
| **help** | Display framework help information. |
| **version** | Display framework version details. |
| **status** | Display wireless interface status. |
| **monitor** | Enable monitor mode operations. |
| **restore** | Restore the previous wireless session. |

Every command follows the same execution model:

1. Framework initialization.
2. Environment validation.
3. Configuration loading.
4. Command execution.
5. Logging.
6. Result presentation.

By centralizing common services within the Core layer, command modules remain simple, maintainable, and easy to extend.

Future framework versions may introduce additional commands without requiring architectural modifications to the Core.

---

# 7. Command Execution Flow

Every NMAWW command follows a standardized execution lifecycle to ensure consistent behavior across the framework.

The execution flow is intentionally centralized to minimize duplicated logic and simplify future maintenance.

The typical lifecycle is illustrated below:

```
User
  │
  ▼
bin/wireless
  │
  ▼
bootstrap.sh
  │
  ├── Load Core Services
  ├── Validate Environment
  ├── Load Configuration
  ├── Initialize Logging
  └── Load Command Modules
  │
  ▼
Requested Command
  │
  ▼
Command Execution
  │
  ▼
Result Presentation
```

This execution model provides several engineering advantages:

- Predictable initialization sequence.
- Consistent validation before execution.
- Centralized configuration management.
- Unified logging behavior.
- Reusable infrastructure services.
- Simplified command implementation.

Each command is responsible only for its operational logic while the Core layer handles initialization, validation, configuration, and shared framework services.

This separation significantly reduces code duplication and ensures that future commands automatically inherit improvements made to the Core.

---

# 8. Configuration System

NMAWW uses a centralized configuration system that allows framework behavior to be customized without modifying source code.

Configuration parameters are stored separately from the implementation, enabling repeatable deployments and simplified maintenance across different Linux environments.

The configuration subsystem is responsible for:

- Managing framework settings.
- Defining interface assignments.
- Controlling automatic detection behavior.
- Configuring logging preferences.
- Preserving persistent user settings.

The default configuration file is located under the user's configuration directory and is automatically created during the first execution if it does not already exist.

Typical configuration parameters include:

| Parameter | Purpose |
|-----------|---------|
| **AUTO_DETECT** | Automatically discover wireless adapters. |
| **LOG_LEVEL** | Configure framework logging verbosity. |

The configuration system is designed to remain human-readable and easily extensible as new framework capabilities are introduced.

By separating configuration from implementation, NMAWW minimizes operational complexity while maintaining flexibility for advanced deployments.

---

# 9. Logging System

Logging is a fundamental component of the NMAWW architecture and provides consistent operational visibility across all framework components.

Every significant action performed by the framework should be capable of generating structured log entries that facilitate troubleshooting, debugging, auditing, and future automation.

The logging subsystem is responsible for:

- Recording framework initialization.
- Tracking command execution.
- Capturing validation results.
- Reporting operational events.
- Registering warnings and errors.
- Supporting diagnostic activities.

The framework currently supports multiple log levels:

| Level | Purpose |
|--------|---------|
| **INFO** | General operational information. |
| **WARNING** | Non-critical conditions requiring attention. |
| **ERROR** | Execution failures and unrecoverable conditions. |
| **SUCCESS** | Successful completion of framework operations. |

All log messages are timestamped to improve traceability and simplify incident analysis.

The logging architecture has been intentionally designed to support future extensions such as structured logging, JSON output, remote logging services, and centralized monitoring platforms without requiring changes to command modules.

---

# 10. Validation Layer

The Validation layer ensures that framework operations are executed only when all required conditions have been successfully verified.

Rather than allowing command modules to perform ad hoc checks, NMAWW centralizes validation logic within the Core to provide a consistent and predictable execution model.

The validation subsystem currently verifies:

- Required system commands.
- Root privilege requirements.
- Wireless interface availability.
- Wireless interface capabilities.
- Framework environment readiness.
- Configuration availability.

This centralized approach provides several advantages:

- Consistent validation across all commands.
- Reduced code duplication.
- Simplified maintenance.
- Improved error reporting.
- Easier future expansion.

As the framework evolves, the Validation layer will incorporate additional capabilities, including hardware capability detection, driver compatibility verification, regulatory domain validation, dependency version checks, and health assessment routines.

By separating validation from operational logic, command modules remain focused on their primary responsibilities while relying on a common validation infrastructure.

---

# 11. References

The NMAWW architecture is built upon existing Linux networking technologies and established open-source projects that provide the foundation for modern wireless networking.

The framework does not replace these technologies. Instead, it coordinates their capabilities through a standardized orchestration model designed for multi-adapter wireless environments.

Primary architectural references include:

- Linux Kernel
- Linux Wireless Subsystem
- cfg80211
- mac80211
- nl80211
- NetworkManager
- systemd-networkd
- wpa_supplicant
- iwd
- iproute2
- Wireless Tools
- Aircrack-ng Suite
- Wireshark
- tcpdump
- Nmap
- Bettercap
- Kismet

Additional architectural guidance has been derived from established software engineering principles, including layered architecture, modular design, separation of concerns, single-responsibility components, and reusable service-oriented frameworks.

These technologies collectively provide the underlying capabilities upon which NMAWW defines its orchestration model while preserving full compatibility with the native Linux networking ecosystem.
