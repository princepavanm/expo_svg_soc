 //////////////////////////////////////////////////////////
 //Author:     Abhishek eemani
 //Module:     APB_SEQUENCER
 //Filename:   apb_sequencer.sv
 //Start Date: 25/10/2017
 //////////////////////////////////////////////////////////

class apb_sequencer extends uvm_sequencer#(apb_txn);
  `uvm_component_utils(apb_sequencer)
  
  extern function new(string name="apb_sequencer",uvm_component parent);
endclass:apb_sequencer

/////------apb_sequncer class construction ------/////
function apb_sequencer::new(string name="apb_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction
