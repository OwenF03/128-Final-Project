# 128-Final-Project

# Owen Funk, David Riley, Sophia Pham

## Description

Design and test an 8 function calculator, outputting the operation and result to the four seven segment displays on the Basys 3 FPGA. The design was implemented and tested using AMD Vivado 2023.1.

## Instructions to run

Download all of the provided files and create a new project using AMD Vivado 2023.1, and select the Xilinx Artic-7 FPGA (XC7A35T-ICPG236C) as the board. Add the module files (all .v files that don't end in tb) as design sources, the .xdc file as constratint sources, and the .v files that end with tb as simulation sources. The specific sources for each problem are listed below. 

# File Breakdown

## Design sources 
* Calculator_top.v -- Top module that interfaces all submodules
* Calculator.v -- Calculator module that handles OP code and produces result
* Debouncer.v -- Debouncer module for each of the raw button inputs
* Multi_Driver.v -- Drives values to seven segment display
* val_bcd.v -- Converts raw 12 bit binary value to 16 bit BCD
* bcd_seg.v -- Converts 16 bit BCD value to 32 bit 7-segment output
* op_seg.v -- Converts 3 bit op code to 32 bit 7-segment output
* cla_adder.v -- Carry look ahead adder
* combo_mult.v -- Combinational multiplier
* edge.v -- Pulse generator for debounced button signals




## Simulation sources
* Calculator_tb.v -- Tests raw calculator output
* Calc_top_tb.v -- Tests Calculator top module and entire system interfacing/output
* edge_gen_tb.v -- Tests the edge pulse generator 


## Constraints
* Constraints.xdc -- Constraints for the physical board
