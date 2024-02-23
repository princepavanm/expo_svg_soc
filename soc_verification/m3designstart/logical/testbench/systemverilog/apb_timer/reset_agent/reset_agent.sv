/**********************************************************
 Author:     Abhishek
 Module:     RESET_AGENT
 Filename:   reset_agent.sv
 Start Date: 
 Finish Date:
**********************************************************/

class reset_agent extends uvm_agent;
  `uvm_component_utils(reset_agent)
  
  reset_sequencer reset_seqr;
  reset_driver  reset_drv;
  reset_agent_config reset_agent_cfg;
  
  extern function new(string name="reset_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

// construct the class

function reset_agent::new(string name="reset_agent",uvm_component parent);
  super.new(name,parent);
endfunction 


// build_phase

function void reset_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(reset_agent_config)::get(this,"","reset_agent_config",reset_agent_cfg))
      	`uvm_fatal("AGENT","config unsuccessful")
  if(reset_agent_cfg.is_active==UVM_ACTIVE)
    begin 
      reset_seqr=reset_sequencer::type_id::create("reset_seqr",this);
      reset_drv=reset_driver::type_id::create("reset_drv",this);
    end
endfunction 

// connect_phase

function void reset_agent::connect_phase(uvm_phase phase);
   if(reset_agent_cfg.is_active==UVM_ACTIVE)
     begin 
      reset_drv.seq_item_port.connect(reset_seqr.seq_item_export);
     end
endfunction 


