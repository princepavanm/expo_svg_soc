 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     pid_cid_default_checks
 //Filename:   pid_cid_default_checks.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

//=====================================================================================
// Test_case_4(reading CTRL value registers)
//=====================================================================================
class pid_cid_default_checks extends apb_timer_test;
  `uvm_component_utils(pid_cid_default_checks)
  
  virtual_test_case_4  vir_tc_4;
  

  
  extern function new(string name="pid_cid_default_checks",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function pid_cid_default_checks:: new(string name="pid_cid_default_checks",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void pid_cid_default_checks::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

 ////run phase
 
  task pid_cid_default_checks::run_phase(uvm_phase phase);
    phase.raise_objection(this);
       vir_tc_4=virtual_test_case_4::type_id::create("vir_tc_4");
       vir_tc_4.start(env_p.virtual_seqr);
    phase.drop_objection(this);
  endtask 
  
