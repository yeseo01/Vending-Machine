# Vending Machine — Verilog Digital Logic Project

A Verilog implementation of a vending machine developed as a team final project for the Spring 2025 Digital Systems course.

The design accepts ₩1,000 and ₩5,000 coins, maintains an internal balance of up to ₩20,000, dispenses a ₩10,000 beverage, and returns change according to the project specification.


## Key Highlights

- Uses a Verilog vending-machine design with the monetary balance represented directly as registered machine state.
- Supports ₩1,000 and ₩5,000 coin insertion, a ₩10,000 beverage purchase, a ₩20,000 balance limit, and deterministic change return.
- A later repository refinement replaced incomplete explicit state enumeration with a balance-register design that covers the complete reachable balance range.
- Includes a self-checking Verilog testbench that performs 232 specification checks with zero failures.


## Verification Snapshot

The implementation evolved through both course-level evaluation and later repository-level verification:

| Stage | Result |
| --- | ---: |
| Original explicit-state course implementation | 23 / 30 |
| Revised balance-register course implementation | 30 / 30 |
| Current self-checking regression suite | 232 checks, 0 failures |

The 23/30 and 30/30 results refer to the original course evaluation. The 232-check regression suite is the broader verification environment included in the current repository.


## Project Context

This project was developed as a team final project for the Spring 2025 Digital Systems course.

The original course implementation and submission were developed collaboratively by the team. The current repository also documents a later implementation audit in which reachable-state coverage was examined more systematically and the verification suite was expanded.

The repository therefore distinguishes the original course project from the later engineering refinements rather than attributing the complete current codebase to a single team member.


## Functional Specification

### Inputs

| Signal | Width | Description |
| --- | ---: | --- |
| `clk` | 1 bit | Clock |
| `rstn` | 1 bit | Active-high asynchronous reset |
| `coin_in` | 2 bits | `00`: no coin, `01`: ₩1,000, `10`: ₩5,000 |
| `beverage_take` | 1 bit | Beverage purchase request |
| `change_take` | 1 bit | Change return request |

`coin_in = 2'b11` is outside the valid input set defined by the assignment.

### Outputs

| Signal | Width | Description |
| --- | ---: | --- |
| `money_account` | 5 bits | Balance in units of ₩1,000 |
| `beverage_out` | 1 bit | Beverage dispense pulse |
| `change_out` | 2 bits | `00`: none, `01`: ₩1,000, `10`: ₩5,000 |


## Behavior

- The beverage price is ₩10,000.
- A beverage is dispensed only when the current balance is at least ₩10,000.
- The stored balance cannot exceed ₩20,000.
- If an inserted coin would exceed the balance limit, the balance remains unchanged and the inserted coin is returned.
- Change is returned ₩5,000 at a time whenever possible; otherwise ₩1,000 is returned.
- If more than one command is asserted simultaneously, the request is ignored.
- `beverage_out` and `change_out` are asserted as one-cycle pulses.


## RTL Design

The monetary balance itself is represented directly by the 5-bit `money_account` register.

Rather than manually enumerating a separate FSM branch for every reachable monetary value, the registered balance acts as the machine state. Each valid command updates the balance and corresponding output pulse on the active clock edge.

Conceptually:

```text
coin only
    ├─ new balance <= ₩20,000
    │      └─ increase balance
    └─ new balance > ₩20,000
           └─ keep balance and return inserted coin

beverage only
    ├─ balance >= ₩10,000
    │      └─ subtract ₩10,000 and pulse beverage_out
    └─ balance < ₩10,000
           └─ no state change

change only
    ├─ balance >= ₩5,000
    │      └─ subtract ₩5,000 and return ₩5,000
    ├─ balance > ₩0
    │      └─ subtract ₩1,000 and return ₩1,000
    └─ balance = ₩0
           └─ no state change

multiple simultaneous commands
    └─ ignored
```


## Verification

`VM_tb.v` is a self-checking testbench rather than a waveform-only stimulus file.

It systematically verifies the specification across every balance from ₩0 to ₩20,000, including:

- ₩1,000 coin insertion
- ₩5,000 coin insertion
- balance-limit overflow and coin return
- successful beverage purchases
- rejected purchases below ₩10,000
- ₩5,000-priority change return
- simultaneous-command rejection
- one-cycle output pulse behavior
- asynchronous reset behavior

The current regression suite performs **232 specification checks with zero failures**.

Run the complete verification suite with:

```bash
make test
```

Expected result:

```text
===== FULL SPECIFICATION SUMMARY =====
Operations tested: 232
Failures: 0
PASS: all specification checks passed.
```

Clean generated simulation artifacts with:

```bash
make clean
```


## Implementation Audit

The original course implementation represented monetary values using explicitly named states and was tested using the scenarios required by the assignment.

During a later repository audit, additional valid coin sequences exposed incomplete handling of several reachable balance states. For example, balances such as ₩3,000 and ₩6,000 could be reached internally but did not have complete transition and output logic.

The implementation was subsequently refactored so that the monetary balance itself forms the registered machine state. This eliminates the need to manually define transition logic for every reachable balance.

A broader self-checking regression suite was then added to systematically verify behavior across the complete ₩0–₩20,000 balance range.

This preserves the original external interface and required functionality while removing the incomplete-state failure mode and improving reproducibility of verification.


## Repository Structure

```text
.
├── VM.v          # Vending-machine RTL
├── VM_tb.v       # Self-checking verification testbench
├── Makefile      # Build and test commands
├── .gitignore
└── README.md
```
