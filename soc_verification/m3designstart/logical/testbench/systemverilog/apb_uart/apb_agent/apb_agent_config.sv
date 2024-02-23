/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb agent config class
 Filename:   	apb_agent_config.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class apb_agent_config extends uvm_object;
  `uvm_object_utils(apb_agent_config)

// virtual interface  
	virtual APB_UART_if vif;
	int has_apb_agent=1;

// Delcaring agent active or passive
	uvm_active_passive_enum IS_ACTIVE=UVM_PASSIVE; 
 
//*******************************Methods************************
extern function new(string name="apb_agent_config");
endclass:apb_agent_config

//***************************constructor************************
function apb_agent_config :: new(string name="apb_agent_config");
  super.new(name);
endfunction:new
