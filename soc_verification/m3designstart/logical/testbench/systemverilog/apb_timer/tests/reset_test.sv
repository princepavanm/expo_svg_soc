 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     reset_sequence
 //Filename:   reset_sequence.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//=====================================================================================
// reset_sequence
//=====================================================================================
class reset_test extends apb_timer_test;
  `uvm_component_utils(reset_test)
  
  virtual_test_case_8  vir_tc_8;
  
  extern function new(string name="reset_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function reset_test:: new(string name="reset_test",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void reset_test::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task reset_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
    vir_tc_8=virtual_test_case_8::type_id::create("vir_tc_8");
    vir_tc_8.start(env_p.virtual_seqr);
  phase.drop_objection(this);
  endtask 
  
