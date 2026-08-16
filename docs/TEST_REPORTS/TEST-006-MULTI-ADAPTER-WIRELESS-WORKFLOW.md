# TEST-006 — Multi-Adapter Wireless Workflow

## Test Identification

| Field | Value |
|---|---|
| Test ID | TEST-006 |
| Test Name | Multi-Adapter Wireless Workflow |
| Date | 2026-08-15 |
| Project | Native Multi-Adapter Wireless Workflow (NMAWW) |
| NMAWW Version | 0.1.0-alpha |
| Operating System | Kali GNU/Linux Rolling |
| Test Type | Functional / Hardware Integration |
| Test Environment | Physical Linux workstation |

---

# 1. Objective

Validate the NMAWW Core Service Architecture and Workflow Engine against real physical wireless adapters.

The primary objective is to validate the complete wireless role transition:

Managed
   |
   v
Monitor
   |
   v
Managed

The test also validates:

- Multi-adapter discovery.
- Hot-plug detection.
- NetworkManager integration.
- Monitor Mode transition.
- Preservation of connectivity through an independent interface.
- Managed Mode restoration.
- Recovery of NetworkManager control.
- Final consistency between NMAWW state and the Linux wireless subsystem.

---
# 2. Test Environment

The physical test environment contained multiple wireless adapters.

Observed wireless interfaces:

| Interface | Driver | PHY | Initial Mode |
|---|---|---|---|
| wlan0 | rtw_8821cu | phy13 | Managed |
| wlan1 | mt7921u | phy14 | Managed |

The system also contained:

- `eth0` — primary wired connectivity interface.
- NetworkManager.
- Linux `iw` wireless subsystem.
- Linux `ip` networking utilities.
- Two independently usable wireless adapters.

The Alfa adapter was identified as `wlan1` during the test.

---

# 3. Test Scope

The test covered the following workflow:

Hardware Discovery
        |
        v
Multi-Adapter Detection
        |
        v
Managed Baseline
        |
        v
Monitor Candidate Selection
        |
        v
Monitor Mode Transition
        |
        v
Connectivity Preservation
        |
        v
Monitor Validation
        |
        v
Managed Mode Restoration
        |
        v
NetworkManager Recovery
        |
        v
Final Validation

---
# 4. Evidence Sources

The validation was performed using NMAWW together with native Linux networking and wireless tools.

The following commands were used during the validation:

NMAWW commands:

    ./bin/wireless status
    ./bin/wireless monitor
    ./bin/wireless station

Wireless subsystem:

    iw dev
    iw dev wlan0 info
    iw dev wlan1 info

NetworkManager:

    nmcli device show wlan0
    nmcli device show wlan1

Network and link state:

    ip link show wlan0
    ip link show wlan1
    ip route

Connectivity:

    ping -c 3 -W 2 192.168.0.1

Hardware detection:

    lsusb

---

Additional validation included direct inspection of the NMAWW Core Service Architecture, command loader, command argument propagation, role selection logic and development shell.

---

# 5. Test Execution

The validation was performed in several stages.

The following stages correspond to the actual tests executed during the hardware validation:

    TEST-003-B — Command Argument Flow Audit
    TEST-003-C — Argument Propagation
    TEST-003-E — Real Monitor Capability Audit
    TEST-003-G — Manual Monitor Transaction Baseline
    TEST-003-H — Manual Monitor Transition
    TEST-003-I — Manual Monitor Recovery
    TEST-003-J — Post-Monitor Validation
    TEST-003-L — Post-Restore Validation

The following sections document the relevant observations and results from these executions.

### TEST-003-E Note

The TEST-003-E capability audit attempted to query wireless PHY capabilities using `iw phy <phy> info`. On the test system, this query returned `command failed: No such file or directory (-2)` and therefore was not used as acceptance evidence.

Monitor functionality was subsequently validated through an actual Managed-to-Monitor interface transition during TEST-003-H and through the NMAWW Monitor workflow documented in TEST-003-J.

---
# 6. TEST-003-G — Pre-Transition Baseline

Before performing any Monitor Mode transition, the wireless environment was validated in its normal Managed state.

