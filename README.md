# RISC-V Single-Cycle Processor (RV32I)

![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Tool](https://img.shields.io/badge/Tool-Vivado%202018.2-orange)
![Target](https://img.shields.io/badge/FPGA-Artix--7%20xc7a35t-green)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A fully verified from-scratch implementation of a 32-bit single-cycle RISC-V processor (RV32I subset) in SystemVerilog, built as part of the **Government of Pakistan IC Design & Verification Cohort 1** program.

---

## Project Overview

This repository implements a single-cycle RV32I processor where every instruction completes in exactly one clock cycle. The processor executes a test program that initializes a 5-element integer array in data memory and computes their sum, verifying the complete datapath end-to-end.

**Test program result:** `t2 (x7) = 25 + 12 + 48 + 7 + 31 = 123`

---

## Supported Instructions

| Instruction | Type   | Opcode  | funct3 | funct7  | Operation                    |
|-------------|--------|---------|--------|---------|------------------------------|
| `ADDI`      | I-type | 0010011 | 000    | —       | rd = rs1 + imm               |
| `SLLI`      | I-type | 0010011 | 001    | —       | rd = rs1 << shamt            |
| `LW`        | I-type | 0000011 | 010    | —       | rd = Mem[rs1 + imm]          |
| `SW`        | S-type | 0100011 | 010    | —       | Mem[rs1 + imm] = rs2         |
| `ADD`       | R-type | 0110011 | 000    | 0000000 | rd = rs1 + rs2               |
| `SUB`       | R-type | 0110011 | 000    | 0100000 | rd = rs1 - rs2               |
| `AND`       | R-type | 0110011 | 111    | 0000000 | rd = rs1 & rs2               |
| `OR`        | R-type | 0110011 | 110    | 0000000 | rd = rs1 \| rs2              |
| `BEQ`       | B-type | 1100011 | 000    | —       | if(rs1==rs2) PC = PC + imm   |

---

## Architecture

### Datapath Overview

```
         +------------------+
         |       pc         |<------- pc_next (from mux)
         +--------+---------+
                  | pc_out
         +--------+---------+     +----------+
         | instructionMemory|     | pcadder  | --> pc_out + 4
         +--------+---------+     +-----+----+          |
                  | inst               |           +----v------+
         +--------v---------+          |           |  mux2X1   |<-- and_out
         |   control_path   |          +---------->| (pc_sel)  |<-- addershifted
         | immediateGenerator          |           +----+------+
         |   registerData   |          |                |
         +--+----------+----+          |           pc_next
            |data1  data2| immout      |
            |       +----v------+      |
            |       |  mux2X1   |<-- alu_scr
            |       | (alu_sel) |
            |       +-----+-----+
         +--v---+         | alu_in
         |      |<--------+
         | ALU  |
         +--+---+
            | alu_out    | Zero
            |        +---v------+
            |        | andGate  |<-- branch
            |        +---+------+
            |            | and_out --> pc_sel mux
         +--v-----------+
         | data_memory  |
         +--+-----------+
            | dmem_out
         +--v---------+
         |   mux2X1   |<-- mem2reg
         | (wb_sel)   |
         +--+---------+
            | data_write --> registerData (write back)
```

### Machine Type

This is a **Moore machine** - output depends only on current state, not on input:

```
Z = f(current state only)     Moore
Z = f(current state, input)   Mealy (not used here)
```

### Three-Block RTL Structure

Every module follows this standard pattern:

```
Block 1 → State Register     always @(posedge clk)     sequential
Block 2 → Next State Logic   always @(*) or assign     combinational
Block 3 → Output Logic       assign                    combinational
```

---

## Module List

| Module               | File                       | Description                                       |
|----------------------|----------------------------|---------------------------------------------------|
| `riscv_top`          | `rtl/riscv_top.sv`         | Top-level - connects all 12 modules               |
| `pc`                 | `rtl/pc.sv`                | 32-bit program counter, synchronous reset         |
| `pcadder`            | `rtl/pcadder.sv`           | Computes PC + 4                                   |
| `addershifted`       | `rtl/addershifted.sv`      | Computes PC + imm (branch target)                 |
| `instructionMemory`  | `rtl/instr_mem.sv`         | 32-entry instruction ROM with test program        |
| `registerData`       | `rtl/registerData.sv`      | 32 x 32-bit register file, asynchronous read      |
| `immediateGenerator` | `rtl/immediateGenerator.sv`| Sign-extends immediates for I, S, B-type          |
| `control_path`       | `rtl/control_path.sv`      | Main control unit - decodes opcode                |
| `alu_control`        | `rtl/alu_control.sv`       | ALU decoder - uses alu_op, funct3, funct7         |
| `alu`                | `rtl/alu.sv`               | 32-bit ALU supporting 9 operations                |
| `andGate`            | `rtl/andGate.sv`           | Branch decision: branch AND Zero                  |
| `mux2X1`             | `rtl/mux2X1.sv`            | 32-bit 2:1 multiplexer (3 instances in top)       |
| `data_memory`        | `rtl/data_memory.sv`       | 256 x 32-bit data memory                         |

---

## ALU Operations

| alu_ctrl | Operation | Triggered By                    |
|----------|-----------|---------------------------------|
| 0000     | AND       | R-type funct3=111               |
| 0001     | OR        | R-type funct3=110               |
| 0010     | ADD       | ADDI, LW, SW, R-type ADD        |
| 0011     | SLLI      | I-type funct3=001               |
| 0101     | XOR       | R-type funct3=100               |
| 0110     | SUB       | BEQ, R-type funct3=000 funct7=1 |
| 0111     | SLT       | R-type funct3=010               |
| 1000     | SGT       | R-type funct3=011               |
| 1100     | NOR       | R-type funct3=101               |

---

## Control Signals

| Signal      | LW | ADDI | SW | BEQ | R-type | Description                          |
|-------------|:--:|:----:|:--:|:---:|:------:|--------------------------------------|
| `reg_write` | 1  |  1   | 0  |  0  |   1    | Enable register file write           |
| `alu_scr`   | 1  |  1   | 1  |  0  |   0    | ALU operand B: 0=register 1=immediate|
| `mem_write` | 0  |  0   | 1  |  0  |   0    | Enable data memory write             |
| `mem_rd`    | 1  |  0   | 0  |  0  |   0    | Enable data memory read              |
| `mem2reg`   | 1  |  0   | 0  |  0  |   0    | Writeback: 0=ALU result 1=memory     |
| `branch`    | 0  |  0   | 0  |  1  |   0    | Instruction is a branch              |
| `alu_op`    | 00 |  00  | 00 | 01  |   10   | Sent to ALU control unit             |

---

## Immediate Generator

The `immediateGenerator` module reconstructs sign-extended 32-bit immediates from scattered instruction bits:

```
I-type:  immout = { {20{inst[31]}}, inst[31:20] }

S-type:  immout = { {20{inst[31]}}, inst[31:25], inst[11:7] }

B-type:  immout = { {19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 }
```

> The `1'b0` appended in B-type means `immout` already contains the full byte offset.
> No left shift is needed in `addershifted` — `addsh_out = pc_out + imm_out` is correct as written.

---

## PC Addressing

RISC-V is byte addressed. Instructions are 32-bit (4 bytes) wide.
The instruction memory array is word indexed:

```
inst = mem[pc_out >> 2];
```

```
PC value    →  mem index
0x00000000  →  mem[0]    first instruction
0x00000004  →  mem[1]    second instruction
0x00000008  →  mem[2]    third instruction
```

`>> 2` divides by 4, converting byte address to word index.

---

## Test Program

Stored as hardcoded values in `instructionMemory`:

```assembly
; --- Store array {25, 12, 48, 7, 31} in data memory ---
addi  t0, x0, 0       ; t0 = 0   base address
addi  t1, x0, 25
sw    t1,  0(t0)       ; mem[0]  = 25
addi  t1, x0, 12
sw    t1,  4(t0)       ; mem[4]  = 12
addi  t1, x0, 48
sw    t1,  8(t0)       ; mem[8]  = 48
addi  t1, x0, 7
sw    t1, 12(t0)       ; mem[12] = 7
addi  t1, x0, 31
sw    t1, 16(t0)       ; mem[16] = 31

; --- Initialize loop variables ---
addi  t2, x0, 0       ; t2 = 0  sum
addi  t3, x0, 0       ; t3 = 0  i
addi  t4, x0, 5       ; t4 = 5  size

; --- Loop ---
loop:
beq   t3, t4, done    ; if i == size goto done
slli  t5, t3,  2      ; t5 = i * 4  (byte offset)
add   t6, t0, t5      ; t6 = base + offset
lw    t1,  0(t6)      ; t1 = array[i]
add   t2, t2, t1      ; sum += array[i]
addi  t3, t3,  1      ; i++
beq   x0, x0, loop    ; unconditional jump to loop

; --- Done ---
done:
beq   x0, x0, done    ; infinite loop
```

### Machine Code

| Address | Hex          | Assembly                    |
|---------|--------------|-----------------------------|
| 0x00    | `00000293`   | `addi t0, x0, 0`            |
| 0x04    | `01900313`   | `addi t1, x0, 25`           |
| 0x08    | `0062A023`   | `sw t1, 0(t0)`              |
| 0x0C    | `00C00313`   | `addi t1, x0, 12`           |
| 0x10    | `0062A223`   | `sw t1, 4(t0)`              |
| 0x14    | `03000313`   | `addi t1, x0, 48`           |
| 0x18    | `0062A423`   | `sw t1, 8(t0)`              |
| 0x1C    | `00700313`   | `addi t1, x0, 7`            |
| 0x20    | `0062A623`   | `sw t1, 12(t0)`             |
| 0x24    | `01F00313`   | `addi t1, x0, 31`           |
| 0x28    | `0062A823`   | `sw t1, 16(t0)`             |
| 0x2C    | `00000393`   | `addi t2, x0, 0`            |
| 0x30    | `00000E13`   | `addi t3, x0, 0`            |
| 0x34    | `00500E93`   | `addi t4, x0, 5`            |
| 0x38    | `01DE0E63`   | `beq t3, t4, done (+28)`    |
| 0x3C    | `002E1F13`   | `slli t5, t3, 2`            |
| 0x40    | `01E28FB3`   | `add t6, t0, t5`            |
| 0x44    | `000FB303`   | `lw t1, 0(t6)`              |
| 0x48    | `006383B3`   | `add t2, t2, t1`            |
| 0x4C    | `001E0E13`   | `addi t3, t3, 1`            |
| 0x50    | `FE0004E3`   | `beq x0, x0, loop (-24)`    |
| 0x54    | `00000063`   | `beq x0, x0, done (0)`      |

---

## Simulation

Run `tb_riscv_top.sv` in Vivado behavioral simulation.

The testbench monitors every signal on every clock edge and prints final register values:

```
─────────────────────────────────
Simulation complete
─────────────────────────────────
t2  (sum)  = 123 (expect 123)
t3  (i)    = 5   (expect 5)
t4  (size) = 5   (expect 5)
─────────────────────────────────
```

---

## Bugs Fixed During Development

| Bug | Root Cause | Fix |
|-----|------------|-----|
| SLLI always outputting 0 | `alu_op=00` path in `alu_control` always gave ADD, never checked funct3 | Added `if(funct3==3'b001)` check inside `alu_op=00` case |
| BEQ jumping to wrong address | `beq t3, t4, done` encoded as `0x03DE0E63` (offset=60) instead of `0x01DE0E63` (offset=28) | Corrected bit[25] in B-type instruction encoding |
| LW always loading from address 0 | SLLI bug caused `t5=0` every iteration so `t6 = t0 + 0 = 0` always | Fixed as a consequence of SLLI fix |

---

## Key Design Decisions

| Decision | Explanation |
|----------|-------------|
| Synchronous reset | Reset only takes effect on `posedge clk` — single `always @(posedge clk)` block in `pc` |
| Asynchronous read | Register file and data memory read combinationally without clock |
| Moore machine | Output `Z` depends only on current state — no input term in output equation |
| No shift in `addershifted` | `immediateGenerator` appends `1'b0` at LSB for B-type so `addershifted` needs no `<< 1` |
| `addr >> 2` | Converts byte address to word index — RISC-V is byte addressed but memory is word indexed |
| `funct3` and `funct7` as separate inputs to `alu_control` | Cleaner interface — extracted in `riscv_top` and passed directly, not re-extracted inside module |

---

## Repository Structure

```
## Repository Structure

​```
riscv_single_cycle_cpu/
├── rtl/
│   ├── adder/
│   │   └── adder.sv
│   ├── adder_shifted/
│   │   └── addershifted.sv
│   ├── alu/
│   │   └── alu.sv
│   ├── alu_ctrl/
│   │   └── alu_control.sv
│   ├── andGate/
│   │   └── andGate.sv
│   ├── control_path/
│   │   └── control_path.sv
│   ├── data_memory/
│   │   └── data_memory.sv
│   ├── immediateGenerator/
│   │   └── immediateGenerator.sv
│   ├── instruction_memory/
│   │   └── instr_mem.sv
│   ├── mux/
│   │   ├── mux2X1.sv
│   │   └── mux_param.sv
│   ├── pc/
│   │   └── pc.sv
│   ├── pcadder/
│   │   └── pcadder.sv
│   ├── registerData/
│   │   └── registerData.sv
│   └── riscv_top/
│       └── riscv_top.sv
├── tb/
│   ├── tb_riscv_top.sv
│   ├── tb_riscv_top.sv
│   ├── adder_tb.sv
│   ├── tb_addershifted.sv
│   ├── tb_alu.sv
│   ├── tb_alu_control.sv
│   ├── tb_andGate.sv
│   ├── tb_control_path.sv
│   ├── tb_data_memory.sv
│   ├── tb_immediateGenerator.sv
│   ├── tb_instr_mem.sv
│   ├── tb_mux2X1.sv
│   ├── tb_pcadder.sv
│   ├── tb_registerData.sv
│   └── mux_param_tb.sv
├── mem/
│   └── program.hex
├── .gitignore
├── LICENSE
└── README.md
​```
```

---

## Tools Used

| Tool | Version | Purpose |
|------|---------|---------|
| Xilinx Vivado | 2018.2 | Synthesis and behavioral simulation |
| Vivado xsim | 2018.2 | Waveform verification |
| FPGA target | Artix-7 xc7a35t | Synthesis target |
| Language | SystemVerilog IEEE 1800-2012 | RTL and testbench |

---

## References

- [RISC-V ISA Specification (ratified)](https://riscv.org/specifications/ratified/)
- Patterson & Hennessy — Computer Organization and Design: RISC-V Edition
- [RISC-V Online Assembler](https://riscvasm.lucasteske.dev/)
- [rvcodec.js — Instruction Encoder/Decoder](https://luplab.gitlab.io/rvcodecjs/)

---

## Author

**Ali Raza** — Embedded Systems and IC Design Engineer

- Program: Government of Pakistan IC Design and Verification Cohort 1
- Background: Embedded Systems, FPGA Development, PCB Design, Quantum Photonics Research
- GitHub: [github.com/raza091](https://github.com/raza091)

---

## License

MIT License — free to use, modify, and distribute with attribution.
