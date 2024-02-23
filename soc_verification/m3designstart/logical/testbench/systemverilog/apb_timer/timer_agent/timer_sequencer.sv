
////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_sequencer
 //Filename:   timer_sequencer.sv
 //start date: 23/10/2017 
 ////////////////////////////////////////////////////////////
 
class timer_sequencer extends uvm_sequencer#(timer_txn);
  `uvm_component_utils(timer_sequencer)
  
  extern function new(string name="timer_sequencer",uvm_component parent);
endclass:timer_sequencer

function timer_sequencer::new(string name="timer_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction

