 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     extin_disable_while_counting
 //Filename:   extin_disable_while_counting.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//=====================================================================================
// Test_case_5(reading INTTERUPT STATUS value registers)
//=====================================================================================
class extin_disable_while_counting extends apb_timer_test;
  `uvm_component_utils(extin_disable_while_counting)
  
  virtual_test_case_5  vir_tc_5;
  
  extern function new(string name="extin_disable_while_counting",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function extin_disable_while_counting:: new(string name="extin_disable_while_counting",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void extin_disable_while_counting::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task extin_disable_while_counting::run_phase(uvm_phase phase);
        phase.raise_objection(this);
    vir_tc_5=virtual_test_case_5::type_id::create("vir_tc_5");
    vir_tc_5.start(env_p.virtual_seqr);
    
   //#20000;
    phase.drop_objection(this);
  endtask 
