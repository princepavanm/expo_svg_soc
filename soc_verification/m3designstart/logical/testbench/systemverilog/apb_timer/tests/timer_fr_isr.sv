 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_fr_isr
 //Filename:   timer_fr_isr.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//=====================================================================================
// Test_case_7
//=====================================================================================
class timer_fr_isr extends apb_timer_test;
  `uvm_component_utils(timer_fr_isr)
  
  virtual_test_case_7  vir_tc_7;
  
  extern function new(string name="timer_fr_isr",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function timer_fr_isr:: new(string name="timer_fr_isr",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void timer_fr_isr::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task timer_fr_isr::run_phase(uvm_phase phase);
  phase.raise_objection(this);
    vir_tc_7=virtual_test_case_7::type_id::create("vir_tc_7");
    vir_tc_7.start(env_p.virtual_seqr);
  phase.drop_objection(this);
  endtask 
