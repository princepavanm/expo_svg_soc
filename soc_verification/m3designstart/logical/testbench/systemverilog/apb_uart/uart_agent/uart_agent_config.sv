/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart agent config class
 Filename:   	uart_agent_config.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_agent_config extends uvm_object;

`uvm_object_utils(uart_agent_config)

//virtual interface
virtual intf_UART vif1;


//Agent is active or passive
uvm_active_passive_enum is_active=UVM_ACTIVE;

//*******************************Methods**************************** 
extern function new(string name="uart_agent_config");
endclass:uart_agent_config

//****************************constructor**************************** 
function uart_agent_config::new(string name="uart_agent_config");
  super.new(name);
endfunction:new
