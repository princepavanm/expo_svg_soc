 ////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_agent
 //Filename:   timer_agent.sv
 //Start Date: 24/10/2017
 /////////////////////////////////////////////////////////////

class timer_agent extends uvm_agent;
  `uvm_component_utils(timer_agent)
  
  timer_sequencer timer_seqr;
  timer_driver timer_drv;
  timer_monitor timer_mon;
  timer_agent_config timer_agent_cfg;
  
  extern function new(string name="timer_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
    
endclass:timer_agent
    
    
    function timer_agent::new(string name="timer_agent",uvm_component parent);
      super.new(name,parent);
    endfunction
//=====================================================================
//build_phase
//=====================================================================
    
    function void timer_agent::build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(timer_agent_config)::get(this,"","timer_agent_config",timer_agent_cfg))
      	`uvm_fatal("AGENT","config unsuccessful")
      	
      	//Monitor is always present
        timer_mon=timer_monitor::type_id::create("timer_mon",this);
        
      		if(timer_agent_cfg.is_active==UVM_ACTIVE)
      		  
      		  // build the driver and sequencer if active
        		begin 
                  timer_seqr = timer_sequencer::type_id::create("timer_seqr",this);
                  timer_drv = timer_driver::type_id::create("timer_drv",this);
           		end
   
    endfunction 
//=====================================================================
//connect_phase
//=======================================================================
    
    function void timer_agent::connect_phase(uvm_phase phase);
      if(timer_agent_cfg.is_active==UVM_ACTIVE)
        begin 
          timer_drv.seq_item_port.connect(timer_seqr.seq_item_export);
         end
    endfunction 
