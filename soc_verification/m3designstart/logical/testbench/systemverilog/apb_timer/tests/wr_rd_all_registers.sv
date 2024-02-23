 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     wr_rd_all_registers
 //Filename:   wr_rd_all_registers.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//===================================================
// Test_case_1
//===================================================
class wr_rd_all_registers extends apb_timer_test;
  `uvm_component_utils(wr_rd_all_registers)
  
  virtual_test_case_1  vir_tc_1;
  
  extern function new(string name="wr_rd_all_registers",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function wr_rd_all_registers:: new(string name="wr_rd_all_registers",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void wr_rd_all_registers::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  
 
 ////run phase
 
  task wr_rd_all_registers::run_phase(uvm_phase phase);
   phase.raise_objection(this);
    vir_tc_1=virtual_test_case_1::type_id::create("vir_tc_1");
    vir_tc_1.start(env_p.virtual_seqr);
   phase.drop_objection(this);
  endtask 
