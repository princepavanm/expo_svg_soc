////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     wr_rd_timer_registers
 //Filename:   wr_rd_timer_registers.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//=====================================================
// Test_case_3(reading reload value registers)
//=====================================================
class wr_rd_timer_registers extends apb_timer_test;
  `uvm_component_utils(wr_rd_timer_registers)
  
  virtual_test_case_3  vir_tc_3;
  
  extern function new(string name="wr_rd_timer_registers",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function wr_rd_timer_registers:: new(string name="wr_rd_timer_registers",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void wr_rd_timer_registers::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task wr_rd_timer_registers::run_phase(uvm_phase phase);
        phase.raise_objection(this);
    vir_tc_3=virtual_test_case_3::type_id::create("vir_tc_3");
    vir_tc_3.start(env_p.virtual_seqr);
    #1000;
    phase.drop_objection(this);
  endtask 
