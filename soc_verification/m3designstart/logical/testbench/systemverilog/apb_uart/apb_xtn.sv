/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb transaction class
 Filename:   	apb_xtn.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class apb_xtn extends uvm_sequence_item;
`uvm_object_utils(apb_xtn)

//***********************input signals********************
rand bit sel;
rand bit [11:2]addr;
rand bit enable;
rand bit trans_type;
rand bit [7:0]wdata;

//***********************output signals********************
bit [7:0]rdata;

//Temporary registers to store intermediate value
reg [4:0]mask;
reg [7:0]temp;
reg [31:0]temp2;
reg [7:0]temp3;
reg [31:0]temp4;

logic call_back=0;

//************************Methods**************************
extern function new(string name="apb_xtn");
extern function void do_print(uvm_printer printer);
endclass:apb_xtn


//***********************Constructor***********************
function apb_xtn :: new(string name="apb_xtn");
super.new(name);
endfunction:new


//***********************print method***********************
function void apb_xtn :: do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("sel",this.sel,1,UVM_HEX);
  printer.print_field("addr",this.addr,10,UVM_HEX);
  printer.print_field("enable",this.enable,1,UVM_HEX);
  printer.print_field("trans_type",this.trans_type,1,UVM_HEX);
  printer.print_field("wdata",this.wdata,32,UVM_HEX);
  printer.print_field("rdata",this.rdata,32,UVM_HEX);
  printer.print_field("temp",this.temp,32,UVM_HEX);
  printer.print_field("temp2",this.temp2,32,UVM_HEX);
  printer.print_field("temp3",this.temp2,8,UVM_HEX);
endfunction:do_print

