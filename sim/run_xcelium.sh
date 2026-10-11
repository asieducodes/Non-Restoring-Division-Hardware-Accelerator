#!/bin/bash

# Navigate to the root directory of the repository
cd ..

echo "=== Starting Xcelium Compilation & Simulation ==="

# Using irun (single-command flow similar to qrun) or standard xrun
xrun -gui -access +rwc \
    -top tb \
    rtl/nrd_typedefs.sv \
    rtl/nrd_components.sv \
    rtl/nrd_alu.sv \
    rtl/nrd_control_unit.sv \
    rtl/nrd_datapath.sv \
    rtl/nrd_top.sv \
    testbench/tb_nrd_top.sv

echo "=== Xcelium Session Finished ==="