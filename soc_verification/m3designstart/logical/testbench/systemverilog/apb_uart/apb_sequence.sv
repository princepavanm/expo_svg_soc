/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb sequence class
 Filename:   	apb_sequence.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class apb_sequence extends uvm_sequence #(apb_xtn);
  `uvm_object_utils(apb_sequence)

// Environment configuration handle
   uart_env_config uart_env_cfg;

 apb_reg_block apb_rb;
rand uvm_reg_data_t data;
  uvm_status_e status;
//************************Method**************************  
 extern function new(string name="apb_sequence");
 extern task body();
endclass:apb_sequence

//***********************Constructor***********************  
  function apb_sequence :: new(string name="apb_sequence");

 super.new(name);
  endfunction:new  
  
  task apb_sequence::body();

	  if(!uvm_config_db#(uart_env_config)::get(null,get_full_name(),"uart_env_config",uart_env_cfg)) begin
  	`uvm_info(get_type_name(),"ENV_NOT_OK",UVM_MEDIUM)
end
  	 apb_rb=uart_env_cfg.apb_rb;
  
  endtask
 
//******************************************************************
// TEST_SEQUNCES-1:READ DEFAULT VALUES OF REGISTER AND PID
//******************************************************************  

  class apb_reset_seq extends apb_sequence;
    `uvm_object_utils(apb_reset_seq) 
//****************************Methods*******************************    
    extern function new(string name="apb_reset_seq");
    extern task body();
  endclass:apb_reset_seq
//****************************Constructor***************************
  function apb_reset_seq ::new(string name="apb_reset_seq");
    super.new(name);
  endfunction:new
  
//***********************apb_reset_seq method***********************  
  task apb_reset_seq::body();

   logic [11:2] addr=0; 
    super.body();
    req=apb_xtn::type_id::create("apb_xtn");  
   
      begin
    	begin
      // All functional registeres read 
      for (int i=0; i<5; i++)
      begin      
      start_item(req);
        assert (req.randomize()with {addr==10'h0 +i;
                                   trans_type == read;
                              
                                  });
        finish_item(req);
	
	
	if(req.addr==10'h0)
		begin
			if(req.rdata==`DATA_R)

				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`DATA_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end			
				
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`DATA_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==10'h1)
		begin
			if(req.rdata==`STATE_R)
				
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`STATE_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end			
				
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>>>Actual_DATA=%d",`STATE_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==10'h2)
		begin
			if(req.rdata==`CTRL_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CTRL_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CTRL_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	
	if(req.addr==10'h3)
		begin
			if(req.rdata==`INT_R)
				
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`INT_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end			
				
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`INT_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end	

	if(req.addr==10'h4)
		begin
			if(req.rdata==`BAUDDIV_R)
				
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`BAUDDIV_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end			
				
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`BAUDDIV_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end       


      end 
    end
  #100;
  
    begin 
      // All PID regfisters read
      for (int j=0; j<16; j++) 
      begin
        addr = 10'h3F4 +j; 
        start_item(req);
        assert (req.randomize()with {addr==addr;
                                   trans_type == read;
                              
                                  });
        req.addr=addr;
        finish_item(req);  
   #100; 

	if(req.addr==10'h3F4)
		begin
			if(req.rdata==`PID4_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID4_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
			begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID4_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==10'h3F5)
		begin
			if(req.rdata==`PID5_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID5_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID5_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==10'h3F6)
		begin
			if(req.rdata==`PID6_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID6_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID6_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	
	if(req.addr==10'h3F7)
		begin
			if(req.rdata==`PID7_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID7_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID7_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end	

	if(req.addr==10'h3F8)
		begin
			if(req.rdata==`PID0_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID0_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID0_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	
	

	if(req.addr==10'h3F9)
		begin
			if(req.rdata== `PID1_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID1_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID1_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	
	if(req.addr==10'h3FA)
		begin
			if(req.rdata==`PID2_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID2_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID2_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	
	if(req.addr==10'h3FB)
		begin
			if(req.rdata==`PID3_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID3_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`PID3_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	
	if(req.addr==10'h3FC)
		begin
			if(req.rdata==`CID0_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID0_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID0_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end

	if(req.addr==10'h3FD)
		begin
			if(req.rdata==`CID1_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID1_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID1_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end

	if(req.addr==10'h3FE)
		begin
			if(req.rdata==`CID2_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID2_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID2_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==10'h3FF)
		begin
			if(req.rdata==`CID3_R)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID3_R);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`CID3_R);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end

	if(req.addr==0)
		begin
			if(req.rdata==`EXT)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	

	if(req.addr==1)
		begin
			if(req.rdata==`EXT)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==2)
		begin
			if(req.rdata==`EXT)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end
	if(req.addr==3)
		begin
			if(req.rdata==`EXT)
				begin
				$display(">>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
				`uvm_info(get_type_name(),"sequence matched",UVM_MEDIUM)				
				end
			else
				begin
				$display(">>>>>>>>>>>>>>>>>>>>>>Actual DATA=%d",`EXT);
			       `uvm_info(get_type_name(),"sequence NOT matched",UVM_MEDIUM)
				end
		end

      end 
    end 
end

endtask:body
 
 
//****************************************************************************************
// TEST_SEQUNCES-2: WRITE AND READ OF REGISTER AND CHECK THE DEFUALT VALUE AND PERFORMANCE 
//**************************************************************************************** 


class apb_write_read_check extends apb_sequence;
   `uvm_object_utils(apb_write_read_check)
   
//********************************Methods*******************************
   extern function new(string name="apb_write_read_check");
   extern task body(); 
 endclass:apb_write_read_check
 
 //*****************************Constructor*****************************
 function apb_write_read_check::new(string name="apb_write_read_check");
   super.new(name);
 endfunction:new
 
 //********************apb_write_read_check method**********************
 task apb_write_read_check::body();
  int data;
   super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   begin
   start_item(req);            //control register write
   assert (req.randomize()with {addr==`CONTROL_REG_PADD;
                                trans_type==write;				                
                                wdata==4'h f;
				});
   finish_item(req);
   end
   
   begin
   start_item(req);            //control register read
   assert (req.randomize()with {addr==`CONTROL_REG_PADD;
                                trans_type==read;
				});
   finish_item(req);
   end
  
    //if(req.temp==req.rdata & `DATA_MASK)
    // masking the rdata to make debug easy
    
    if(req.temp==req.rdata)
    $display($time,"===========rdata and wdata matched=============");
      else
    $display($time,"=========rdata and wdata missmatched===========");

//$finish;
#200;

endtask:body 

//******************************************************************
// TEST_SEQUNCES-3: setting register values and sending data to UART
//******************************************************************  


class apb_write extends apb_sequence;
`uvm_object_utils(apb_write)

//*****************************Methods******************************
extern function new(string name="apb_write");
extern task body();
endclass:apb_write

//****************************Constructor***************************
function apb_write::new(string name="apb_write");
  super.new(name);
endfunction:new

//*************************apb_write methods************************
task apb_write::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   // phase.raise_objection(this);
  
   begin  
   start_item(req);             //setting Buaddiv value 
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
    finish_item(req);

    end
     
   
    begin
    start_item(req);            //setting control register for APB
    assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL;
                              });
   finish_item(req);
   end
  
  
 
   begin
   start_item(req);            //setting data value 
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                              });
   finish_item(req);
 end
 
//Delay for required output   
 #75000;

endtask:body


//*******************************************************************
// TEST_SEQUNCES-4:setting register values and sending data from UART
//******************************************************************* 

class apb_control_rx extends apb_sequence;
`uvm_object_utils(apb_control_rx)
//*****************************Methods*******************************
extern function new(string name="apb_control_rx");
extern task body();
endclass:apb_control_rx

//***************************Constructor*****************************
function apb_control_rx::new(string name="apb_control_rx");
  super.new(name);
endfunction:new

//**********************apb_control_rx method************************
task apb_control_rx::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   
   begin
   start_item(req);            //setting Buaddiv value
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
    finish_item(req);
    end
    
    begin
    start_item(req);            //setting control register for UART
    assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL_RX;
                              });
    finish_item(req);
    end
 
    begin
    wait(uart_env_cfg.interrupt==1)
    begin
     
    start_item(req);            //reading data value
    assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==read;
                              });
    finish_item(req);
    uart_env_cfg.interrupt=0;
    
    end
    end
endtask:body


//*************************************************************************
//TEST_SEQUNCES-5:Setting register values and sending MULTIPLE data to UART
//*************************************************************************  


class apb_multi_write extends apb_sequence;
`uvm_object_utils(apb_multi_write)

//****************************Methods*********************************
extern function new(string name="apb_multi_write");
extern task body();
endclass:apb_multi_write

//*****************************Constructor****************************
function apb_multi_write::new(string name="apb_multi_write");
  super.new(name);
endfunction:new

//**********************apb_multi_write method************************
task apb_multi_write::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   begin
   start_item(req);            //setting Buaddiv value
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
   finish_item(req);
   end
   begin
   start_item(req);            //setting control register for APB
   assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL;
                              });
   finish_item(req);
   end
   begin
   start_item(req);          //setting data value
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                              });
   finish_item(req);
   end
   #75000;
   begin
   start_item(req);            //setting data value
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                              });
   finish_item(req);
   end
  #90000;
endtask:body 

//*************************************************************************
// TEST_SEQUNCES-6:setting register values and sending multi data from UART
//*************************************************************************  


class apb_control_multi_rx extends apb_sequence;
`uvm_object_utils(apb_control_multi_rx)

//*****************************Methods********************************
extern function new(string name="apb_control_multi_rx");
extern task body();
endclass:apb_control_multi_rx

//****************************Constructor*****************************
function apb_control_multi_rx::new(string name="apb_control_multi_rx");
  super.new(name);
endfunction:new

//******************apb_control_multi_rx method************************
task apb_control_multi_rx::body();
super.body();
 req=apb_xtn::type_id::create("apb_xtn");
   begin
   start_item(req);            //setting bauddiv value
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
    finish_item(req);
    end
    
    begin
    start_item(req);            //setting control register for UART
    assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL_RX;
                              });
   finish_item(req);
   end
endtask:body


//*********************************************************************
// TEST_SEQUNCES-7:setting register values and same time read and write
//*********************************************************************

class apb_write_read extends apb_sequence;
`uvm_object_utils(apb_write_read)

//******************************Methods*****************************
extern function new(string name="apb_write_read");
extern task body();
endclass:apb_write_read

//******************************Constructor*************************
function apb_write_read::new(string name="apb_write_read");
  super.new(name);
endfunction:new

//*********************apb_write_read methods***********************
task apb_write_read::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   begin
   start_item(req);            //setting buaddiv value
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
   finish_item(req);
   end
   
   begin
   start_item(req);            //setting control register for APB
   assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL;
                              });
   finish_item(req);
   end
   
   begin
   start_item(req);            //setting data value
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                               // wdata==`DATA;
                              });
   finish_item(req);
   end
   
   begin
   start_item(req);            //setting control register for uart 
   assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL_RX;
                              });
   finish_item(req);
   end
 
  #65000;
  begin
   
  start_item(req);            //read data value
  assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==read;
                              });
  finish_item(req);
  end

