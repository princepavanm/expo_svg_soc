/***********************************************************
Author 		: Ramkumar 
File 		: slave_config.sv
Module name     : slave_config 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class slave_config extends uvm_object;
  `uvm_object_utils(slave_config)

//virtual interface declaration
virtual apb_if vif;
int has_master_agent=1;
uvm_active_passive_enum IS_ACTIVE=UVM_ACTIVE;

//*******************************Methods************************
extern function new(string name="slave_config");
endclass:slave_config

//***************************constructor************************
function slave_config :: new(string name="slave_config");
  super.new(name);
endfunction:new
