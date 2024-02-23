 ////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_agent_config
 //Filename:   timer_agent_config.sv
 //Start Date: 24/10/2017
 /////////////////////////////////////////////////////////////
 
class timer_agent_config extends uvm_object;
  `uvm_object_utils(timer_agent_config)
  
  // active or passive components from top 
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  // virtual interface 
  virtual apb_timer_if vif;

 // signal for tracking the driver transactions 
 // static bit count_timer_driver_xtn=1'b0;
 // signal for tracking the monitor transactions
 // static bit count_timer_monitor_xtn=1'b0;
   
  extern function new(string name="timer_agent_config");
  
endclass:timer_agent_config
    
  //construct the class 
    
    function timer_agent_config::new(string name="timer_agent_config");
      super.new(name);
    endfunction 