## NMAWW Status

NMAWW detected two wireless interfaces:

| Interface | Driver | PHY | Mode | Connection |
|---|---|---|---|---|
| wlan0 | rtw_8821cu | phy13 | Managed | Connected |
| wlan1 | mt7921u | phy14 | Managed | Connected |

NMAWW reported:

    Detected Interfaces : 2
    Preferred Interface : eth0
    Internet Available  : YES
    Gateway             : 192.168.0.1

Both wireless interfaces were connected to the same wireless network.

## Alfa Adapter Baseline

The Alfa adapter was operating as `wlan1`.

Observed state:

    Interface : wlan1
    Type      : managed
    PHY       : phy14
    Channel   : 44 (5220 MHz)
    Width     : 80 MHz
    TX Power  : 3.00 dBm

NetworkManager reported:

    GENERAL.DEVICE       : wlan1
    GENERAL.STATE        : 100 (connected)
    GENERAL.CONNECTION   : VirusMyDoom 1

## Secondary Adapter Baseline

The second wireless adapter was operating as `wlan0`.

Observed state:

    Interface : wlan0
    Type      : managed
    PHY       : phy13
    Channel   : 44 (5220 MHz)
    Width     : 80 MHz
    TX Power  : 20.00 dBm

## Connectivity Baseline

The system maintained three default routes:

    default via 192.168.0.1 dev eth0
    default via 192.168.0.1 dev wlan0
    default via 192.168.0.1 dev wlan1

The gateway was tested using ICMP.

Result:

    3 packets transmitted
    3 packets received
    0% packet loss

Average latency:

    0.514 ms

## Baseline Result

PASS

The system entered the Monitor Mode test with:

- Two detected wireless adapters.
- Both adapters operating in Managed Mode.
- Both wireless interfaces connected.
- `eth0` providing the preferred route.
- Wireless connectivity available as redundant paths.
- Gateway reachable with 0% packet loss.

---

# 7. TEST-003-H — Manual Monitor Mode Transition

The next stage validated a real Monitor Mode transition on the Alfa adapter.

The operation was performed manually first in order to isolate the Linux wireless behavior from the NMAWW workflow engine.

## Step 1 — NetworkManager Release

The Alfa interface `wlan1` was released from NetworkManager control.

Command:

    sudo nmcli device set wlan1 managed no

Result:

    GENERAL.DEVICE:  wlan1
    GENERAL.STATE:   10 (unmanaged)
    GENERAL.CONNECTION: --

Result: PASS

NetworkManager successfully released the interface.

## Step 2 — Interface Down

The interface was brought down before changing its wireless type.

Command:

    sudo ip link set wlan1 down

Observed state:

    wlan1: BROADCAST,MULTICAST
    state DOWN

Result: PASS

## Step 3 — Monitor Mode Transition

The wireless interface was changed from Managed Mode to Monitor Mode.

Command:

    sudo iw dev wlan1 set type monitor

Observed result:

    Interface wlan1
    type monitor

Result: PASS

The physical adapter successfully entered Monitor Mode.

## Step 4 — Monitor Interface Activation

The interface was brought back up.

Command:

    sudo ip link set wlan1 up

The resulting wireless state was:

    Interface wlan1
    type monitor
    channel 1 (2412 MHz)
    width 20 MHz
    center frequency 2412 MHz

The Linux wireless subsystem identified the interface as:

    link/ieee802.11/radiotap

Result: PASS

This confirms that `wlan1` was operating as a real Monitor Mode interface.

## Independent Connectivity

During the transition, `wlan0` remained in Managed Mode.

Observed state:

    Interface wlan0
    type managed
    channel 44 (5220 MHz)
    width 80 MHz
    TX power 20.00 dBm

The system retained the following default routes:

    default via 192.168.0.1 dev eth0
    default via 192.168.0.1 dev wlan0

The gateway remained reachable.

Connectivity test:

    3 packets transmitted
    3 packets received
    0% packet loss

Result: PASS

## Monitor Transition Result

The manual transition successfully demonstrated:

    wlan1
       Managed
          |
          v
       Monitor

while:

    wlan0
       Managed

