/**********************************************************
 Author:     Abhishek
 Module:     reset_agent_config
 Filename:   reset_agent_config.sv
 Start Date: 
 Finish Date:
**********************************************************/

class reset_agent_config extends uvm_object;
  `uvm_object_utils(reset_agent_config)
  
  // active or passive components from top 
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  // virtual interface 
  virtual apb_timer_if vif;
  // signal for tracking the driver transactions 
  bit has_asynchronous_reset=1;    // for 1 =asynchronous  & 0=synchronous
  // signal for tracking the monitor transactions
    
  extern function new(string name="reset_agent_config");
  
endclass
    
  //construct the class 
    
    function reset_agent_config::new(string name="reset_agent_config");
      super.new(name);
    endfunction 
    
