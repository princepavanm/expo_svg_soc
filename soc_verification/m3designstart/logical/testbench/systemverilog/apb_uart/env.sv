/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart_environment class
 Filename:   	uart_env.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/
class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

// Environment configuration handle for set config   
  uart_env_config uart_env_cfg;

// Component Handles  
  apb_agent magent;
  apb_agent_config apb_agt_cfg;
  //uart_agent sagent;
  //virtual_sequencer vsqr;
  //scoreboard sb;

  reg_adapter adapter_h;
  
  uvm_reg_predictor#(apb_xtn) predictor_h;
  

//**************************Methods****************************
  extern function new(string name="uart_env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
endclass:uart_env

//************************Constructor**************************
function uart_env::new(string name="uart_env",uvm_component parent);
  super.new(name,parent);
endfunction:new


//************************Build_phase**************************
function void uart_env::build_phase(uvm_phase phase);
  
   super.build_phase(phase);
//get interface from uart_enviornment config or else through fatal error 
 if (!uvm_config_db#(uart_env_config)::get(this,"*","uart_env_config",uart_env_cfg))
   `uvm_fatal("ENV_CONFIG","get interface to uart_environment handle")
	apb_agt_cfg = apb_agent_config::type_id::create("apb_agt_cfg",this);
	apb_agt_cfg.vif=uart_env_cfg.vif;
	apb_agt_cfg.IS_ACTIVE=UVM_PASSIVE;
   
   magent = apb_agent::type_id::create("magent",this);
   uvm_config_db#(apb_agent_config)::set(this,"*","apb_agent_config",apb_agt_cfg);
   
   

	predictor_h = uvm_reg_predictor#(apb_xtn)::type_id::create("predictor_h",this);
	
	//Adapter creation
	adapter_h = reg_adapter::type_id::create("adapter_h",this);



endfunction:build_phase

//***************************Connect_phase*****************************
function void uart_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  begin
	  `uvm_info("UART Environment", "...........Connect phase.......","UVM_MEDIUM")
  end
 
  // if(uart_env_cfg.apb_rb.get_parent== null) begin
//	uart_env_cfg.apb_rb.apb_map.set_sequencer(.sequencer(vsqr.sqr),.adapter(adapter_h));
//	end

	predictor_h.map = uart_env_cfg.apb_rb.apb_map;
	predictor_h.adapter = adapter_h;
	uart_env_cfg.apb_rb.apb_map.set_auto_predict(1);
	magent.mon.apb_monitor_port.connect(predictor_h.bus_in);	
endfunction:connect_phase

function void uart_env::report_phase(uvm_phase phase);
uvm_report_server reportserver = uvm_report_server::get_server();

`uvm_info(get_type_name(),">>>>>>>>>>>>>>>>>>>>>>>>>>>TEST_STATUS",UVM_MEDIUM)

assert(reportserver.get_severity_count(UVM_FATAL) == 0 && reportserver.get_severity_count(UVM_ERROR) == 0)

begin

`uvm_info (get_type_name(),">>>>>>>UART : NO UVM ERRORS>>>>>>>>",UVM_MEDIUM)

end
else
begin

`uvm_info (get_type_name(),">>>>>>>UART : UVM ERRORS>>>>>>>>>",UVM_MEDIUM)

end
endfunction


