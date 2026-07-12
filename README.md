# RISC-V Single-Cycle Processor (RV32I)

![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Tool](https://img.shields.io/badge/Tool-Vivado%202024-orange)
![Target](https://img.shields.io/badge/FPGA-Artix--7%20xc7a35t-green)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A from-scratch implementation of a 32-bit single-cycle RISC-V processor
(RV32I base integer ISA) in SystemVerilog, built as part of the
**Government of Pakistan IC Design & Verification Cohort 1** program.

---

## Project Overview

This repository documents the step-by-step construction of a
single-cycle RV32I processor, including all datapath components,
the control unit, and a full system integration testbench.

**Supported instructions (target):**
- R-type: ADD, SUB, AND, OR, SLT
- I-type: ADDI, LW
- S-type: SW
- B-type: BEQ
- J-type: JAL

---

## Repository Structure
riscv-single-cycle-cpu/
├── rtl/              # Synthesisable SystemVerilog modules
│   ├── pc/           # Program counter
│   ├── mux/          # Parameterised multiplexers
│   ├── alu/          # ALU + ALU control
│   ├── adder/        # PC+4 and branch adders
│   ├── instruction_memory/
│   ├── register_file/
│   ├── data_memory/
│   ├── control_unit/
│   ├── sign_extend/
│   └── top/          # Full CPU integration
├── tb/               # Testbenches
├── sim/              # Waveforms and logs
├── docs/             # Architecture diagrams and notes
└── constraints/      # Vivado XDC files
---

## Datapath Architecture

![Datapath](docs/architecture/datapath_diagram.png)

*Single-cycle RV32I datapath — IF → ID → EX → MEM → WB*

---

## Modules Status

| Module | File | Status | Testbench |
|--------|------|--------|-----------|
| Program Counter | `rtl/pc/program_counter.sv` | ✅ Done | ✅ |
| Parameterised MUX | `rtl/mux/mux2to1.sv` | ✅ Done | ✅ |
| Adder | `rtl/adder/adder.sv` | ✅ Done | ✅ |
| Instruction Memory | `rtl/instruction_memory/instr_mem.sv` | ✅ Done | ✅ |
| ALU | `rtl/alu/alu.sv` | 🔄 In progress | ⏳ |
| ALU Control | `rtl/alu/alu_control.sv` | ⏳ Pending | ⏳ |
| Register File | `rtl/register_file/reg_file.sv` | ⏳ Pending | ⏳ |
| Data Memory | `rtl/data_memory/data_mem.sv` | ⏳ Pending | ⏳ |
| Control Unit | `rtl/control_unit/control_unit.sv` | ⏳ Pending | ⏳ |
| Sign Extend | `rtl/sign_extend/sign_extend.sv` | ⏳ Pending | ⏳ |
| CPU Top | `rtl/top/riscv_top.sv` | ⏳ Pending | ⏳ |

---

## Weekly Progress

| Week | Topic | Status |
|------|-------|--------|
| Week 1 | Digital Design, FSMs, Combinational Circuits | ✅ Complete |
| Week 2 | SystemVerilog Basics, Parameterised Modules | ✅ Complete |
| Week 3 | RISC-V ISA, Single-cycle IF-ID, EX-MEM | 🔄 In Progress |
| Week 4 | Full CPU simulation, Pipeline introduction | ⏳ Pending |
| Week 5 | AXI-Lite, Embedded C | ⏳ Pending |
| Week 6 | HAL drivers, Cache basics | ⏳ Pending |

---

## Tools Used

- **Simulator:** Vivado xsim
- **Synthesis Target:** Artix-7 xc7a35t
- **Language:** SystemVerilog (IEEE 1800-2012)
- **Reference:** Patterson & Hennessy — Computer Organization
  and Design: RISC-V Edition

---

## Key References

- [RISC-V ISA Specification](https://riscv.org/specifications/ratified/)
- Patterson & Hennessy, Computer Organization and Design: RISC-V Edition
- GoP IC Design & Verification Cohort 1 curriculum

---

## Author

**Ali** — Embedded Systems & IC Design Engineer
- Cohort: Government of Pakistan IC Design & Verification — Cohort 1
- Background: Embedded Systems, FPGA, PCB Design, Quantum Photonics Research
- LinkedIn: [your-linkedin-url]
- Email: [your-email]

---

## License

MIT License — free to use, modify, and distribute with attribution.