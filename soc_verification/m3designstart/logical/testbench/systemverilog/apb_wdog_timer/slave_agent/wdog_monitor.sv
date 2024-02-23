/***********************************************************
Author 		: Ramkumar 
File 		: slave_monitor.sv
Module name     : slave_monitor 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class slave_monitor extends uvm_monitor;
	 `uvm_component_utils(slave_monitor)

//Declare the TLM port
virtual apb_if.WATCHDOG_MONITOR vif;
slave_config monitor_cfg;
uvm_analysis_port #(slave_trans) monport;
slave_trans slave_xtn;
slave_trans cov_data;

uvm_event_pool eve_pool;

uvm_event eve;

//Declaring covergroup for write transaction
covergroup cg_wdog;
	option.per_instance=1;
interrupt: coverpoint cov_data.wdogint {
				bins low = {0};
				bins high = {1};
				}
reset: coverpoint cov_data.wdogres {
				bins low = {0};
				bins high = {1};
				}
endgroup

//************************methods and functions***********************
extern function new (string name="slave_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass:slave_monitor


//*******************************Constructor*******************************
function slave_monitor :: new (string name="slave_monitor",uvm_component parent);
	 super.new(name,parent);
	 eve_pool=new();
	 eve_pool=eve_pool.get_global_pool();
	 eve=eve_pool.get("Interrupt");
	 //creating a covergroup
	cg_wdog=new();
endfunction:new

//*******************************Build_phase*******************************
function void slave_monitor ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(slave_config)::get(this,"","slave_config",monitor_cfg))
	`uvm_fatal("SLAVE DRIVER","Unable to get slave config in monitor")

slave_xtn=slave_trans::type_id::create("slave_xtn");
//creating the modport
monport=new("monport",this);
endfunction:build_phase

//*******************************Connect_phase*********************************
function void slave_monitor::connect_phase(uvm_phase phase);
`uvm_info("SLAVE MONITOR","///////Connect phase////////",UVM_MEDIUM)
vif=monitor_cfg.vif;
endfunction

//*******************************Run_phase*********************************
task slave_monitor ::run_phase(uvm_phase phase);
$display("INSIDE_TASK");
@(vif.wdog_monitor_cb)
     fork
       begin
	       $display("BEFORE WAIT IN TASK");
	wait(vif.wdog_monitor_cb.wdogint==1'b1)
      $display("AFTER WAIT IN TASK");	
	slave_xtn.wdogint=vif.wdog_monitor_cb.wdogint;
	cov_data=slave_xtn;
	`uvm_info("SLAVE MONITOR",$sformatf("\nDATA Printing From Slave Monitor",slave_xtn.sprint()),UVM_LOW)
	eve.trigger();
	$display("AFTER EVE.TRIGGER");
	monport.write(slave_xtn);
	cg_wdog.sample();
	end

	begin
	wait(vif.wdog_monitor_cb.wdogres==1'b1)
	slave_xtn.wdogint=1'b0;
	slave_xtn.wdogres=vif.wdog_monitor_cb.wdogres;
	cov_data=slave_xtn;
	 `uvm_info("SLAVE MONITOR",$sformatf("\nPrinting From Slave Monitor",slave_xtn.sprint()),UVM_LOW)
	 cg_wdog.sample();
	 end
     join
     
endtask:run_phase


