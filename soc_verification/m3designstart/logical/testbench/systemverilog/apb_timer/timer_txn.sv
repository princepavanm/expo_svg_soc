////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_txn
 //Filename:   timer_txn.sv
 //start date: 23/10/2017 
 ////////////////////////////////////////////////////////////
 
class timer_txn extends uvm_sequence_item;
  `uvm_object_utils(timer_txn)
  
rand bit extin;           // External input
bit Timerint;             // Timer interrupt output
            
extern function new(string name="timer_txn");
extern function void do_print(uvm_printer printer);
endclass:timer_txn

////timer_txn class construction
function timer_txn::new(string name="timer_txn");
  super.new(name);
endfunction

////////printer 
  function void timer_txn::do_print(uvm_printer printer);
     super.do_print(printer);
     
     printer.print_field("extin",this.extin,1,UVM_HEX);
     printer.print_field("Timerint",this.Timerint,1,UVM_HEX);
     
   endfunction
     
