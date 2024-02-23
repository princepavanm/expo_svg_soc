/*=////////////////--------------------/////////////////////
 Author:     Ramkumar khumkar
 Module:     apb watchdog interface
 Filename:   apb_watchdog_interface.sv
 Start Date: 14/11/2017
 Finish Date:
 /////////////////---------------------////////////////////=*/
`define original 
`timescale 1ns/1ps

`ifdef original
interface wtapb_if(input bit pclk,input bit wdogclk);
/////------Declaring apb interface signals------/////
logic[11:2]paddr;
logic pwrite;
logic presetn;
logic psel;
logic penable;
logic wdogresn;
logic[31:0] pwdata;
logic[31:0]prdata;
logic pready;


/////------Declaring watchdog interface signals------/////
//logic wdogclk;
logic wdogclken;
logic wdogint;
logic wdogres;

//ECOREVNUM signal 
logic[3:0] ecorevnum; 

// Engineering-change-order revision bits
/////------Declaring clocking block for apb driver------/////
clocking apb_driver_cb@(posedge pclk);
//default input #1 output #1;
output presetn;
output paddr; 
output pwrite;
output psel;
output penable;
output ecorevnum;
output pwdata;
endclocking

/////------Declaring clocking block for watchdog driver------/////
clocking wdog_driver_cb@(posedge wdogclk);
//default input #1 output #1;
output wdogclken;
output wdogresn;
input wdogint;
input penable;
endclocking


/////------Declaring clocking block for apb monitor-----/////
clocking apb_monitor_cb@(posedge pclk);
//default input #1 output #1;
input presetn;
input paddr; 
input pwrite;
input psel; 
input penable; 
input prdata;
input ecorevnum;
input pwdata;
input pready;
endclocking

/////------Declaring clocking block for watchdog monitor-----/////
clocking wdog_monitor_cb@(posedge wdogclk);
//default input #1 output #1;
input wdogclken;
input wdogint;
input wdogres;
endclocking





/////------Declaring modport for apb driver------/////
 modport APB_DRIVER(clocking apb_driver_cb);
    
/////------Declaring modport for apb monitor------/////    
 modport APB_MONITOR(clocking apb_monitor_cb);
 
/////------Declaring modport for watchdog driver------/////
 modport WATCHDOG_DRIVER(clocking wdog_driver_cb);
    
/////------Declaring modport for watchdog monitor------/////    
 modport WATCHDOG_MONITOR(clocking wdog_monitor_cb);
endinterface

`else
interface wtapb_if(input bit pclk,input bit wdogclk);
/////------Declaring apb interface signals------/////
logic[11:2]paddr;
logic pwrite;
//logic presetn;
logic psel;
logic penable;
//logic wdogresn;
logic[31:0] pwdata;
logic[31:0]prdata;
logic pready;


/////------Declaring watchdog interface signals------/////
//logic wdogclk;
logic wdogclken;
logic wdogint;
logic wdogres;

//ECOREVNUM signal 
logic[3:0] ecorevnum; 
// Engineering-change-order revision bits
/////------Declaring clocking block for apb driver------/////
clocking apb_driver_cb@(posedge pclk);
default input #1 output #1;
//output presetn;
output paddr; 
output pwrite;
output psel;
output penable;
output ecorevnum;
output pwdata;
endclocking

/////------Declaring clocking block for apb monitor-----/////
clocking apb_monitor_cb@(posedge pclk);
//default input #1 output #1;
input presetn;
input paddr; 
input pwrite;
input psel; 
input penable; 
input prdata;
input ecorevnum;
input pwdata;
input pready;
endclocking

/////------Declaring clocking block for watchdog driver------/////
clocking wdog_driver_cb@(posedge wdogclk);
//default input #1 output #1;
output wdogclken;
//output wdogresn;
input wdogint;
input penable;
endclocking

/////------Declaring clocking block for watchdog monitor-----/////
clocking wdog_monitor_cb@(posedge wdogclk);
//default input #1 output #1;
input wdogresn;
input wdogclken;
input wdogint;
input wdogres;
endclocking

/////------Declaring modport for apb driver------/////
 modport APB_DRIVER(clocking apb_driver_cb);
    
/////------Declaring modport for apb monitor------/////    
 modport APB_MONITOR(clocking apb_monitor_cb);
 
/////------Declaring modport for watchdog driver------/////
 modport WATCHDOG_DRIVER(clocking wdog_driver_cb);
    
/////------Declaring modport for watchdog monitor------/////    
 modport WATCHDOG_MONITOR(clocking wdog_monitor_cb);
endinterface
`endif
