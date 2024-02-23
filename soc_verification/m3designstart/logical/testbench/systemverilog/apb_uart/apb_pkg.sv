`ifdef original
	`define has_reset 0
`else
	`define has_reset 1
`endif
`timescale 1ns/1ps

package apb_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"

//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/define.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/enum.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_xtn.sv"
`include "define.sv"
`include "enum.sv"
`include "apb_xtn.sv"
//`include "uart_xtn.sv"

//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/uvm_reg.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/uvm_reg_block.sv"
`include "uvm_reg.sv"
`include "uvm_reg_block.sv"

//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_agent/apb_agent_config.sv"
`include "./apb_agent/apb_agent_config.sv"
//`include "uart_agent_config.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/env_config.sv"
`include "env_config.sv"
//`include "uart_sequence.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_sequence.sv"


//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_agent/apb_call_back.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_agent/apb_driver.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_agent/apb_monitor.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_agent/apb_sequencer.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/apb_agent/apb_agent.sv"
`include "./apb_agent/apb_call_back.sv"
`include "./apb_agent/apb_driver.sv"
`include "./apb_agent/apb_monitor.sv"
`include "./apb_agent/apb_sequencer.sv"
`include "./apb_agent/apb_agent.sv"

//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/adapter.sv"
`include "adapter.sv"

//`include "uart_driver.sv"
//`include "uart_monitor.sv"
//`include "uart_sequencer.sv"
//`include "uart_agent.sv"
//`include "virtual_sequencer.sv"
//`include "virtual_sequence.sv"

//`include "scoreboard.sv"
//`include "/home/sravanthi/Desktop/soc_verification/m3designstart/logical/testbench/systemverilog/apb_uart/env.sv"
`include "env.sv"
//`include "test_pkg.sv"
endpackage
