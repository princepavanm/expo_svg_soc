//**********************************************************
// Author:     Abhishek
// Module:     RESET_SEQUENCER
// Filename:   reset_sequencer.sv
//********************************************************/


class reset_sequencer extends uvm_sequencer#(apb_txn);
  `uvm_component_utils(reset_sequencer)
  extern function new(string name="reset_sequencer",uvm_component parent);
endclass

function reset_sequencer::new(string name="reset_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction
