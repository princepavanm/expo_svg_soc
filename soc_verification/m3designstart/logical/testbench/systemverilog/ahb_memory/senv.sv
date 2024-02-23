//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_ENV
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class senv extends uvm_env;
  `uvm_component_utils(senv)
  
  master_agent magenth;
  master_agent_config ahb_agent_cfg_h;
  senv_config senv_cfg_h;
  reg_adapter adapter_h;
  uvm_reg_predictor#(master_AHB_xtn) predictor_h;

  //***extern methods*************************************
  extern function new(string name="senv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void report();
endclass

//********************************* constructor **********************************************************
function senv::new(string name="senv", uvm_component parent);
super.new(name,parent);
endfunction

//*********************************Build phase************************************************************
function void senv::build_phase(uvm_phase phase);
if(!uvm_config_db #(senv_config)::get(this,"","senv_config",senv_cfg_h))
	`uvm_fatal("ENV_CONFIG","cannot get() senv config from uvm_config")
   ahb_agent_cfg_h = master_agent_config ::type_id::create("ahb_agent_cfg_h");
   ahb_agent_cfg_h.vif0 = senv_cfg_h.vif0;
   ahb_agent_cfg_h.is_active=UVM_PASSIVE;

magenth=master_agent::type_id::create("m_a_top",this);
uvm_config_db #(master_agent_config)::set(this,"*","master_agent_config",ahb_agent_cfg_h);

  super.build_phase(phase);
	predictor_h = uvm_reg_predictor#(master_AHB_xtn)::type_id::create("predictor_h",this);
				//Adapter creation
	adapter_h = reg_adapter::type_id::create("adapter_h",this);
  endfunction

//*********************************connect phase***********************************************************
function void senv::connect_phase(uvm_phase phase);

//senv_cfg_h.ahb_reg_block_h.ahb_map.set_sequencer(.sequencer(master_seqr), .adapter(adapter_h));
predictor_h.map = senv_cfg_h.blk.ahb_map;

predictor_h.adapter = adapter_h;

senv_cfg_h.blk.ahb_map.set_auto_predict(1);

magenth.monh.monitor_port.connect(predictor_h.bus_in);
endfunction

//*********************************Report for checking error************************************************
function void senv::report();
uvm_report_server reportserver=uvm_report_server::get_server();
report_header();
report_summarize();

if(reportserver.get_severity_count(UVM_FATAL)==0 && reportserver.get_severity_count(UVM_ERROR)==0)
begin
  $display("~~~~~~SRAM0 NO UVM ERRORS ~~~~~~~~~~~~~~");
end
else
begin
   $display("~~~~~~SRAM0 UVM ERRORS ~~~~~~~~~~~~~~");
  
end
endfunction
 
