
`ifdef original
	`define has_reset 0
`else
	`define has_reset 1
`endif
`timescale 1ns/1ps 

package apb_watchdog_pkg;

import uvm_pkg::*;

//import "DPI-C" task import_task(int count);
event e;
event a;

`include "uvm_macros.svh"


//Config files
`include "apb_agent_config.sv"
//`include "wdog_agent_config.sv"
//`include "reset_agent_config.sv"

//REGBLOCK
`include "uvm_reg.sv"
`include "uvm_reg_block.sv"

`include "wtenv_config.sv"
//Master side
`include "apb_xtn.sv"

//`include "apb_sequence.sv"
`include "apb_callback.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_sequencer.sv"
`include "apb_agent.sv"
//`include "apb_master_top.sv"
//Regsequence
//`include "reg_sequence.sv"

//Adapter
`include "adapter.sv"

//Slave side
/*`include "wdog_xtn.sv"
`include "wdog_sequence.sv"
`include "wdog_driver.sv"
`include "wdog_monitor.sv"
`include "wdog_sequencer.sv"
`include "wdog_agent.sv"
`include "wdog_slave_top.sv"

//Reset side
`include "reset_tnx.sv"
`include "reset_seq.sv"
`include "reset_drv.sv"
//`include "reset_monitor.sv"
`include "reset_sqr.sv"
`include "reset_agent.sv"
`include "reset_top.sv"

`include "seq_lib.sv"
//Virtual sequence & sequencer
`include "virtual_sequencer.sv"
`include "virtual_sequence.sv"

`include "user_phase.sv"
//Top component
`include "scoreboard.sv"
*/
`include "wtenv.sv"

endpackage
