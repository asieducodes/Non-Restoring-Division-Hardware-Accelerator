#!/bin/bash

# Navigate to the root directory of the repository so paths resolve correctly
cd ..

echo "=== Starting QuestaSim Compilation & Simulation via qrun ==="

# Run qrun pointing to the typedefs, rtl files, and testbench
qrun +acc -gui -debugdb -top tb \
    rtl/nrd_typedefs.sv \
    rtl/nrd_components.sv \
    rtl/nrd_alu.sv \
    rtl/nrd_control_unit.sv \
    rtl/nrd_datapath.sv \
    rtl/nrd_top.sv \
    testbench/tb_nrd_top.sv

echo "=== QuestaSim Session Finished ==="