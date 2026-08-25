# Core Design

## Native Multi-Adapter Wireless Workflow

**Version:** 1.0

**Status:** Draft

**Author:** Alfredo San

**Date:** July 2026

---

# Executive Summary

The Core is the foundational layer of the Native Multi-Adapter Wireless Workflow (NMAWW).

It provides the shared infrastructure responsible for initialization, validation, configuration management, logging, privilege verification, interface management, and common framework services.

The Core has been intentionally designed to remain independent from user-facing command implementations, allowing the framework to evolve while maintaining architectural consistency and minimizing code duplication.

This document describes the internal organization, responsibilities, and design philosophy of the Core layer.

---

# Table of Contents

1. Purpose
2. Design Principles
3. Core Components
4. Bootstrap Process
5. Service Responsibilities
6. Execution Lifecycle
7. Dependency Model
8. References

---

# 1. Purpose

The Core is the foundational infrastructure of the Native Multi-Adapter Wireless Workflow (NMAWW).

Its primary purpose is to provide centralized services that support every operational component of the framework while remaining completely independent from individual command implementations.

Rather than embedding common functionality within each command module, the Core consolidates shared services into reusable components that are initialized once and consumed throughout the framework.

The Core is responsible for:

- Framework initialization.
- Environment validation.
- Configuration management.
- Wireless interface management.
- Logging and diagnostics.
- Privilege verification.
- Version management.
- Shared utility functions.
- Dynamic command loading.

This architecture minimizes code duplication, promotes consistency across commands, and simplifies future framework expansion.

By separating infrastructure services from operational logic, NMAWW establishes a stable foundation upon which additional functionality can be developed without requiring structural modifications to the framework.

---

# 2. Design Principles

The Core follows a service-oriented architecture in which each component performs a single, clearly defined responsibility.

Every service is designed to be reusable, independent, and easily maintainable while exposing a predictable interface to the rest of the framework.

The Core has been designed according to the following principles:

- Single responsibility.
- Modular implementation.
- Centralized initialization.
- Shared reusable services.
- Minimal interdependencies.
- Predictable execution flow.
- Native Linux integration.
- Simplicity over complexity.
- Future extensibility.

By adhering to these principles, the Core provides a stable execution environment that remains independent from user-facing command implementations while allowing the framework to evolve without architectural disruption.

---

# 3. Core Components

The Core is composed of independent service modules that collectively provide the execution environment required by the framework.

Each component has a clearly defined responsibility and can evolve independently without affecting the remaining Core services.

The current Core implementation consists of the following components:

| Component | Responsibility |
|-----------|----------------|
| **bootstrap.sh** | Initializes the framework and loads all Core services. |
| **commands/loader.sh** | Dynamically loads command modules. |
| **constants.sh** | Defines global constants and framework defaults. |
| **config.sh** | Creates, loads, and manages framework configuration. |
| **validation.sh** | Performs framework and environment validation. |
| **privilege.sh** | Verifies execution privileges. |
| **logger.sh** | Provides centralized logging services. |
| **utils.sh** | Implements shared utility functions. |
| **version.sh** | Maintains framework version information. |
| **colors.sh** | Provides terminal color definitions. |
| **common.sh** | Implements common presentation utilities. |

The modular organization allows new Core services to be introduced without modifying existing components, preserving long-term maintainability.

---
## Hardware Inventory Service

The Hardware Inventory Service is responsible for discovering and maintaining a consistent view of the wireless hardware available to the framework.

Rather than allowing individual command modules to query Linux networking components directly, the Hardware Inventory Service centralizes hardware discovery into reusable Core functions.

Current responsibilities include:

- Wireless adapter discovery.
- Driver detection.
- PHY identification.
- MAC address retrieval.
- Interface state detection.
- Interface mode detection.
- Frequency detection.
- Signal detection.
- SSID and BSSID detection.
- Channel detection.
- Wireless band detection.
- RX/TX bitrate detection.
- Hardware inventory generation.

The service is implemented by `core/hardware.sh`.

Higher-level services consume this information through the Core inventory functions instead of interacting directly with Linux system utilities.

Current service hierarchy:

Hardware Inventory Service

    inventory_hardware()

        ├── discover_adapters()
        ├── get_adapter_driver()
        ├── get_adapter_phy()
        ├── get_adapter_mac()
        ├── get_adapter_operstate()
        ├── get_adapter_mode()
        ├── get_adapter_frequency()
        ├── get_adapter_signal()
        ├── get_adapter_ssid()
        ├── get_adapter_bssid()
        ├── get_adapter_channel()
        ├── get_adapter_band()
        ├── get_adapter_rx_bitrate()
        └── get_adapter_tx_bitrate()

