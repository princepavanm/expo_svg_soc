/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart transaction class
 Filename:   	uart_xtn.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/
class uart_xtn extends uvm_sequence_item;
`uvm_object_utils(uart_xtn)

//output from TB
rand bit RXD;	// Serial input

//input to TB
bit TXD;	// Transmit data output
bit TXEN;      	// Transmit enabled
bit BAUDTICK;  	// Baud rate (x16) Tick
bit TXINT;     	// Transmit Interrupt
bit RXINT;     	// Receive Interrupt
bit TXOVRINT;  	// Transmit overrun Interrupt
bit RXOVRINT;  	// Receive overrun Interrupt
bit UARTINT;   	// Combined interrupt

//temporary registers
reg [7:0]rdata1;
reg [7:0]wdata1;
reg INT;


//*******************************Methods***********************************
extern function new(string name="uart_xtn");
extern function void do_print(uvm_printer printer);
endclass:uart_xtn


//*****************************Constructor*********************************
function uart_xtn :: new(string name="uart_xtn");
super.new(name);
endfunction:new


//****************************Print Method*********************************
function void uart_xtn :: do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field("RXD",this.RXD,1,UVM_HEX);
  printer.print_field("TXD",this.TXD,1,UVM_HEX);
  printer.print_field("TXEN",this.TXEN,1,UVM_HEX);
  printer.print_field("BAUDTICK",this.BAUDTICK,1,UVM_HEX);
  printer.print_field("TXINT",this.TXINT,1,UVM_HEX);
  printer.print_field("RXINT",this.RXINT,1,UVM_HEX);
  printer.print_field("TXOVRINT",this.TXOVRINT,1,UVM_HEX);
  printer.print_field("RXOVRINT",this.RXOVRINT,1,UVM_HEX);
  printer.print_field("UARTINT",this.UARTINT,1,UVM_HEX);
  printer.print_field("rdata1",this.rdata1,8,UVM_HEX);
  printer.print_field("wdata1",this.wdata1,8,UVM_HEX);

endfunction:do_print