and:

    eth0
       Primary connectivity

The Monitor Mode transition did not interrupt gateway connectivity.

Overall result: PASS

---

# 8. TEST-003-I — Manual Monitor Mode Recovery

After validating Monitor Mode, the Alfa adapter was returned to Managed Mode.

## Step 1 — Interface Down

The monitor interface was first brought down.

Command:

    sudo ip link set wlan1 down

Observed state:

    wlan1
    state DOWN
    link/ieee802.11/radiotap

Result: PASS

## Step 2 — Restore Managed Mode

The wireless interface type was changed back to Managed Mode.

Command:

    sudo iw dev wlan1 set type managed

Observed result:

    Interface wlan1
    type managed

Result: PASS

## Step 3 — Interface Up

The interface was brought back up.

Command:

    sudo ip link set wlan1 up

The interface returned to an operational state and was ready for NetworkManager.

## Step 4 — Return Control to NetworkManager

NetworkManager management was restored.

Command:

    sudo nmcli device set wlan1 managed yes

NetworkManager initially reported:

    GENERAL.DEVICE:  wlan1
    GENERAL.TYPE:   wifi
    GENERAL.STATE:  30 (disconnected)
    GENERAL.CONNECTION: --

Result: PASS

NetworkManager successfully regained control of the interface.

## Step 5 — Connection Recovery

A direct connection request was attempted:

    sudo nmcli device connect wlan1

The command initially returned:

    Error: Failed to add/activate new connection:
    A 'wireless' setting is required if no AP path was given.

This behavior was recorded as an intermediate observation.

A subsequent NetworkManager state check showed:

    GENERAL.DEVICE:       wlan1
    GENERAL.TYPE:         wifi
    GENERAL.STATE:        100 (connected)
    GENERAL.CONNECTION:   VirusMyDoom 1

The interface successfully reconnected to the wireless network.

Result: PASS

## Final WLAN1 State

The final wireless state was:

    Interface wlan1
    SSID      VirusMyDoom
    type      managed
    channel   44 (5220 MHz)
    width     80 MHz
    TX power  3.00 dBm

The interface received:

    192.168.0.205/24

Network connectivity was restored.

## Recovery Result

The complete recovery sequence was successful:

    Monitor
       |
       v
    Interface Down
       |
       v
    Managed
       |
       v
    Interface Up
       |
       v
    NetworkManager Control
       |
       v
    Connected

Overall result: PASS

---
# 9. TEST-003-J — NMAWW Monitor Workflow

After validating the underlying Linux wireless operations manually, the NMAWW workflow was executed against the physical adapters.

The command executed was:

    sudo ./bin/wireless monitor

## Monitor Preflight

NMAWW performed its preflight validation and reported:

    Internet         : YES
    Preferred IF     : eth0
    Monitor Candidate: wlan0

The workflow reported:

    Preflight OK

Result: PASS

## Monitor Mode Activation

NMAWW then performed the Monitor Mode transition.

The framework reported:

    Monitor Mode Enabled

    Monitor Interface : wlan0

Result: PASS

The selected monitor candidate was `wlan0`.

The selection was intentional because `eth0` remained the preferred connectivity interface and `wlan1` remained available as a managed wireless interface.

## Post-Monitor NMAWW Status

NMAWW reported:

    wlan0      UP       MONITOR    rtw_8821cu     phy13
    wlan1      UP       MANAGED    mt7921u        phy14

Wireless roles were reported as:

    Interface : wlan0
    Driver    : rtw_8821cu
    Mode      : MONITOR
    Connected : NO
    Role      : MONITOR

    Interface : wlan1
    Driver    : mt7921u
    Mode      : MANAGED
    Connected : YES
    Role      : MANAGED

This confirms that NMAWW maintained the intended separation between the Monitor interface and the managed connectivity interface.

## Linux Wireless Subsystem Validation

The Linux wireless subsystem independently confirmed:

    wlan0
        type monitor
        channel 1 (2412 MHz)
        width 20 MHz
        TX power 20.00 dBm

    wlan1
        type managed
        channel 44 (5220 MHz)
        width 80 MHz
        TX power 3.00 dBm
        SSID VirusMyDoom

