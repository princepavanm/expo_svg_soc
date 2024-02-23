/***********************************************************
Author 		: Ramkumar 
File 		: master_trans.sv
Module name     : master_trans 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class master_trans extends uvm_sequence_item;
	 `uvm_object_utils(master_trans)

//***********************input signals****************
bit presetn;
rand bit pwrite;
rand bit psel;
rand bit penable;
rand logic[11:2]paddr;
rand logic[31:0]pwdata;
logic[3:0]ecorevnum;
rand bit wdogclken;
rand bit wdogresn;
reg [31:0]temp;
//Taking extra reset test value
bit rst_value_test;
//Taking variable for interrupt
bit intp;
//Flag dont compair for lock
bit dont_compare;
//Flag for callback 
bit enb_callback=0;
//Flag for apb callback
bit apb_callback=0;
//***********************output signals**************
bit [31:0]prdata;
bit wdogint;
bit wdogres;

//Adding constraints
/*constraint data {paddr==9'h 000 -> pwdata==32'h FFFFFFFF;
		 paddr==9'h 001 -> pwdata==32'h FFFFFFFF;
	 	 (paddr!=9'h 000 && paddr!=9'h 001) -> pwdata==32'h 00000000;}
*/
//********************methods************************

extern function new (string name="master_trans");
extern function void do_print(uvm_printer printer);
endclass:master_trans


//*********************Constructor********************
function master_trans :: new (string name="master_trans");    
	 super.new(name);
endfunction:new

//*********************do_print**********************
function void master_trans::do_print(uvm_printer printer);
super.do_print(printer);
printer.print_field("presetn",this.presetn,1, UVM_DEC);
printer.print_field("paddr",this.paddr,9, UVM_HEX);
printer.print_field("psel",this.psel,1, UVM_DEC);
printer.print_field("pwrite",this.pwrite,1, UVM_DEC);
printer.print_field("penable",this.penable,1, UVM_DEC);
printer.print_field("pwdata",this.pwdata,32, UVM_HEX);
printer.print_field("prdata",this.prdata,32, UVM_HEX);
printer.print_field("wdogclken",this.wdogclken,1, UVM_DEC);
printer.print_field("wdogresn",this.wdogresn,1, UVM_DEC);
endfunction
