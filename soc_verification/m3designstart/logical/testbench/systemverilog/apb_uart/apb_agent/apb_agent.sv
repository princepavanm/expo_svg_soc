/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb agent class
 Filename:   	apb_agent.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

// Environment config handle
  apb_agent_config m_cfg; 

// Component handles 
  apb_sequencer sqr,uart_dummy_sqr;
  apb_driver drv;
  apb_monitor mon;

  driver_callback cb;
  
// Analysis port for data broadcast
  //uvm_analysis_port #(apb_xtn) apb_monitor_port;
 
  
//*******************************Methods*************************************
  extern function new(string name="apb_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  `ifdef original
  `else
	  extern task run_phase(uvm_phase phase);
  `endif
endclass:apb_agent

//*****************************Constructor***********************************
function apb_agent :: new(string name="apb_agent", uvm_component parent);
  super.new(name,parent);
  cb=new("cb");
  //apb_monitor_port= new("apb_monitor_port",this);
endfunction:new

//*****************************Build_phase***********************************
function void apb_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(apb_agent_config)::get(this,"*","apb_agent_config",m_cfg))
    `uvm_fatal("AGENT_CONFIG","get interface to agent")
    
  mon=apb_monitor::type_id::create("mon",this);
  uart_dummy_sqr=apb_sequencer::type_id::create("uart_dummy_sqr",this);
  
   if(m_cfg.IS_ACTIVE)
	begin
  	  sqr=apb_sequencer::type_id::create("sqr",this);
  	  drv=apb_driver::type_id::create("drv",this);
	end
   uvm_callbacks #(apb_driver,driver_callback)::add(drv,cb);

endfunction:build_phase

//*****************************Connect_phase**********************************
function void apb_agent ::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(m_cfg.IS_ACTIVE)
    begin

// Connection between sequencer and driver
  drv.seq_item_port.connect(sqr.seq_item_export);
    end
   
endfunction:connect_phase

`ifdef original
`else
	task apb_agent::run_phase(uvm_phase phase);
		phase.raise_objection(this);
		super.run_phase(phase);
		phase.drop_objection(this);
	endtask
`endif


