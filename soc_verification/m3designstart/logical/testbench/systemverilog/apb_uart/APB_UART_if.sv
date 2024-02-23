/**********************************************************
 Author:     	Kalmeshwar s Chougala
 Intrface:     	intf_APB and intf_UART
 Filename:   	intf.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/


//////////////////////////APB_INTERFACE//////////////////////////
`define original
`timescale 1ns/1ps

`ifdef original
interface APB_UART_if (input bit clk);
//***************************************************************
//APB SIGNALS
//***************************************************************

//APB input signals
logic reset;
logic clkG; 		// Gated Clock 
logic [11:2]addr; 	// Address
logic trans_type;       // Write control
logic sel;    		// Device select
logic enable;  		// Transfer control
logic [31:0]wdata;  	// Write data

//APB output signals
logic [31:0]rdata; 	// Read data 
logic PREADY;       	//Ready DATA
logic [3:0]ECOREVNUM; 	// Engineering-change-order revision bits
logic PSLVERR;    	// Device error response

//***************************************************************
//------MASTER DRIVE----//
clocking drv_cb @(posedge clk);
  default input #1 output #1;
  input rdata,PREADY,PSLVERR;
 output clkG,sel,addr,enable,trans_type,
  wdata,ECOREVNUM;
endclocking
//***************************************************************

//***************************************************************
//-----MASTER MONITOR----//
clocking mon_cb @(posedge clk);
  default input #1 output #1;
input clkG,sel,addr,enable,trans_type,
wdata,rdata,PREADY,PSLVERR,ECOREVNUM;
endclocking
//****************************************************************

//************************MODPORTS********************************
modport DRV_MP(clocking drv_cb);
modport MON_MP(clocking mon_cb);
//****************************************************************


//***********************ASSERTION********************************

//Declaration of sequence

/*sequence cycle;
((sel && !enable) ##1 (sel && enable) ##1 (!sel && !enable));
endsequence

sequence wr;
	((trans_type==1) throughout cycle);
endsequence	

sequence rd;
	((trans_type==0) throughout cycle);
endsequence	


//Declaration of peroperty

//1
property state_cycle;
	@(posedge clk) ( (rst && PREADY && sel && !enable) |-> (sel && !enable) ##1 (sel&&enable) ##1 (!sel&&!enable));
endproperty

cycle_c:assert property(state_cycle); 


//2
property sel_check;

	@(posedge clk) (enable |-> $stable(sel) ##1 (!enable));

endproperty

sel_c: assert property(sel_check);


//3
property wait_state_extend_check;

	@(posedge clk) ((!PREADY) |-> $stable ({trans_type,addr,wdata,rdata}));

endproperty

wait_state_check:assert property(wait_state_extend_check);


//4
property  slave_error_check;

	@(posedge clk) (PSLVERR |-> (sel&&enable&&PREADY));

endproperty

slave_error:assert property(slave_error_check);



//5
property enable_check;

	@(posedge clk) ((sel && !enable) |=> $rose(enable));

endproperty

enable_c: assert property(enable_check);



//6
property access_cycle_check;

	@(posedge clk) ((sel&&enable)|=> $fell ({sel,enable}));

endproperty

access_c: assert property(access_cycle_check);



//7
property read_check;

@(posedge clk) ((sel&&!enable&&!trans_type) |-> rd);

endproperty

rd_signal:assert property(read_check);



//8
property write_check;

@(posedge clk) ((sel&&!enable&&trans_type) |-> wr);

endproperty

wr_signal:assert property(write_check);*/


//endinterface:intf_APB



//////////////////////////UART_INTERFACE//////////////////////////

//interface intf_UART(input bit clk);

//****************************************************************
//UART SIGNALS
//****************************************************************

//UART input signals
logic  RXD;       	// Serial input

