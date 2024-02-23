/***********************************************************
Author 		: Ramkumar 
File 		: slave_trans.sv
Module name     : slave_trans 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class slave_trans extends uvm_sequence_item;
	 `uvm_object_utils(slave_trans)

//output from TB 
rand bit wdogclken;     
rand bit wdogresn;

//input to TB
bit wdogint;      // Transmit data output
bit wdogres;     // Transmit enabled

//********************methods************************
extern function new (string name="slave_trans");
extern function void do_print (uvm_printer printer);
endclass:slave_trans

//*********************Constructor********************
function slave_trans :: new (string name="slave_trans");    
	 super.new(name);
endfunction:new

//*********************do_print********************
function void slave_trans::do_print(uvm_printer printer);
super.do_print(printer);
printer.print_field("wdogclken",this.wdogclken,1, UVM_DEC);
printer.print_field("wdogresn",this.wdogresn,1, UVM_DEC);
printer.print_field("wdogint",this.wdogint,1, UVM_DEC);
printer.print_field("wdogres",this.wdogres,1, UVM_DEC);
endfunction

