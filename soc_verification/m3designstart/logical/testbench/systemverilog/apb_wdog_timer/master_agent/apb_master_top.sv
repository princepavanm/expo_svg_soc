/***********************************************************
Author 		: Ramkumar 
File 		: master_agent_top.sv
Module name     : master_agent_top 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class master_agent_top extends uvm_env;
  `uvm_component_utils(master_agent_top)
  master_agent agent_h;
  wtenv_config m_cfg;
  extern function new(string name="master_agent_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass

function master_agent_top:: new(string name="master_agent_top",uvm_component parent);
  super.new(name,parent);
endfunction

function void master_agent_top::build_phase(uvm_phase phase);
  if(!uvm_config_db #(wtenv_config)::get(this,"","wtenv_config",m_cfg))
	`uvm_fatal("APB WDOG DRIVER","Unable to get master config in driver")
        //agent_h=new;
	//foreach(agent_h[i])
	agent_h=master_agent::type_id::create("agent_h",this);

endfunction
