# Architectural Decisions

## Native Multi-Adapter Wireless Workflow

**Version:** 1.0

**Status:** Draft

**Author:** Alfredo San

**Date:** July 2026

---

# Executive Summary

Every architectural decision within NMAWW has been intentionally documented to preserve the project's engineering rationale over time.

Rather than recording only *what* was implemented, this document explains *why* specific architectural choices were made and what engineering trade-offs influenced those decisions.

This approach improves long-term maintainability, facilitates community contributions, and preserves architectural consistency as the framework evolves.

---

# Table of Contents

1. Purpose
2. Decision Process
3. Architectural Decisions
4. Accepted Trade-offs
5. Deferred Decisions
6. Future Decision Process
7. References

---

# 1. Purpose

The objective of this document is to preserve the architectural reasoning behind the framework.

As software projects evolve, implementation details often remain visible while the motivations that led to those implementations gradually disappear.

Documenting architectural decisions ensures that future contributors understand the engineering context in which each major decision was made.

This document complements the Architecture documentation by focusing on decision rationale rather than technical implementation.

---

# 2. Decision Process

Architectural decisions within NMAWW follow a structured engineering process.

Each decision is evaluated according to several criteria before becoming part of the framework.

Typical evaluation criteria include:

- Simplicity.
- Maintainability.
- Native Linux compatibility.
- Modularity.
- Long-term scalability.
- Community adoption.
- Backward compatibility.
- Operational reliability.

Only decisions that improve the long-term quality of the framework are incorporated into the architecture.

# 3. Major Architectural Decisions

## AD-001 — Hardware Inventory Service

### Decision

Introduce a dedicated Hardware Inventory Service within the Core architecture responsible for centralized wireless hardware discovery.

### Motivation

Early versions of the framework allowed individual command modules to query Linux networking components directly.

Although functional, this approach duplicated logic across multiple commands and increased maintenance complexity.

The Hardware Inventory Service centralizes hardware discovery into reusable Core functions while separating hardware detection from presentation logic.

### Consequences

- Command modules no longer interact directly with Linux networking utilities.
- Hardware discovery becomes reusable across the entire framework.
- Future hardware capabilities can be incorporated without modifying command implementations.
- The Core becomes the single source of truth for wireless hardware information.

Current Hardware Inventory functions include:

Current Hardware Inventory functions include:

- discover_adapters()
- get_adapter_driver()
- get_adapter_phy()
- get_adapter_mac()
- get_adapter_operstate()
- get_adapter_mode()
- get_adapter_frequency()
- get_adapter_signal()
- get_adapter_ssid()
- get_adapter_bssid()
- get_adapter_channel()
- get_adapter_band()
- get_adapter_rx_bitrate()
- get_adapter_tx_bitrate()
- inventory_hardware()

Future versions will extend this service with capability detection, runtime information, and workflow integration.
