
//===============================================
// Test_case_9
//===============================================
class register_test extends apb_timer_test;
  `uvm_component_utils(register_test)
  
  register_vir     vir;
  extern function new(string name="register_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
   
  function register_test:: new(string name="register_test",uvm_component parent);
    super.new(name,parent);
 endfunction
 
 
function void register_test::build_phase(uvm_phase phase);
     super.build_phase(phase);
endfunction  

  task register_test::run_phase(uvm_phase phase);
   phase.raise_objection(this);
    vir=register_vir::type_id::create("vir");
    vir.start(env_p.virtual_seqr);
   phase.drop_objection(this);
  endtask 
