 ////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_driver
 //Filename:   timer_driver.sv
 //start date: 23/10/2017 
 ////////////////////////////////////////////////////////////
 
class timer_driver extends uvm_driver#(timer_txn);
  `uvm_component_utils(timer_driver)
   
   virtual apb_timer_if.TIMER_DRIVER vif;
   timer_agent_config timer_agent_cfg;
  
  extern function new(string name="timer_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase); 
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(timer_txn txn);
  
endclass:timer_driver

/////------driver class construction ------/////
function timer_driver::new(string name="timer_driver",uvm_component parent);
  super.new(name,parent);
endfunction

//========================================================================================
// build phase of driver
//========================================================================================    
function void timer_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  begin
  if(!uvm_config_db#(timer_agent_config)::get(this,"","timer_agent_config",timer_agent_cfg))
    `uvm_fatal("TIMER_DRIVER","TIMER agent getting unsuccessful")
  end
endfunction

//========================================================================================
// connect_phase(connecting the agent 'VIF' wit driver 'VIF')
//========================================================================================    
function void timer_driver::connect_phase(uvm_phase phase);
  vif = timer_agent_cfg.vif;
endfunction

task timer_driver::run_phase(uvm_phase phase);
 @(vif.timer_driver_cb); 
 @(vif.timer_driver_cb); 
   forever
  
  begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
  
endtask

task timer_driver::send_to_dut(timer_txn txn);
  $display("=========================TIMER_DRIVER===============================");
  `uvm_info("TIMER DRIVER",$sformatf("printing from TIMER \n %s",req.sprint()),UVM_LOW);
	  begin  
	    vif.timer_driver_cb.extin <=txn.extin;
	    @(vif.timer_driver_cb);
	    txn.Timerint=vif.timer_driver_cb.Timerint;
	    	  end
	    @(vif.timer_driver_cb);
endtask
  
     