//UART output signals
logic  TXD;       	// Transmit data output
logic  TXEN;     	// Transmit enabled
logic  BAUDTICK;  	// Baud rate (x16) Tick
logic  TXINT;    	// Transmit Interrupt
logic  RXINT;    	// Receive Interrupt
logic  TXOVRINT; 	// Transmit overrun Interrupt
logic  RXOVRINT; 	// Receive overrun Interrupt
logic  UARTINT;  	// Combined interrupt

//****************************************************************
//------SLAVE DRIVE----//
clocking sdrv_cb @(posedge clk);
  default input #1 output #1;
  input TXD,TXEN,BAUDTICK,TXINT,RXINT,
  TXOVRINT,RXOVRINT,UARTINT;
 output RXD;
endclocking
//****************************************************************

//****************************************************************
//-----SLVA MONITOR----//
clocking smon_cb @(posedge clk);
  default input #1 output #1;
  input TXD,TXEN,BAUDTICK,TXINT,RXINT,
  TXOVRINT,RXOVRINT,UARTINT,RXD;
endclocking
//****************************************************************

//************************MODPORTS********************************
modport SDRV_MP(clocking sdrv_cb);
modport SMON_MP(clocking smon_cb);
//****************************************************************

endinterface

`else
interface intf_APB (input bit clk);
//***************************************************************
//APB SIGNALS
//***************************************************************

//APB input signals
//logic reset;
logic clkG; 		// Gated Clock 
logic [11:2]addr; 	// Address
logic trans_type;       // Write control
logic sel;    		// Device select
logic enable;  		// Transfer control
logic [31:0]wdata;  	// Write data

//APB output signals
logic [31:0]rdata; 	// Read data 
logic PREADY;       	//Ready DATA
logic [3:0]ECOREVNUM; 	// Engineering-change-order revision bits
logic PSLVERR;    	// Device error response

//***************************************************************
//------MASTER DRIVE----//
clocking drv_cb @(posedge clk);
  default input #1 output #1;
  input rdata,PREADY,PSLVERR;
 output clkG,sel,addr,enable,trans_type,
  wdata,ECOREVNUM;
endclocking
//***************************************************************

//***************************************************************
//-----MASTER MONITOR----//
clocking mon_cb @(posedge clk);
  default input #1 output #1;
input clkG,sel,addr,enable,trans_type,
wdata,rdata,PREADY,PSLVERR,ECOREVNUM;
endclocking
//****************************************************************

//************************MODPORTS********************************
modport DRV_MP(clocking drv_cb);
modport MON_MP(clocking mon_cb);
//****************************************************************


//****************************************************************
//UART SIGNALS
//****************************************************************

//UART input signals
logic  RXD;       	// Serial input

//UART output signals
logic  TXD;       	// Transmit data output
logic  TXEN;     	// Transmit enabled
logic  BAUDTICK;  	// Baud rate (x16) Tick
logic  TXINT;    	// Transmit Interrupt
logic  RXINT;    	// Receive Interrupt
logic  TXOVRINT; 	// Transmit overrun Interrupt
logic  RXOVRINT; 	// Receive overrun Interrupt
logic  UARTINT;  	// Combined interrupt

//****************************************************************
//------SLAVE DRIVE----//
clocking sdrv_cb @(posedge clk);
  default input #1 output #1;
  input TXD,TXEN,BAUDTICK,TXINT,RXINT,
  TXOVRINT,RXOVRINT,UARTINT;
 output RXD;
endclocking
//****************************************************************

//****************************************************************
//-----SLVA MONITOR----//
clocking smon_cb @(posedge clk);
  default input #1 output #1;
  input TXD,TXEN,BAUDTICK,TXINT,RXINT,
  TXOVRINT,RXOVRINT,UARTINT,RXD;
endclocking
//****************************************************************

//************************MODPORTS********************************
modport SDRV_MP(clocking sdrv_cb);
modport SMON_MP(clocking smon_cb);
//****************************************************************

endinterface
`endif


