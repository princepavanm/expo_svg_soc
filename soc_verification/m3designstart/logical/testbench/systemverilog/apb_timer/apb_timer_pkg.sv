 /////////////////////////////////////////
 //Author:     ABHISHEK EEMANI	
 //Module:     apb_timer_package 
 //Filename:   apb_timer_pkg.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////
 


package apb_timer_pkg;
  
  import uvm_pkg::*;
  reg [31:0]temp_pwdata;
  reg [31:0]temp_prdata; 

  `include "uvm_macros.svh"
  `include "defs.sv"
  
  `include "apb_sequence_item.sv"

 //RAL Classes 
  `include "reg.sv"
  `include "reg_block.sv"
  `include "tadapter.sv"

  `include "tapb_agent_config.sv"
  //`include "timer_agent_config.sv"
 // `include "reset_agent_config.sv"
  `include "tenv_config.sv"
 // `include "reset_driver.sv"
  `include "tapb_driver.sv"
  `include "tapb_monitor.sv"
  
 // `include "reset_sequencer.sv"
  `include "tapb_sequencer.sv"
  //`include "apb_scoreboard.sv"
  
  //`include "reset_agent.sv"
  `include "tapb_agent.sv"

  //`include "reset_sequence.sv"
  //`include "apb_sequence.sv"
 // `include "env.sv"
  //`include "apb_timer_test.sv"
/* 
  `include "timer_txn.sv"
  `include "timer_monitor.sv"
  `include "timer_sequencer.sv"
  `include "timer_sequence.sv"
  `include "timer_driver.sv"
  `include "timer_agent.sv"
  `include "virtual_sequencer.sv"
  `include "virtual_sequence.sv"
  


  // Test cases
  `include "wr_rd_all_registers.sv"
  `include "apb_error_test.sv"
  `include "extin_disable_while_counting.sv"
  `include "pid_cid_default_checks.sv"
  `include "reload_value_change.sv"
  `include "timer_fr_isr.sv"
  `include "wr_rd_timer_registers.sv"
  `include "reset_test.sv"
*/
 // `include "ral_test.sv"
 `include "tenv.sv"

endpackage








