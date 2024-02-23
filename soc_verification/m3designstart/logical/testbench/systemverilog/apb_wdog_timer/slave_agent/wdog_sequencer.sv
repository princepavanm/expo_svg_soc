/***********************************************************
Author 		: Ramkumar 
File 		: slave_sequencer.sv
Module name     : slave_sequencer 
Description     :        
Started DATA    : 06/03/2018  
***********************************************************/ 

class slave_sequencer extends uvm_sequencer#(slave_trans);
	 `uvm_component_utils(slave_sequencer)

//*********************************method********************************
extern function new (string name="slave_sequencer",uvm_component parent);   
endclass:slave_sequencer


//****************************Constructor*******************************
function slave_sequencer :: new (string name="slave_sequencer",uvm_component parent); 
	 super.new(name,parent);
endfunction:new

