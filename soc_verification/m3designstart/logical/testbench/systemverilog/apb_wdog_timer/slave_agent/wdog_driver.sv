/***********************************************************
Author 		: Ramkumar 
File 		: slave_driver.sv
Module name     : slave_driver 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class slave_driver extends uvm_driver#(slave_trans);
	 `uvm_component_utils(slave_driver)
virtual apb_if.WATCHDOG_DRIVER vif;
slave_config driver_cfg;
//************************methods and functions***********************
extern function new (string name="slave_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(slave_trans xtn);
endclass:slave_driver


//*******************************Constructor*******************************
function slave_driver :: new (string name="slave_driver",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void slave_driver ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(slave_config)::get(this,"","slave_config",driver_cfg))
	`uvm_fatal("SLAVE DRIVER","Unable to get slave config in driver")
endfunction:build_phase

//*******************************Connect_phase*********************************
function void slave_driver::connect_phase(uvm_phase phase);
`uvm_info("SLAVE DRIVER","///////Connect phase////////",UVM_MEDIUM)
vif=driver_cfg.vif;
endfunction

//*******************************Run_phase*********************************
task slave_driver ::run_phase(uvm_phase phase);
forever
	begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done();
	end
endtask:run_phase

`ifdef original
task slave_driver::send_to_dut(slave_trans xtn);
if(!xtn.wdogresn)
begin
@(vif.wdog_driver_cb)
vif.wdog_driver_cb.wdogresn<=1'b0;
@(vif.wdog_driver_cb)
vif.wdog_driver_cb.wdogresn<=1'b1;
end
else 
begin
vif.wdog_driver_cb.wdogresn<=1'b1;

@(vif.wdog_driver_cb)
if(xtn.wdogclken)
	vif.wdog_driver_cb.wdogclken<=xtn.wdogclken;
	vif.wdog_driver_cb.wdogresn<=xtn.wdogresn;
`uvm_info("SLAVE DRIVER",$sformatf("\nPrinting From Slave Driver",xtn.sprint()),UVM_LOW)
end
endtask
`else
task slave_driver::send_to_dut(slave_trans xtn);
begin
@(vif.wdog_driver_cb)
if(xtn.wdogclken)
	vif.wdog_driver_cb.wdogclken<=xtn.wdogclken;
`uvm_info("SLAVE DRIVER",$sformatf("\nPrinting From Slave Driver",xtn.sprint()),UVM_LOW)
end
endtask
`endif
