/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart driver class
 Filename:   	uart_driver.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_driver extends uvm_driver#(uart_xtn); //write parameterised argument
  `uvm_component_utils(uart_driver)
  
// Interface Handles 
	virtual intf_UART.SDRV_MP vif1;
  
// Agent configuration handles 
	uart_agent_config s_cfg;
  
//transcation handle
  	apb_xtn txn;

//*******************************Methods******************************* 
  extern function new(string name="uart_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(uart_xtn xtn);
endclass:uart_driver

//*******************************Constrctor******************************
function uart_driver::new(string name="uart_driver", uvm_component parent);
  super.new(name,parent);
endfunction:new
 
//**********************************Build_phase**********************************
function void uart_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(uart_agent_config)::get(this,"*","uart_agent_config",s_cfg))
    `uvm_fatal("DRIVER_VIF0","get interface to uart_driver")
endfunction:build_phase

//*****************************connect_phase****************************
function void uart_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif1=s_cfg.vif1;
endfunction:connect_phase

//********************************Run_phase*****************************
task uart_driver::run_phase(uvm_phase phase);
  
forever 
  begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end

endtask:run_phase 
//*****************************send_to_dut******************************
task uart_driver::send_to_dut(uart_xtn xtn);
  
  begin
      @(posedge vif1.sdrv_cb.BAUDTICK)
      vif1.sdrv_cb.RXD<=xtn.RXD;
      $display("RXD=%d",xtn.RXD);
      
      for(int i=0;i<16;i++)
        begin
          @(posedge vif1.sdrv_cb.BAUDTICK)
          $display($time," driver BUADTICK");
        end  
  end

endtask:send_to_dut