endtask:body 


//*****************************************************************************
// TEST_SEQUNCES-8:setting register values and sending data from UART (RX over)
//*****************************************************************************  


class apb_control_rx_over extends apb_sequence;
`uvm_object_utils(apb_control_rx_over)
//*****************************Methods*******************************
extern function new(string name="apb_control_rx_over");
extern task body();
endclass:apb_control_rx_over

//***************************Constructor*****************************
function apb_control_rx_over::new(string name="apb_control_rx_over");
  super.new(name);
endfunction:new

//*****************apb_control_rx_over method************************
task apb_control_rx_over::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   begin
   start_item(req);            //setting Buaddiv value
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
    finish_item(req);
  end
  
  begin
  start_item(req);            //setting control register for UART
  assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL_RX;
                              });
  finish_item(req);
  end

endtask:body


//*******************************************************************************
// TEST_SEQUNCES-9: setting register values and sending data to UART (TX over)
//******************************************************************************* 

//////////////////////////////////////////////////
//BEFORE RUNNING SET tx_overrun in DUT set to HIGH
//////////////////////////////////////////////////

 
class apb_tx_overrun extends apb_sequence;
`uvm_object_utils(apb_tx_overrun)

//*****************************Methods******************************
extern function new(string name="apb_tx_overrun");
extern task body();
endclass:apb_tx_overrun

