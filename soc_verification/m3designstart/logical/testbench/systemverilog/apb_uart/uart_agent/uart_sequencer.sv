/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb monitor class
 Filename:   	apb_monitor.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_sequencer extends uvm_sequencer#(uart_xtn); 
  `uvm_component_utils(uart_sequencer)

//*******************************Method***********************************
  extern function new(string name="uart_sequencer", uvm_component parent);
endclass:uart_sequencer

//***********************************Constructor*********************************
function uart_sequencer::new(string name="uart_sequencer", uvm_component parent);
  super.new(name,parent);
endfunction:new
