class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  apb_sequencer apb_seqr, apb_dummy_seqr;
  apb_driver apb_drv;
  apb_monitor apb_mon;
  apb_agent_config apb_agent_cfg;
  //apb_scoreboard apb_sb;
  
  extern function new(string name="apb_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
    
endclass:apb_agent
    
    
    function apb_agent::new(string name="apb_agent",uvm_component parent);
      super.new(name,parent);
    endfunction
//=====================================================================
//build_phase
//=====================================================================
    
    function void  apb_agent::build_phase(uvm_phase phase);
      super.build_phase(phase);

      if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",apb_agent_cfg))
      	`uvm_fatal("Timer Agent","config unsuccessful")
      	
      	//Monitor is always present, so create monitor
        apb_mon=apb_monitor::type_id::create("apb_mon",this);
        apb_dummy_seqr=apb_sequencer::type_id::create("apb_dummy_seqr",this);
	
        //building the sequencer and driver
      	if(apb_agent_cfg.is_active==UVM_ACTIVE)
      		  
      	 // build the driver and sequencer if active
        	begin 
                  apb_seqr=apb_sequencer::type_id::create("apb_seqr",this);
                  apb_drv=apb_driver::type_id::create("apb_drv",this);
                 // apb_sb=apb_scoreboard::type_id::create("apb_cb",this);
        	end
   
    endfunction 
//=====================================================================
//connect_phase
//=======================================================================
    
    function void apb_agent::connect_phase(uvm_phase phase);
      if(apb_agent_cfg.is_active==UVM_ACTIVE)
        begin 
          apb_drv.seq_item_port.connect(apb_seqr.seq_item_export);
         // if(apb_agent_cfg.has_apb_scoreboard)
//            begin
//              apb_drv.driver_port.connect(apb_sb.apb_driver_fifo.analysis_export);
//              apb_mon.monitor_port.connect(apb_sb.apb_monitor_fifo.analysis_export);
//            end
  /*To print out the current component hierarchy of a testbench, the print_topology() function can be called.*/
          uvm_top.print_topology();
        end
    endfunction 
    
