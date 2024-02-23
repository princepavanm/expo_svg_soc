class reset_agent extends uvm_agent;
	 `uvm_component_utils(reset_agent)

	// Declare the all the component handle
	//reset_monitor monitor_h;
	reset_driver driver_h;
	reset_sequencer seqr_h;
	reset_config reset_cfg;

	//************************methods and functions***********************
	extern function new (string name="reset_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass:reset_agent


//*******************************Constructor*******************************
function reset_agent :: new (string name="reset_agent",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void reset_agent ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

	//Get config_db
	if(!uvm_config_db #(reset_config)::get(this,"","reset_config",reset_cfg))
		`uvm_fatal("RESET AGENT","Unable to get reset config in reset agent")
	if(reset_cfg.IS_ACTIVE)
	begin
		driver_h=reset_driver::type_id::create("driver_h",this);
		seqr_h=reset_sequencer::type_id::create("seqr_h",this);
	end
endfunction:build_phase

//*****************************connect_phase*******************************
function void reset_agent ::connect_phase(uvm_phase phase);
	 super.connect_phase(phase);
	 if(reset_cfg.IS_ACTIVE)
		 driver_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction:connect_phase



