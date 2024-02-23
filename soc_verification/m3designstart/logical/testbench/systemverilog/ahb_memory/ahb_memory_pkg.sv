package ahb_memory_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   `include "master_xtn.sv"


   //REG_BLOCK
   `include "uvm_mem.sv"
   `include "../systemverilog/ahb_memory/sram_block.sv"
   `include "sadapter.sv"

   `include "ahb_agent_config.sv"
   `include "senv_config.sv"

   `include "master_driver.sv"
   `include "master_monitor.sv"
   `include "master_sequencer.sv"
   `include "master_agent.sv"
   //`include "master_sequence.sv"



   //`include "virtual_sequencer.sv"
   //`include "virtual_sequence.sv"

   `include "senv.sv"
   //`include "test.sv"
endpackage
