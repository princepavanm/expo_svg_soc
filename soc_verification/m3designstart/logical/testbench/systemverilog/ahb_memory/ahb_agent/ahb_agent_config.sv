class master_agent_config extends uvm_object;
  `uvm_object_utils(master_agent_config)
  
  // active or passive components from top 
 // bit has_ahb_scoreboard=1;
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  // virtual interface 
virtual AHB_SRAM_if vif0;
  // signal for tracking the driver transactions 
  static bit count_ahb_driver_xtn=1'b0;
  // signal for tracking the monitor transactions
  static bit count_ahb_monitor_xtn=1'b0;
   
  extern function new(string name="master_agent_config");
  
endclass
    
  //construct the class 
    
    function master_agent_config::new(string name="master_agent_config");
      super.new(name);
    endfunction 
    
