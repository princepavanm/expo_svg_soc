 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     apb_timer_test
 //Filename:   apb_timer_test.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////

class apb_timer_test extends uvm_test;
  `uvm_component_utils(apb_timer_test)
  
  env env_p;
  
  apb_agent_config       apb_agent_cfg;
  //timer_agent_config     timer_agent_cfg;
  //reset_agent_config     reset_agent_cfg;
  
  env_config       env_cfg; 
  reg_block        blk;


  extern function new(string name="apb_timer_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass:apb_timer_test 

//======================================================================
//construction of apb_timer_test
//======================================================================
function apb_timer_test::new(string name="apb_timer_test",uvm_component parent);
  super.new(name,parent);
endfunction

//======================================================================
//build_phase(creating all the configuration objects in test for better)
//======================================================================

function void apb_timer_test:: build_phase(uvm_phase phase);
 super.build_phase(phase);
 env_cfg=env_config::type_id::create("env_cfg");
 
// master_agent_config creation 
     if(env_cfg.has_apb_agent)
       begin 
         apb_agent_cfg=apb_agent_config::type_id::create("apb_agent_cfg");
           if(!uvm_config_db#(virtual apb_timer_if)::get(this,"","vif",apb_agent_cfg.vif))
            `uvm_fatal("VIRTUAL_INTERFACE","getting unsuccessful")
             apb_agent_cfg.is_active=UVM_PASSIVE;
             env_cfg.apb_agent_cfg=apb_agent_cfg;
       end

// slave_agent_config creation 
/*
     if(env_cfg.has_timer_agent)
      begin
        timer_agent_cfg=timer_agent_config::type_id::create("timer_agent_cfg");
          if(!uvm_config_db#(virtual apb_timer_if)::get(this,"","vif",timer_agent_cfg.vif))
            `uvm_fatal("VIRTUAL_INTERFACE","FATAL")
            timer_agent_cfg.is_active=UVM_ACTIVE;
            env_cfg.timer_agent_cfg=timer_agent_cfg;
      end

// reset_agent_config 
     if(env_cfg.has_reset_agent)
       begin 
     	reset_agent_cfg=reset_agent_config::type_id::create("reset_agent_cfg");
	  if(!uvm_config_db#(virtual apb_timer_if)::get(this,"","vif",reset_agent_cfg.vif))
	    `uvm_fatal("VIRTUAL_INTERFACE","getting unsuccessful")
	     reset_agent_cfg.is_active=UVM_ACTIVE;
	     env_cfg.reset_agent_cfg=reset_agent_cfg;
       end
 */
  // environment creation 
  env_p=env::type_id::create("env_p",this);
  blk=reg_block::type_id::create("blk");
  blk.build();
  env_cfg.blk = blk;     
  
  // env_config setting 
  uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
endfunction

// extend the base test to create register test
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
