# Migration to Core

## Native Multi-Adapter Wireless Workflow

**Version:** 1.0

**Status:** Draft

**Author:** Alfredo San

**Date:** July 2026

---

# Executive Summary

The migration from the original framework library architecture to the Core architecture represents one of the most significant engineering milestones within the NMAWW project.

This migration consolidated shared infrastructure services into a dedicated Core layer, simplifying the execution model, reducing code duplication, and improving long-term maintainability.

This document records the motivation, implementation strategy, migration process, and resulting architectural improvements.

---

# Table of Contents

1. Background
2. Motivation
3. Previous Architecture
4. Migration Strategy
5. Migration Results
6. Lessons Learned
7. References

---

# 1. Background

Early versions of NMAWW stored shared framework functionality within the `framework/lib` directory.

While functional, this organization mixed infrastructure services with operational components, making future expansion increasingly difficult.

As the framework matured, it became evident that a dedicated infrastructure layer would provide a cleaner separation of responsibilities and improve the maintainability of the project.

The introduction of the Core architecture addressed these limitations while preserving compatibility with existing command modules.

---

# 2. Motivation

The migration was driven by several engineering objectives.

Primary goals included:

- Centralize shared services.
- Eliminate duplicated initialization logic.
- Improve modularity.
- Simplify framework maintenance.
- Separate infrastructure from operational commands.
- Support future framework expansion.
- Improve repository organization.
- Standardize framework initialization.

These objectives collectively established the foundation for the Core architecture adopted by NMAWW.

---

# 3. Previous Architecture

Prior to the introduction of the Core layer, shared framework functionality resided within the `framework/lib` directory.

The original architecture provided reusable services but lacked a clear separation between infrastructure and operational components.

The simplified repository organization was structured as follows:

```
framework/
├── commands/
└── lib/
```

Although this approach supported the initial framework implementation, it presented several architectural limitations:

- Infrastructure services were tightly associated with the Framework layer.
- Initialization responsibilities were less clearly defined.
- Future infrastructure expansion risked increasing coupling.
- Repository organization did not accurately represent architectural responsibilities.

These observations motivated the transition toward a dedicated Core layer.

---

# 4. Migration Strategy

The migration was intentionally designed as an internal architectural refactoring.

Its primary objective was to improve maintainability without altering the external behavior of the framework.

The migration strategy followed these steps:

1. Introduce the new `core/` directory.
2. Relocate all shared infrastructure services.
3. Implement a centralized bootstrap process.
4. Introduce the dynamic command loader.
5. Update the framework launcher.
6. Update the installation process.
7. Remove the obsolete `framework/lib` directory.
8. Validate framework functionality after migration.

By performing the migration incrementally, the project preserved functional stability while significantly improving its internal organization.

---

# 5. Migration Results

The migration successfully established a dedicated infrastructure layer while preserving the operational behavior of the framework.

Following the migration, the repository adopted a clearer separation between infrastructure services and user-facing command modules.

Key outcomes include:

- Introduction of the `core/` directory.
- Centralized framework initialization.
- Dynamic command loading.
- Simplified dependency management.
- Improved repository organization.
- Removal of the legacy `framework/lib` directory.
- Cleaner separation between infrastructure and operational logic.

The resulting architecture is significantly easier to understand, maintain, and extend.

---

# 6. Lessons Learned

The migration reinforced several important engineering principles.

First, architectural organization becomes increasingly important as software projects grow.

Second, investing time in infrastructure refactoring early significantly reduces future maintenance costs.

Third, separating infrastructure services from operational components improves readability, testing, and long-term scalability.

Finally, incremental migrations minimize risk by allowing each architectural change to be validated before proceeding to the next stage.

These lessons will guide future architectural evolution within NMAWW.

---

# 7. References

The migration strategy adopted by NMAWW was influenced by established software engineering practices emphasizing modularity, layered architecture, separation of concerns, and incremental refactoring.

The implementation remains fully compatible with native Linux networking components while preserving the framework's objective of minimizing complexity and maximizing maintainability.

This migration represents a foundational architectural milestone that established the current Core architecture of NMAWW.
