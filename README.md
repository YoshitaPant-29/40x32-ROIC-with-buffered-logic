# FSM-Based Digital Control for 40×32 ROIC Using Verilog with Buffered Timing Logic

This project implements a Verilog-based digital controller for a **40×32 Readout Integrated Circuit (ROIC)** using a **Finite State Machine (FSM)** and **shift-register-based column and row scanning**. The design emulates the behavior of a larger 640×512 ROIC architecture but is scaled down to 40×32 for simulation and waveform verification.

The digital controller systematically enables each pixel in a row-column matrix using precise timing control and sequential logic. A **buffered logic scheme** is integrated to mimic the real-time constraints typically encountered in infrared imaging systems.

---

## 🧠 Buffered Timing Logic (Explained)

Unlike simple scan controllers that activate columns immediately, this implementation introduces **timing buffers** before and after each row and column operation:

- **Column Activation**:
  - 4 clock cycles **delay before** activating `col[0]`
  - 40 columns are **sequentially enabled**, one per clock
  - 4 clock cycles **delay after** the last column is scanned

- **Row Activation**:
  - Each row is held active (`row_enable[x] = 1`) for the full 48 clock cycles (4 + 40 + 4)
  - A 4-clock **gap (LOW)** is introduced between row transitions

This buffered logic helps ensure clean synchronization between column scanning and analog signal acquisition (simulated behavior of ROIC → ADC interface).

---

## 🧪 Project Highlights

- Resolution: **40 columns × 32 rows**
- Clock frequency: **10 MHz** (100 ns period)
- Design written in **Verilog HDL**
- Functional verification via **testbench** and waveform simulation
- Ready for extension to **640×512** architecture

---

## 📂 Files Included

- `design.v` – FSM-based controller with buffered timing
- `tb.v` – Testbench simulating row/column scan
- `design.vcd` – Optional VCD waveform file for GTKWave
