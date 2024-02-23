//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : master_transaction
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


class master_AHB_xtn extends uvm_sequence_item;
`uvm_object_utils(master_AHB_xtn) // Factory Registration

//************DATA MEMBERS TOWARDS DUT (RAND TYPE)***************
  rand bit hresetn;             
  rand bit hsel;
  rand bit [15:0] haddr;
  rand bit [1:0]htrans;
  rand bit [2:0]hsize;
  rand bit hwrite;
  rand bit hready;
  rand bit [31:0] hwdata;
  
  bit hreadyout;
  bit hresp;
  bit [31:0] hrdata;
  reg [31:0] temp;
  
  constraint H_data {hwdata dist {[0:500]:=5,
                                  [501:1000]:=5,
                                  [1001:1024]:=5,
                                  [1025:2048]:=5};}
    
//***************************Extern functions**********************************************************
extern function new(string name="master_AHB_xtn");
extern function void do_print(uvm_printer printer);
//extern function void do_compare(uvm_object rhs, uvm_comparer comparer);
//extern function void do_comapre(input master_AHB_xtn rcv, output string message);
endclass

//*********************************Constractor*********************************************************
function master_AHB_xtn::new(string name="master_AHB_xtn");
  super.new(name);
endfunction 

//***********************************Do print**********************************************************
function void master_AHB_xtn::do_print(uvm_printer printer);
super.do_print(printer);

    printer.print_field("hresetn",  this.hresetn,   1,  UVM_HEX);
    printer.print_field("hselx",    this.hsel,      1,  UVM_HEX);
   
    printer.print_field("htrans",   this.htrans,    2,  UVM_HEX);
    printer.print_field("hsize",    this.hsize,     3,  UVM_HEX);
    
    printer.print_field("hready",   this.hready,    1,  UVM_HEX);
    printer.print_field("hreadyout",this.hreadyout, 1,  UVM_HEX);
    printer.print_field("hresp",    this.hresp,     1,  UVM_HEX);
    printer.print_field("hwrite",   this.hwrite,    1,  UVM_HEX);
    printer.print_field("haddr",    this.haddr,     16, UVM_HEX);
   
    printer.print_field("hwdata",   this.hwdata,    32, UVM_HEX);
    printer.print_field("hrdata",   this.hrdata,    32, UVM_HEX);

endfunction




