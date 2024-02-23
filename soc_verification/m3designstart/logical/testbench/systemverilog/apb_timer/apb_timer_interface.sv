 ///////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     apb_timer_if
 //Filename:   apb_timer_interface.sv
 //Start Date: 23/10/2017
 ////////////////////////////////////////

 
 //`timescale 10ns/10fs

interface apb_timer_if(input bit pclk,input bit pclkg);

/////------Declaring apb interface signals------/////
logic presetn;         // Reset
logic psel;            // Device pselect
logic [11:2]paddr;     // Address
logic penable;         // Transfer control
logic pwrite;          // Write control
logic [31:0] pwdata;   // Write data
logic [31:0] prdata;   // Read data
logic pready;          // Device ready
logic pslverr;         // Device error response

/////------Declaring timer interface signals------/////

logic extin;           // External input
logic Timerint;        // Timer interrupt output

//ECORE signal 
logic [3:0] ecorev; // Engineering-change-order revision bits


/////------Declaring clocking block for apb driver------/////
clocking apb_driver_cb@(posedge pclkg);
  default input #1 output #0;
  output presetn;
  output psel;    
  output paddr;   
  output penable; 
  output pwrite;
  output pwdata;
  input prdata;
  input pready;
  input pslverr;
  input ecorev;
endclocking

/////------Declaring clocking block for apb monitor-----/////
clocking apb_monitor_cb@(posedge pclkg);
  default input #1;
  input presetn;
  input psel;    
  input paddr;   
  input penable; 
  input pwrite;
  input pwdata;
  input prdata;
  input pready;
  input pslverr;
  input ecorev;
endclocking

/////------Declaring clocking block for timer driver------/////
clocking timer_driver_cb@(posedge pclk);
  default input #1 output #0;
  output extin;
  input Timerint;
endclocking

/////------Declaring clocking block for timer monitor------/////
clocking timer_monitor_cb@(posedge pclk);
  default input #1 output #0;
  input extin;
  input Timerint;
endclocking

 
/////------Declaring modport for apb driver------/////
  modport APB_DRIVER(clocking apb_driver_cb);
    
/////------Declaring modport for apb monitor------/////    
  modport APB_MONITOR(clocking apb_monitor_cb);
  
  
/////------Declaring modport for timer driver------/////  
  modport TIMER_DRIVER(clocking timer_driver_cb);
    
/////------Declaring modport for timer monitor------/////    
  modport TIMER_MONITOR(clocking timer_monitor_cb);




////////=============ASSERTIONS=============////////

//DECLARING THE SEQUENCES
//sequence APB_SETUP_PHASE;
//	psel&&!penable;
//endsequence
//
//sequence APB_ACCESS_PHASE;
//	psel&&penable;
//endsequence
//
//sequence APB_BUS;
//	APB_SETUP_PHASE ##1 APB_ACCESS_PHASE;
//endsequence
//
//sequence APB_READ_CYCLE;
//	(!pwrite) throughout APB_BUS;
//endsequence
//
//sequence APB_WRITE_CYCLE;
//	(pwrite) throughout APB_BUS;
//endsequence



//DECLARING THE PROPERTYS
//property apb_cycles_are_complete;
//	@(posedge pclk) ((pwrite) |-> APB_BUS);
//endproperty
//
//property apb_no_ppenable_outside_cycle2;
//	@(posedge pclk) (ppenable |-> $stable(ppsel) ##1 (!ppenable));
//endproperty
//
//property apb_write_and_addr_stable;
//	@(posedge pclk) ((ppsel&&ppenable) |-> $stable({pwrite,paddr}));
//endproperty
//
//property apb_write_and_addr_valid;
//	@(posedge pclk) ((ppsel&&ppenable) |-> (({!pwrite,paddr}) !== 1'bx));
//endproperty
//
//property apb_write_data_stable;
//	@(posedge pclk) ((ppenable && pwrite) |-> $stable(pwdata));
//endproperty
//
//property apb_complete_cycles_with_valid_address;
//	@(posedge pclk) ((ppsel && !ppenable) |-> (((^{pwrite,paddr}) !== 1'bx) throughout APB_BUS));
//endproperty
//
////CHECKING THE PROPERTYS USING THE assert
//cycles_complete:assert property(apb_cycles_are_complete);
//ppenable_vaild:assert property(apb_no_ppenable_outside_cycle2);
//controls_stable:assert property(apb_write_and_addr_stable);
//write_data_stable:assert property(apb_write_and_addr_stable);

  
//Back-to-back cycles 
//sequence APB_BACK_TO_BACK;
//	@(posedge pclk) APB_BUS ##1 APB_BUS;
//endsequence

//sequence APB_IDLE_CYCLE;
//	@(posedge pclk) APB_IDLE ##1 APB-BUS;
//endsequence
//1

`ifdef ASSERT_ON
property state_cycle;
	@(posedge pclk) ( (presetn && pready && psel && !penable) |-> (psel && !penable) ##1 (psel&&penable) ##1 (!psel&&!penable));
endproperty

cycle_c:assert property(state_cycle); 


//2
property psel_check;

	@(posedge pclk) (penable |-> $stable(psel) ##1 (!penable));

endproperty

psel_c: assert property(psel_check);


//3
property wait_state_extend_check;

	@(posedge pclk) ((!pready) |-> $stable ({pwrite,paddr,pwdata,prdata}));

endproperty

wait_state_check:assert property(wait_state_extend_check);


//4
property  slave_error_check;

	@(posedge pclk) (pslverr |-> (psel&&penable&&pready));

endproperty

slave_error:assert property(slave_error_check);



//5
property penable_check;

	@(posedge pclk) ((psel && !penable) |=> $rose(penable));

endproperty

penable_c: assert property(penable_check);



//6
property access_cycle_check;

	@(posedge pclk) ((psel&&penable)|=> $fell ({psel,penable}));

endproperty

access_c: assert property(access_cycle_check);



//7
property read_check;

@(posedge pclk) ((psel&&!penable&&!pwrite) |-> prdata);

endproperty

rd_signal:assert property(read_check);



//8
property write_check;

@(posedge pclk) ((psel&&!penable&&pwrite) |-> pwdata);

endproperty

wr_signal:assert property(write_check);

`endif

endinterface
