/***********************************************************
Author 		: Ramkumar 
File 		: master_config.sv
Module name     : master_config 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class master_config extends uvm_object;
  `uvm_object_utils(master_config)

  //virtual interface declaration
  virtual wtapb_if vif;
  int has_master_agent=1;
  uvm_active_passive_enum IS_ACTIVE=UVM_PASSIVE;

  //*******************************Methods************************
  extern function new(string name="master_config");
endclass:master_config

//***************************constructor************************
function master_config :: new(string name="master_config");
  super.new(name);
endfunction:new
