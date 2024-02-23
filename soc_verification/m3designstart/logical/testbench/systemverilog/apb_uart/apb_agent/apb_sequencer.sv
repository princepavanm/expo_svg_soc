/**********************************************************
 Author:     	Kalmeshwar s Chougala
 Class:     	apb sequencer class
 Filename:   	apb_sequencer.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class apb_sequencer extends uvm_sequencer#(apb_xtn);
  `uvm_component_utils(apb_sequencer)
  
//*******************************Methods**************************************  
extern function new(string name="apb_sequencer", uvm_component parent);
endclass:apb_sequencer


//*******************************Constructor********************************** 
function apb_sequencer::new(string name="apb_sequencer", uvm_component parent);
super.new(name, parent);
endfunction:new
