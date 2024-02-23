////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     psel_penable_combinations
 //Filename:   psel_penable_combinations.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//===============================================
// Test_case_2
//===============================================
class apb_error_test extends apb_timer_test;
  `uvm_component_utils(apb_error_test)
  
  virtual_test_case_2  vir_tc_2;
  
  extern function new(string name="apb_error_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function apb_error_test:: new(string name="apb_error_test",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void apb_error_test::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task apb_error_test::run_phase(uvm_phase phase);
   phase.raise_objection(this);
    vir_tc_2=virtual_test_case_2::type_id::create("vir_tc_2");
    vir_tc_2.start(env_p.virtual_seqr);
   phase.drop_objection(this);
  endtask 