//****************************Constructor***************************
function apb_tx_overrun::new(string name="apb_tx_overrun");
  super.new(name);
endfunction:new

//*************************apb_write methods************************
task apb_tx_overrun::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   // phase.raise_objection(this);
  
begin

//force top.DUT.tx_ovverrun=1;

   begin  
   start_item(req);             //setting Buaddiv value 
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
    finish_item(req);

    end
     
   
    begin
    start_item(req);            //setting control register for APB
    assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL;
                              });
   finish_item(req);
   end
  
  
 
   begin
   start_item(req);            //setting data value 
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                                wdata==`DATA;
                              });
   finish_item(req);
 end
 
  
   #75000;
//release top.DUT.tx_overrun;

end
endtask:body


//*******************************************************************************
//ISR TEST_SEQUENCE
//*******************************************************************************

class isr_seq extends apb_sequence;
  `uvm_object_utils(isr_seq)
  
  extern function new(string name="isr_seq");
  extern task body();
endclass:isr_seq

//Contructor
 
function isr_seq::new(string name="isr_seq");
  super.new(name);
endfunction:new

//task body
task isr_seq::body(); 
begin
  req=apb_xtn::type_id::create("req");
 
 
 `uvm_info(get_type_name(),"Checking the status of Interrupt",UVM_MEDIUM)
   begin
  start_item(req);
    assert(req.randomize()with {addr==`STATUS_REG_PADD  ;
                               trans_type==read;          
                                });
   finish_item(req); 

 `uvm_info(get_type_name(),"status read complete",UVM_MEDIUM)
   end
 
 `uvm_info(get_type_name(),"Clear the Interrupt",UVM_MEDIUM)
    

 begin
  start_item(req);            //setting control register for UART
  assert (req.randomize()with { addr==`INTSTATUS_INTCLEAR;
                                trans_type==write;
                                wdata==4'b1111;
                              });
  finish_item(req);
  `uvm_info(get_type_name(),"Cleared Interrupt",UVM_MEDIUM)
  end

    
 
end
    
endtask



//******************************************************************
// TEST_SEQUNCES-10: setting register values and sending data to UART
//******************************************************************  


class apb_write_cb extends apb_sequence;
`uvm_object_utils(apb_write_cb)

//*****************************Methods******************************
extern function new(string name="apb_write_cb");
extern task body();
endclass:apb_write_cb

//****************************Constructor***************************
function apb_write_cb::new(string name="apb_write_cb");
  super.new(name);
endfunction:new

//*************************apb_write methods************************
task apb_write_cb::body();
super.body();
   req=apb_xtn::type_id::create("apb_xtn");
   // phase.raise_objection(this);
  
   begin 
   req.call_back=1; 
   start_item(req);             //setting Buaddiv value 
   assert (req.randomize()with {  addr==`BAUDDIV_REG_PADD;
                                  trans_type==write;
                                  wdata==`BAUDDIVE;
                                });
    finish_item(req);
    req.call_back=0;
    end
     
   
    begin
    start_item(req);            //setting control register for APB

//	req.call_back=1;

    assert (req.randomize()with { addr==`CONTROL_REG_PADD;
                                trans_type==write;
                                wdata==`CONTROL;
                              });
   finish_item(req);
  // 	req.call_back=0;
   end
  
  
   begin
	   req.call_back=1;
   start_item(req);            //setting data value 
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                              });
   finish_item(req);
   	req.call_back=0;
 end


   begin
   start_item(req);            //setting data value 
   assert (req.randomize()with { addr==`DATA_REG;
                                trans_type==write;
                              });
   finish_item(req);
 end
 

//Delay for required output   
 #75000;

endtask:body


//************************************************************************
//		Sequence 1
//		RAL sequence with adapter
class reg_sequence extends apb_sequence;
	
	//Factory registration
	`uvm_object_utils(reg_sequence)
int data = 8'hAA;
//int data;
     uvm_status_e               status;
     uvm_reg_data_t             value;
//******************Constructor*****************    
function new(string name= "reg_sequence");
	super.new(name);
endfunction

//**********************************************
task body();
     super.body();


	  // data=apb_rb.d_reg.get(); 
	  apb_rb.d_reg.write(status,data,.parent(this));
	  $display ($time, "TIME : \n"); 
	
	   apb_rb.d_reg.set(8'hAA);		//To set the desired value in RAL
 	apb_rb.d_reg.read(status,value,.parent(this));
	//value=apb_rb.d_reg.get_mirrored_value();
	$display("value=%0d",value);

       //apb_rb.d_reg.peek(status,value,.parent(this));  

	  //apb_rb.d_reg.update(status,(UVM_FRONTDOOR),.parent(this));
  endtask
endclass

