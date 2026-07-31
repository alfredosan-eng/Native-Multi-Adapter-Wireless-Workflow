# NMAWW Official Test Matrix

## Native Multi-Adapter Wireless Workflow

**Version:** 1.0

**Status:** Draft

**Author:** Alfredo San

**Date:** July 2026

---

# Purpose

This document defines the official validation matrix for the Native Multi-Adapter Wireless Workflow (NMAWW).

Each test case represents an individual validation scenario that verifies a specific aspect of the framework.

All official validation reports shall reference one or more Test IDs defined in this matrix.

---

# Test Status

| Status | Meaning |
|---------|---------|
| NOT STARTED | Test has not been executed |
| IN PROGRESS | Test is currently being executed |
| PASS | Test completed successfully |
| FAIL | Test failed |
| BLOCKED | Test cannot be executed |

---

# Test Matrix

| Test ID | Category | Test Name | Expected Result | Status |
|---------|----------|-----------|-----------------|--------|
| T001 | Installation | Framework Installation | Successful installation | NOT STARTED |
| T002 | Hardware | Wireless Adapter Detection | All supported adapters detected | NOT STARTED |
| T003 | Hardware | Driver Validation | Drivers correctly identified | NOT STARTED |
| T004 | Hardware | Capability Detection | Managed/Monitor capabilities detected | NOT STARTED |
| T005 | Roles | Interface Role Assignment | Roles assigned successfully | NOT STARTED |
| T006 | Managed Mode | Internet Connectivity | Internet remains available | NOT STARTED |
| T007 | Monitor Mode | Monitor Interface Activation | Monitor mode enabled successfully | NOT STARTED |
| T008 | Multi-Adapter | Managed + Monitor Coexistence | Both interfaces operate simultaneously | NOT STARTED |
| T009 | Network | Concurrent Internet + Monitor Mode | Internet maintained during monitoring | NOT STARTED |
| T010 | Network | Nmap During Monitor Mode | Nmap executes without affecting monitor interface | NOT STARTED |
| T011 | Packet Capture | Wireshark Capture | Packets captured successfully | NOT STARTED |
| T012 | Packet Capture | tcpdump Capture | Packets captured successfully | NOT STARTED |
| T013 | Wireless | Passive Reconnaissance | Networks discovered correctly | NOT STARTED |
| T014 | Wireless | Bettercap Execution | Bettercap operates correctly | NOT STARTED |
| T015 | Wireless | Aircrack-ng Integration | Compatible operation verified | NOT STARTED |
| T016 | Stability | Long Duration Execution | Stable operation maintained | NOT STARTED |
| T017 | Recovery | Adapter Disconnect Recovery | Framework handles disconnect gracefully | NOT STARTED |
| T018 | Configuration | Persistent Configuration | Configuration restored correctly | NOT STARTED |
| T019 | Logging | Log Generation | Logs generated successfully | NOT STARTED |
| T020 | Diagnostics | Health Check | Framework reports healthy state | NOT STARTED |
