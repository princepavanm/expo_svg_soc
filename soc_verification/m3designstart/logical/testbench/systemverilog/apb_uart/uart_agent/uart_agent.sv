/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart agent class
 Filename:   	uart_agent.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_agent extends uvm_agent;
  `uvm_component_utils(uart_agent)

// Environment config Handle
   uart_agent_config s_cfg;   

// Component handles
  uart_driver driver;
  uart_monitor monitor;
  uart_sequencer sequencer;

// Analysis port for data broadcast  
  uvm_analysis_port #(uart_xtn) uart_monitor_port;
  
//****************************Methods****************************  
extern function new(string name="uart_agent", uvm_component parent);  
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass:uart_agent

//**************************Constructor**************************
function uart_agent::new(string name="uart_agent", uvm_component parent);
  super.new(name,parent);
uart_monitor_port= new("apb_monitor_port",this);
endfunction:new

//**************************Build_phase**************************
function void uart_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  //connect interfcae
   if(!uvm_config_db #(uart_agent_config)::get(this,"*","uart_agent_config",s_cfg))
    `uvm_fatal("AGENT_CONFIG","get interface to agent")
  
	monitor=uart_monitor::type_id::create("monitor",this);
      
      if(s_cfg.is_active==UVM_ACTIVE)
	begin
          sequencer=uart_sequencer::type_id::create("sequencer",this);
          driver=uart_driver::type_id::create("driver",this);
	end

endfunction:build_phase

//************************connect_phase**************************
function void uart_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(s_cfg.is_active==UVM_ACTIVE)
    begin
// Connection between sequencer and driver
    driver.seq_item_port.connect(sequencer.seq_item_export);

// connecting monitor and agent analysis port
    monitor.uart_monitor_port.connect(uart_monitor_port);
   end

endfunction:connect_phase