The operating system therefore agreed with the state reported by NMAWW.

Result: PASS

## NetworkManager Validation

NetworkManager reported:

    wlan0
        GENERAL.TYPE:   wifi
        GENERAL.STATE:  10 (unmanaged)
        GENERAL.CONNECTION: --

    wlan1
        GENERAL.TYPE:   wifi
        GENERAL.STATE:  100 (connected)
        GENERAL.CONNECTION: VirusMyDoom 1

This demonstrates that NetworkManager released the interface operating in Monitor Mode while retaining control of the managed wireless interface.

Result: PASS

## Connectivity Preservation

After the Monitor Mode transition, the system retained:

    default via 192.168.0.1 dev eth0
    default via 192.168.0.1 dev wlan1

The gateway remained reachable.

Connectivity test:

    3 packets transmitted
    3 packets received
    0% packet loss

Average latency:

    0.489 ms

Result: PASS

## NMAWW Monitor Workflow Result

The NMAWW workflow successfully achieved:

    wlan0
       Managed
          |
          v
       Monitor

while maintaining:

    wlan1
       Managed
       Connected

and:

    eth0
       Primary connectivity

Overall result: PASS

---

# 10. TEST-003-L — Post-Restore Validation

After completing the Monitor Mode workflow, the NMAWW station workflow was executed to restore the wireless environment.

The command executed was:

    sudo ./bin/wireless station

## Station Preflight

NMAWW reported:

    Internet          : YES
    Preferred IF      : eth0
    Monitor Interface : wlan0

The workflow reported:

    Preflight OK

Result: PASS

## Managed Mode Restoration

NMAWW reported:

    Managed Mode Restored

    Internet Interface : eth0

The framework also reported:

    Managed wireless environment restored.

Result: PASS

## Final NMAWW Status

After restoration, NMAWW detected:

    wlan0      UP       MANAGED    rtw_8821cu     phy13
    wlan1      UP       MANAGED    mt7921u        phy14

Both wireless interfaces were reported as:

    Role      : MANAGED
    Connected : YES

Result: PASS

## Final WLAN0 State

The Linux wireless subsystem reported:

    Interface wlan0
    SSID      : VirusMyDoom
    type      : managed
    channel   : 44 (5220 MHz)
    width     : 80 MHz
    TX power  : 20.00 dBm

NetworkManager reported:

    GENERAL.DEVICE       : wlan0
    GENERAL.TYPE         : wifi
    GENERAL.STATE        : 100 (connected)
    GENERAL.CONNECTION   : VirusMyDoom

Result: PASS

## Final WLAN1 State

The Linux wireless subsystem reported:

    Interface wlan1
    SSID      : VirusMyDoom
    type      : managed
    channel   : 44 (5220 MHz)
    width     : 80 MHz
    TX power  : 3.00 dBm

NetworkManager reported:

    GENERAL.DEVICE       : wlan1
    GENERAL.TYPE         : wifi
    GENERAL.STATE        : 100 (connected)
    GENERAL.CONNECTION   : VirusMyDoom 1

Result: PASS

## Final Routing State

The system retained the primary wired route:

    default via 192.168.0.1 dev eth0
    metric 100

Wireless fallback routes were also present:

    default via 192.168.0.1 dev wlan1
    metric 602

    default via 192.168.0.1 dev wlan0
    metric 603

This confirms that `eth0` remained the preferred connectivity interface while both wireless adapters were restored to normal Managed operation.

Result: PASS

## Final Connectivity Test

The gateway was tested after the complete Monitor-to-Managed recovery cycle.

Result:

    3 packets transmitted
    3 packets received
    0% packet loss

Average latency:

    0.569 ms

Result: PASS

## Final Restore Result

The complete workflow was successfully restored:

    Monitor
       |
       v
    Managed
       |
       v
    NetworkManager control
       |
       v
    Wireless reconnection
       |
       v
    Normal multi-adapter operation

Overall result: PASS

---

# 11. Final Validation Matrix

The following matrix summarizes the results observed during TEST-006.

