/***********************************************************
Author 		: Ramkumar 
File 		: master_agent.sv
Module name     : master_agent 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class master_agent extends uvm_agent;
	 `uvm_component_utils(master_agent)

// Declare the all the component handle
master_monitor monitor_h;
master_driver driver_h;
master_sequencer seqr_h,wdog_dummy_seqr;
master_config master_cfg;
// Declare the handle of callback class
driver_callback cb;

//uvm_domain domain1; //declaration of domain for phase jumping
//************************methods and functions****************
extern function new (string name="master_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
`ifdef original
`else
extern task run_phase(uvm_phase phase);
`endif
endclass:master_agent


//*******************************Constructor*******************************
function master_agent :: new (string name="master_agent",uvm_component parent);
	 super.new(name,parent);
//create the callback 
	cb=new("cb");
endfunction:new

//*******************************Build_phase*******************************
function void master_agent ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(master_config)::get(this,"","master_config",master_cfg))
	`uvm_fatal("APB WDOG AGENT","Unable to get master config in apb wdog agent")
	monitor_h=master_monitor::type_id::create("monitor_h",this);
        wdog_dummy_seqr=master_sequencer::type_id::create("wdog_dummy_seqr",this);
	if(master_cfg.IS_ACTIVE)
	begin
		driver_h=master_driver::type_id::create("driver_h",this);
		seqr_h=master_sequencer::type_id::create("seqr_h",this);
	end
//Add the callback with respect to given component
uvm_callbacks #(master_driver,driver_callback)::add(driver_h,cb);

//domain1 = new("domain1"); //creating domain for phase jumping
//driver_h.set_domain(domain1); //setting domain to environment
endfunction:build_phase

//*****************************connect_phase*******************************
function void master_agent ::connect_phase(uvm_phase phase);
	 super.connect_phase(phase);
	 if(master_cfg.IS_ACTIVE)
		 driver_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction:connect_phase

`ifdef original
`else
task master_agent::run_phase(uvm_phase phase);
phase.raise_objection(this);
super.run_phase(phase);
		//@(e);
		//begin
		//	$display("@%0tin agent for jumping",$time);
		//	domain1.jump(uvm_reset_phase::get()); //jumping from main phase to reset phase 
		//end
		/*#30;
		//domain1.jump(uvm_shutdown_phase::get()); //jumping from reset phase to check phase*/
phase.drop_objection(this);
endtask
`endif

