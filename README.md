# Dynamic Pipeline Design and Quantitative Performance Analysis

This repository documents a project for the "Computer System Architecture" course at Tongji University. It details the design, implementation, and analysis of a processor featuring dynamic scheduling, out-of-order execution, and in-order commit, based on the Tomasulo algorithm.

> **Course:** Computer System Architecture
> **Project:** Dynamic Pipeline Design and Quantitative Performance Analysis
> **Institution:** Tongji University

## 🚀 Project Overview

Traditional 5-stage static pipelines (IF, ID, EX, MEM, WB) suffer from significant performance degradation due to stalls caused by data hazards (RAW, WAR, WAW) and control hazards. These stalls severely limit the processor's ability to exploit Instruction-Level Parallelism (ILP).

This project overcomes these limitations by implementing a dynamically scheduled processor. It allows for Out-of-Order Execution (OoOE) to maximize the utilization of functional units while using a Reorder Buffer (ROB) to ensure instructions commit in-order, thereby maintaining precise exceptions.

## 🔬 Architectural Design: Tomasulo Algorithm

The core architecture is based on the Tomasulo algorithm, which utilizes **Reservation Stations (RS)** and a **Reorder Buffer (ROB)** to replace traditional pipeline registers. This design facilitates register renaming and resolves data hazards dynamically.

### Key Pipeline Stages & Components

1.  **Instruction Fetch (IF):**
    * Fetches instructions from the Instruction Memory (`my_IMEM`).

2.  **Instruction Decode / Issue:**
    * Decodes the instruction.
    * Checks for a free slot in both the corresponding **Reservation Station (RS)** and the **Reorder Buffer (ROB)**.
    * If available, the instruction is issued to the RS, and an entry is allocated in the ROB.
    * **Register Renaming:** The destination register is mapped to the allocated ROB entry. Source operands are either read from the register file (if ready) or tagged with the ROB entry ID that will produce the value.

3.  **Reservation Stations (RS):**
    * Instructions wait in the RS for their operands.
    * Each RS entry holds the opcode, the values of ready operands (V), and the tags of pending operands (Q, pointing to a ROB entry).
    * RSs "snoop" the CDB for their required operands, updating their V and Q fields accordingly.
    * This is the core mechanism for resolving **RAW (Read After Write) hazards**.

4.  **Execute (EX):**
    * Once all operands for an instruction in an RS are ready (all V fields are valid), the instruction is dispatched to its corresponding functional unit (e.g., ALU, Load/Store unit).

5.  **Write-Back (WB):**
    * The result from the functional unit is broadcast over the **Common Data Bus (CDB)**.
    * The result includes the computed value and its corresponding ROB tag.
    * All RS and ROB entries waiting for this tag capture the value.

6.  **Commit:**
    * The **Reorder Buffer (ROB)** tracks all "in-flight" instructions.
    * The ROB ensures instructions commit **in-order**. The instruction at the head of the ROB can only commit once it has completed execution and is free of exceptions.
    * Upon commit, the result is permanently written to the Register File or Data Memory (`my_DMEM`).
    * This mechanism guarantees precise exceptions and resolves **WAR (Write After Read)** and **WAW (Write After Write) hazards**.

### Core Verilog Modules

* `my_cpu`: The top-level CPU module, instantiating and connecting all sub-modules.
* `ROB`: Implements the Reorder Buffer.
* `RS` (or `ALU_RS`, `LS_RS`): Implements the Reservation Stations for different functional units.
* `CDB`: The Common Data Bus (typically multiplexers and broadcast logic).
* `my_IMEM`: Instruction Memory.
* `my_DMEM`: Data Memory (as shown in the report).

## 📊 Quantitative Performance Analysis

A key objective of this project was to **quantitatively** prove the advantages of this dynamic pipeline.

* **Methodology:**
    1.  Develop benchmark programs containing various hazards (e.g., loops with serial data dependencies, Load-Use hazards).
    2.  Run these programs using a Verilog Testbench in the Vivado simulator.
    3.  Execute the benchmarks on both the implemented **dynamic pipeline** and a control **static pipeline**.

* **Key Performance Metric:**
    * **CPI (Cycles Per Instruction):** The average number of clock cycles required to execute one instruction.
    * **Total Execution Cycles:** The total time to run the program.

* **Conclusion:**
    * By comparing the CPI data, this project quantifies the significant reduction in stall cycles and the improvement in functional unit utilization achieved by dynamic scheduling, thereby validating its superior performance over a static pipeline.

## 🛠️ Tech Stack & Tools

* **Hardware Description Language:** Verilog HDL
* **Simulation & Synthesis:** Xilinx Vivado 2019.2
* **Target Hardware Platform:** Xilinx Artix-7 (Part: `xc7a35tcsg324-1`)


## 🧑‍💻 Author Information

* **Author:** Yifei Wang
* **Date:** December 2023
