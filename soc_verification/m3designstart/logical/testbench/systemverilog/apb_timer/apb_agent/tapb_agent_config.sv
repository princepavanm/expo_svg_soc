 ////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI	
 //Module:     apb_agent_config
 //Filename:   apb_agent_config.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////
class apb_agent_config extends uvm_object;
  `uvm_object_utils(apb_agent_config)
  
  // active or passive components from top 
  // bit has_apb_scoreboard=1;
  uvm_active_passive_enum is_active=UVM_PASSIVE;
  
  // virtual interface 
  virtual apb_timer_if vif;

  // signal for tracking the driver transactions 
  // static bit count_apb_driver_xtn=1'b0;

  // signal for tracking the monitor transactions
  // static bit count_apb_monitor_xtn=1'b0;
  extern function new(string name="apb_agent_config");
  
endclass:apb_agent_config
    
  //construct the class 
    
function apb_agent_config::new(string name="apb_agent_config");
      super.new(name);
endfunction 
