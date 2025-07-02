
# 9-bit Custom Processor on FPGA

A fully functional 9-bit processor designed in Verilog, featuring a register file, custom ALU, state machine control unit, and memory interface. Built and tested using Quartus Prime, this processor supports a minimal instruction set including arithmetic, move, immediate load, and a special multiply-by-3.5 operation.

---

## 🚀 Features

- **9-bit architecture**: Every data path and register is 9 bits wide
- **Instruction format**: 9-bit word split as [Opcode (3) | RX (3) | RY (3)]
- **Instructions supported**:
  - `000`: Move register to register (MV)
  - `001`: Move immediate value (MVI)
  - `010`: ADD
  - `011`: SUB
  - `101`: Multiply by 3.5 (special ALU op)
- **State machine**: Each instruction runs over 2–4 clock cycles
- **Modules implemented**:
  - ALU (add, sub, mult3.5)
  - Register file with decoder (1-hot selection)
  - Instruction register, state machine controller
  - Memory interface
- **Testbench includes**:
  - One-by-one instruction verification
  - Full program test (e.g., multistep computation + result store)

---

## 📁 File Structure

```
9bit-cpu/
├── rtl/
│   ├── procc.v              # CPU top module
│   ├── regn.v               # Register bank
│   ├── addsub.v             # ALU subunit
│   ├── my_mem.v             # Simple memory module
│   ├── counter.v            # Clock cycle counter
│   ├── dec3to8.v            # Decoder (binary to one-hot)
│   ├── muxsmthng2one.v      # Multi-input bus selector
│   └── top_module.v         # Integration & test wiring
├── docs/
│   ├── arch_diagram.png     # Architecture/block diagram
│   ├── instruction_table.png
│   └── waveforms.png
├── sim/
│   └── processor_tb.v       # Testbench
└── README.md
```

---

## 📺 Demonstration

Watch the simulation + run-through of all instructions on hardware:  
▶️ [Processor Demo (Part 1)](https://drive.google.com/file/d/14kSA2327gG_4DtvX3HMasfiHiJe4agZJ/view?usp=drivesdk)  
▶️ [Processor Demo (Part 2)](https://drive.google.com/file/d/1jSxJ8sZcDnfIQWQrdA4je1Z-06DxiBFG/view?usp=drivesdk)

---

## 🧪 Simulation & Testing

- All instructions tested individually
- Final integration test includes:
  - MVI → MV → ADD → MUL3.5 → SUB → MV to final reg
- Validated with waveform inspection in ModelSim

---

## 📐 Architecture Overview

- FSM controls instruction decode and operation sequencing
- ALU computes 3.5 × RY using `RY << 1 + RY >> 1`
- One-hot decoder for register selection
- Each instruction completes in 2–4 cycles

---

## 🧠 Lessons Learned

- Register aliasing handled with strict one-hot decoding
- FSM design enables efficient instruction pipelining
- Signal timing and waveform correctness critical in multi-stage ops
