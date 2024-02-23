 ////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     apb_txn
 //Filename:   apb_sequence_item.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////////////////////////
 
class apb_txn extends uvm_sequence_item;
  `uvm_object_utils(apb_txn)

/////------rand signals that we are sending to dut------/////
bit presetn;              // Reset
rand bit psel;            // Device select
rand logic [11:2]paddr;   // Address
rand bit penable;         // Transfer control
rand bit pwrite;          // Write control
rand logic [31:0]pwdata;  // Write data
logic [31:0]prdata;       // Read data

/////------functions------/////
extern function new(string name="apb_txn");
extern function void do_print(uvm_printer printer);
// (do_print) is a 'print' method, which is called from uvm_object hierarchy  
// The uvm_printer class provides an interface for printing uvm_objects in various formats
endclass:apb_txn

/////------apb_txn class construction ------/////
function apb_txn::new(string name="apb_txn");
  super.new(name);
endfunction

/////------print method-------/////
function void apb_txn::do_print(uvm_printer printer);
  super.do_print(printer);

printer.print_field("presetn",this.presetn,1,UVM_HEX);
printer.print_field("psel",this.psel,1,UVM_HEX);
printer.print_field("paddr",this.paddr,10,UVM_HEX);
printer.print_field("penable",this.penable,1,UVM_HEX);
printer.print_field("pwrite",this.pwrite,1,UVM_HEX);
printer.print_field("pwdata",this.pwdata,32,UVM_HEX);
printer.print_field("prdata",this.prdata,32,UVM_HEX);

endfunction
  