The Hardware Inventory Service provides the foundation for the State, Capability, Role, and Workflow layers.
---

# 4. Bootstrap Process

Framework initialization begins with the bootstrap component.

The bootstrap process is responsible for preparing the execution environment before any command is allowed to run.

The initialization sequence follows these steps:

1. Load global constants.
2. Load shared presentation utilities.
3. Load version information.
4. Initialize the logging subsystem.
5. Load configuration management.
6. Load shared utilities.
7. Load validation services.
8. Load privilege management.
9. Load hardware and wireless state services.
10. Load the command loader.
11. Validate the execution environment.
12. Load the framework configuration.

Only after these initialization steps have completed successfully are command modules allowed to execute.

This centralized initialization process guarantees that every command operates under identical execution conditions.

---

# 5. Service Responsibilities

Each Core service is designed around a single responsibility to ensure modularity, maintainability, and predictable behavior.

Rather than concentrating multiple responsibilities within a single component, the Core distributes infrastructure services across specialized modules.

The primary responsibilities of each service are summarized below:

| Service | Responsibility |
|----------|----------------|
| Bootstrap | Framework initialization and Core service loading. |
| Constants | Global framework constants and defaults. |
| Configuration | Framework configuration management. |
| Hardware | Wireless hardware discovery and inventory. |
| Capabilities | Wireless adapter capability detection. |
| State | Normalized runtime state representation. |
| Roles | Wireless interface role determination. |
| Network | NetworkManager and connectivity operations. |
| Session | Runtime session state persistence. |
| Transaction | Transaction lifecycle and rollback handling. |
| Workflow | High-level workflow orchestration. |
| Validation | Environment and dependency verification. |
| Logger | Runtime logging and diagnostics. |
| Privilege | Execution privilege validation. |
| Utilities | Shared helper functions. |
| Version | Framework identification and version information. |
| Colors | Terminal output formatting. |
| Presentation | Framework output and presentation utilities. |
| Common | Shared framework functionality. |
| Command Loader | Dynamic discovery and loading of command modules. |

This modular approach improves maintainability by allowing individual services to remain independently maintainable while preserving a stable public interface.

---

# 6. Execution Lifecycle

Every framework execution follows a deterministic lifecycle managed entirely by the Core.

The lifecycle has been designed to guarantee that commands execute only after the framework has been completely initialized.

The execution sequence is illustrated below:

```
Framework Start
        │
        ▼
Bootstrap Initialization
        │
        ▼
Load Core Services
        │
        ▼
Validate Environment
        │
        ▼
Load Configuration
        │
        ▼
Load Commands
        │
        ▼
Execute Requested Command
        │
        ▼
Generate Output
        │
        ▼
Framework Exit
```

This lifecycle ensures consistent behavior across all commands while reducing duplicated initialization logic throughout the framework.

---

# 7. Dependency Model

The Core has been designed to minimize dependencies between internal components while maintaining a clear initialization order.

Each service depends only on the functionality required to fulfill its specific responsibility.

The dependency hierarchy follows a top-down model in which foundational services are initialized before higher-level services become available.

The simplified dependency model is illustrated below:

```
bootstrap.sh
│
├── constants.sh
├── colors.sh
├── common.sh
├── version.sh
├── logger.sh
├── config.sh
├── utils.sh
├── validation.sh
├── privilege.sh
│
├── hardware.sh
├── parsers.sh
├── capabilities.sh
├── state.sh
├── roles.sh
├── connectivity.sh
├── presentation.sh
├── session.sh
├── network.sh
├── transaction.sh
├── workflow.sh
│
└── command loader
        │
        └── framework/commands/*
The dependency model separates low-level hardware discovery from higher-level operational services.

Hardware discovery provides the foundation for capability detection and runtime state.

Role management consumes hardware and state information to determine suitable operational roles.

Network, session, transaction, and workflow services provide the operational control layer used by command modules.

Command modules remain intentionally lightweight and delegate infrastructure operations to the Core.

This structure prevents circular dependencies and simplifies future maintenance by preserving a predictable initialization sequence.


---

# 8. References

The Core architecture has been developed using well-established software engineering practices and existing Linux networking technologies.

Its design is based upon principles including:

- Modular architecture.
- Layered architecture.
- Separation of concerns.
- Single responsibility.
- Service-oriented design.
- Reusable infrastructure services.

The Core operates entirely on top of native Linux networking components and does not introduce proprietary abstractions or kernel modifications.

Its implementation remains fully compatible with modern Linux distributions and the native networking capabilities used by NMAWW.
