/***********************************************************
Author 		: Ramkumar 
File 		: slave_agent.sv
Module name     : slave_agent 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class slave_agent extends uvm_agent;
	 `uvm_component_utils(slave_agent)

// Declare the all the component handle
slave_monitor monitor_h;
slave_driver driver_h;
slave_sequencer seqr_h;
slave_config slave_cfg;
//************************methods and functions***********************
extern function new (string name="slave_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass:slave_agent


//*******************************Constructor*******************************
function slave_agent :: new (string name="slave_agent",uvm_component parent);
	 super.new(name,parent);

endfunction:new

//*******************************Build_phase*******************************
function void slave_agent ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(slave_config)::get(this,"","slave_config",slave_cfg))
	`uvm_fatal("slave AGENT","Unable to get slave config in slave agent")
	monitor_h=slave_monitor::type_id::create("monitor_h",this);
	if(slave_cfg.IS_ACTIVE)
	begin
		driver_h=slave_driver::type_id::create("driver_h",this);
		seqr_h=slave_sequencer::type_id::create("seqr_h",this);
	end

endfunction:build_phase

//*****************************connect_phase*******************************
function void slave_agent ::connect_phase(uvm_phase phase);
	 super.connect_phase(phase);
	 if(slave_cfg.IS_ACTIVE)
		 driver_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction:connect_phase

