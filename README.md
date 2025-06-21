# Vending Machine – FSM-based Digital Logic Project

A finite state machine (FSM)-based vending machine designed and implemented as a final project for the Spring 2025 Digital Systems course.

> 🧠 Built using Verilog HDL. Includes custom testbench, state diagram, and simulation scenarios.

---

## 📌 Project Overview

This vending machine supports:
- Accepting coins (₩1,000 and ₩5,000)
- Purchasing a beverage priced at ₩10,000
- Returning change based on internal balance
- Handling edge cases like simultaneous inputs or overflow

---

## 💡 Functional Specification

### 🟢 Inputs
| Signal         | Width | Description                                   |
|----------------|--------|-----------------------------------------------|
| `coin_in`      | 2-bit  | `00`: no input, `01`: ₩1,000, `10`: ₩5,000     |
| `beverage_take`| 1-bit  | `1`: Request to buy beverage                  |
| `change_take`  | 1-bit  | `1`: Request to get change                    |
| `clk`          | 1-bit  | Clock                                         |
| `rstn`         | 1-bit  | Active-low reset                              |

### 🔴 Outputs
| Signal         | Width | Description                                   |
|----------------|--------|-----------------------------------------------|
| `money_account`| 5-bit  | Current balance in units of ₩1,000            |
| `beverage_out` | 1-bit  | `1`: Dispense beverage                        |
| `change_out`   | 2-bit  | `01`: ₩1,000 returned, `10`: ₩5,000 returned   |

---

## ⚙️ Operational Rules

- Beverage costs ₩10,000. Cannot buy if balance < 10,000
- Maximum allowed balance: ₩20,000. Extra coins are returned immediately
- Change is returned in **₩5,000 first**, if possible, else in **₩1,000**
- Simultaneous inputs (e.g. coin + button) are ignored
- All outputs are **1-cycle delayed** and **asserted for only 1 cycle**

---

## 🧪 Testbench Coverage

The testbench verifies:
- Normal use (inserting coins → buying → returning change)
- Invalid simultaneous inputs → ignored
- Upper limit enforcement (max ₩20,000)
- Beverage purchase with insufficient balance
- Change return logic preference (₩5,000 first)
- All outputs timing: 1-cycle pulse