| Validation | Result |
|---|---|
| `wlan0` detected | PASS |
| `wlan1` detected | PASS |
| Multi-adapter discovery | PASS |
| Alfa adapter hot-plug detected | PASS |
| `wlan0` initially in Managed Mode | PASS |
| `wlan1` initially in Managed Mode | PASS |
| Manual Managed-to-Monitor transition | PASS |
| `wlan0` transitioned to Monitor Mode through NMAWW | PASS |
| `wlan1` remained Managed during Monitor workflow | PASS |
| NetworkManager released Monitor interface | PASS |
| NetworkManager retained control of managed interface | PASS |
| `eth0` retained primary connectivity | PASS |
| Connectivity preserved during Monitor Mode | PASS |
| Gateway reachable during Monitor Mode | PASS |
| Gateway packet loss during Monitor workflow | **0%** |
| NMAWW Monitor workflow completed | PASS |
| NMAWW Station workflow completed | PASS |
| Managed Mode restoration | PASS |
| NetworkManager control restored | PASS |
| `wlan0` reconnected | PASS |
| `wlan1` reconnected | PASS |
| Final routing state restored | PASS |
| Final gateway connectivity | PASS |
| Final gateway packet loss | **0%** |
| NMAWW status matched Linux wireless state | PASS |

---

# 12. Acceptance Criteria

TEST-006 is considered successful when the framework can:

1. Detect multiple physical wireless adapters.
2. Maintain a managed connectivity interface while another adapter transitions to Monitor Mode.
3. Preserve primary network connectivity during the transition.
4. Correctly coordinate NetworkManager state.
5. Report the actual wireless state through the NMAWW status command.
6. Restore the Monitor interface to Managed Mode.
7. Return NetworkManager control to the restored interface.
8. Re-establish wireless connectivity.
9. Preserve normal routing and gateway accessibility after restoration.

All observed acceptance criteria were satisfied.

---

# 13. Technical Conclusion

TEST-006 successfully validated the NMAWW Core Service Architecture and Workflow Engine against real physical wireless hardware.

The test demonstrated that NMAWW can coordinate multiple wireless adapters while maintaining separation between wireless roles.

The principal validated workflow was:

```text
Multi-Adapter Discovery
        |
        v
Managed Baseline
        |
        v
Monitor Candidate Selection
        |
        v
NMAWW Monitor Workflow
        |
        +----------------------+
        |                      |
        v                      v
    wlan0 MONITOR          wlan1 MANAGED
        |                      |
        |                      v
        |                 Connectivity
        |                      |
        +----------+-----------+
                   |
                   v
             NMAWW Station
                   |
                   v
          Managed Restoration
                   |
                   v
         NetworkManager Recovery
                   |
                   v
        Final Multi-Adapter State

```

# 14. Test Result

## PASS

**TEST-006 — Multi-Adapter Wireless Workflow**

The NMAWW framework successfully completed the tested Managed → Monitor → Managed workflow on real physical wireless adapters while preserving network connectivity and restoring the system to a normal operational state.

This test provides functional and hardware-integration evidence supporting the current NMAWW Core Service Architecture and Workflow Engine.

---

# 15. Evidence Sources

The test evidence was collected directly from the Linux host using native system utilities and NMAWW commands, including:

```text
./bin/wireless status
sudo ./bin/wireless monitor
sudo ./bin/wireless station
iw dev
iw dev <interface> info
iw phy <phy> info
nmcli device show <interface>
ip link show <interface>
ip route
ping
lsusb
```

---

# 16. Reproducibility

The test can be reproduced on a compatible Linux system containing multiple supported wireless adapters.

The relevant workflow commands are:

```bash
./bin/wireless status
sudo ./bin/wireless monitor
./bin/wireless status
sudo ./bin/wireless station
./bin/wireless status
```

---

# 17. Final Status

| Item | Status |
|---|---|
| Functional validation | PASS |
| Hardware integration | PASS |
| Multi-adapter operation | PASS |
| Monitor workflow | PASS |
| Managed restoration | PASS |
| Connectivity preservation | PASS |
| NetworkManager recovery | PASS |
| Final system state | PASS |
| Test result | **PASS** |

**TEST-006 APPROVED**
