 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     reload_value_change
 //Filename:   reload_value_change.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//=====================================================================================
// Test_case_6
//=====================================================================================
class reload_value_change extends apb_timer_test;
  `uvm_component_utils(reload_value_change)
  
  virtual_test_case_6  vir_tc_6;
  
  extern function new(string name="reload_value_change",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function reload_value_change:: new(string name="reload_value_change",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void reload_value_change::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task reload_value_change::run_phase(uvm_phase phase);
   phase.raise_objection(this);
    vir_tc_6=virtual_test_case_6::type_id::create("vir_tc_6");
    vir_tc_6.start(env_p.virtual_seqr);
  phase.drop_objection(this);
  endtask 
