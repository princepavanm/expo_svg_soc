//**********************************************************
// Author:     Abhishek
// Module:     reset_driver
// Filename:   reset_driver.sv
// Start Date: 
// Finish Date:
//**********************************************************/

class reset_driver extends uvm_driver#(apb_txn);
  `uvm_component_utils(reset_driver)
  //config 
  reset_agent_config reset_agent_cfg;
  
  // interface
   virtual apb_timer_if vif;
   // methods 
   
  extern function new(string name="reset_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task reset();
endclass

// construct the reset_driver class

  function reset_driver::new(string name="reset_driver",uvm_component parent);
    super.new(name,parent);
  endfunction 

//========================================================================================
// connect_phase(connecting the agent 'VIF' wit driver 'VIF')
//========================================================================================    
  function void reset_driver ::connect_phase(uvm_phase phase);
    vif=reset_agent_cfg.vif; 
  endfunction

// build_phase 

  function void reset_driver:: build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(reset_agent_config)::get(this,"","reset_agent_config",reset_agent_cfg))
      `uvm_fatal("RESET_CONFIG","reset_virtual_config")
  endfunction 
  
// run_phase
task reset_driver::run_phase(uvm_phase phase);
 forever
    begin
     seq_item_port.get_next_item(req);
     reset();
     seq_item_port.item_done(req);
    end
endtask

// reset_phase
task reset_driver::reset();

begin
     if(req.presetn)
                begin
                       vif.apb_driver_cb.presetn<=1'b1;
		       @(vif.apb_driver_cb);
                end
     else
                begin
                       vif.apb_driver_cb.presetn<=1'b0;
		       @(vif.apb_driver_cb);
                end
end

endtask 
 

  
