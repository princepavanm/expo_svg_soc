/**********************************************************
Author 		: Ramkumar 
File 		: slave_sequence.sv
Module name     : slave_sequence 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class slave_sequence extends uvm_sequence #(slave_trans);
	 `uvm_object_utils(slave_sequence)

//*************************methods************************
extern function new (string name="slave_sequence");
endclass:slave_sequence


//*********************constructor***********************
function slave_sequence :: new (string name="slave_sequence");
	 super.new(name);
endfunction:new

//==================================================================//
// T.C. 1 :Reading default values of DUT
//==================================================================//
class wdog_read_default_values extends slave_sequence;
  `uvm_object_utils(wdog_read_default_values)
  int i=0;
//*******************************Methods*********************************** 
 extern function new(string name="wdog_read_default_values");
 extern task body();
endclass:wdog_read_default_values

//*****************************Constructor*********************************     
function wdog_read_default_values::new(string name="wdog_read_default_values");
  super.new(name);
endfunction

task wdog_read_default_values::body();
  req=slave_trans::type_id::create("req");
     begin
     start_item(req);
     assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     finish_item(req);
   `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  end
   begin
     start_item(req);
     assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b1;})  
     finish_item(req);
   `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  end

  
endtask

//==================================================================//
// T.C. 2 :Generating watchdog reset of DUT
//==================================================================//
class wdog_wdog_rst extends slave_sequence;
`uvm_object_utils(wdog_wdog_rst)

//****************************Methods******************************* 
extern function new(string name= "wdog_wdog_rst");
extern task body();
endclass

//****************************Constructor***************************
function wdog_wdog_rst::new(string name= "wdog_wdog_rst");
super.new(name);
endfunction

//***********************wdog_wdog_rst*********************************** 
task wdog_wdog_rst::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		req.wdogresn=1'b1;
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end	
endtask

//==================================================================//
// T.C. 3 :Writting to all registers and then reading the same 
// to check the behaviour
//==================================================================//
class wdog_wr_rd_values extends slave_sequence;
`uvm_object_utils(wdog_wr_rd_values)

//****************************Methods******************************* 
extern function new(string name= "wdog_wr_rd_values");
extern task body();
endclass

//****************************Constructor***************************
function wdog_wr_rd_values::new(string name= "wdog_wr_rd_values");
super.new(name);
endfunction

//***********************wdog_wr_rd_values*********************************** 
task wdog_wr_rd_values::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		req.wdogresn=1'b1;
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//==================================================================//
// T.C. 4 :Clearing the interrupt after interrupt
//==================================================================//

class wdog_intrpt_rst extends slave_sequence;
`uvm_object_utils(wdog_intrpt_rst)

//****************************Methods******************************* 
extern function new(string name= "wdog_intrpt_rst");
extern task body();
endclass

//****************************Constructor***************************
function wdog_intrpt_rst::new(string name= "wdog_intrpt_rst");
super.new(name);
endfunction

//***********************wdog_intrpt_rst*********************************** 
task wdog_intrpt_rst::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//==================================================================//
// T.C. 5 : Locking the watchdog to disable the write access
//==================================================================//
class wdog_locked_reg extends slave_sequence;
`uvm_object_utils(wdog_locked_reg)

//****************************Methods******************************* 
extern function new(string name= "wdog_locked_reg");
extern task body();
endclass

//****************************Constructor***************************
function wdog_locked_reg::new(string name= "wdog_locked_reg");
super.new(name);
endfunction

//***********************wdog_locked_reg*********************************** 
task wdog_locked_reg::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//==================================================================//
// T.C. 6 : Observing watchdog in integration test mode	and reset 
// behaviour				
//==================================================================//
class wdog_int_mode_rst extends slave_sequence;
`uvm_object_utils(wdog_int_mode_rst)

//****************************Methods******************************* 
extern function new(string name= "wdog_int_mode_rst");
extern task body();
endclass

//****************************Constructor***************************
function wdog_int_mode_rst::new(string name= "wdog_int_mode_rst");
super.new(name);
endfunction

//***********************wdog_int_mode_rst*********************************** 
task wdog_int_mode_rst::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//==================================================================//
// T.C. 7 : Observing watchdog in integration test mode	and interrupt 
// behaviour				
//==================================================================//
class wdog_int_mode_int extends slave_sequence;
`uvm_object_utils(wdog_int_mode_int)

//****************************Methods******************************* 
extern function new(string name= "wdog_int_mode_int");
extern task body();
endclass

//****************************Constructor***************************
function wdog_int_mode_int::new(string name= "wdog_int_mode_int");
super.new(name);
endfunction

//***********************wdog_int_mode_int*********************************** 
task wdog_int_mode_int::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//=====================================================================================//
// T.C. 8 :Corrupting the counter value in the mid of transaction using callback method
//=====================================================================================//

class wdog_intrpt_rst_cb extends slave_sequence;
`uvm_object_utils(wdog_intrpt_rst_cb)

//****************************Methods******************************* 
extern function new(string name= "wdog_intrpt_rst_cb");
extern task body();
endclass

//****************************Constructor***************************
function wdog_intrpt_rst_cb::new(string name= "wdog_intrpt_rst_cb");
super.new(name);
endfunction

//***********************wdog_intrpt_rst_cb*********************************** 
task wdog_intrpt_rst_cb::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//=====================================================================================//
// T.C. 9 :Corrupting the PSEL in the mid of transaction using callback method
//=====================================================================================//

class wdog_psel_cb extends slave_sequence;
`uvm_object_utils(wdog_psel_cb)

//****************************Methods******************************* 
extern function new(string name= "wdog_psel_cb");
extern task body();
endclass

//****************************Constructor***************************
function wdog_psel_cb::new(string name= "wdog_psel_cb");
super.new(name);
endfunction

//***********************wdog_psel_cb*********************************** 
task wdog_psel_cb::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//=====================================================================================//
// T.C. 14 :Arbitration
//=====================================================================================//

class wdog_arb extends slave_sequence;
`uvm_object_utils(wdog_arb)

//****************************Methods******************************* 
extern function new(string name= "wdog_arb");
extern task body();
endclass

//****************************Constructor***************************
function wdog_arb::new(string name= "wdog_arb");
super.new(name);
endfunction

//***********************wdog_psel_cb*********************************** 
task wdog_arb::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

//=====================================================================================//
// T.C. 16 :phases
//=====================================================================================//

class wdog_phase extends slave_sequence;
`uvm_object_utils(wdog_phase)

//****************************Methods******************************* 
extern function new(string name= "wdog_phase");
extern task body();
endclass

//****************************Constructor***************************
function wdog_phase::new(string name= "wdog_phase");
super.new(name);
endfunction

//***********************wdog_psel_cb*********************************** 
task wdog_phase::body();
req=slave_trans::type_id::create("req");
      begin
                start_item(req);
    	 	assert(req.randomize()with {wdogclken==1'b1;wdogresn==1'b0;})  
     		finish_item(req);
   		`uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
  		

		start_item(req);
		assert(req.randomize() with {wdogclken==1'b1;wdogresn==1'b1;})
            	finish_item(req);
	        `uvm_info("SLAVE SEQUENCE",$sformatf("\nPrinting From Slave Sequence",req.sprint()),UVM_LOW)
      end
endtask

