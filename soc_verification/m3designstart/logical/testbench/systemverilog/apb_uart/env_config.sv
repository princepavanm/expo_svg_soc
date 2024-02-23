/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	environment config
 Filename:   	uart_env_config.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_env_config extends uvm_object;
  `uvm_object_utils(uart_env_config)
  
  //register block
 uart_reg_block apb_rb;

 //component count
  bit has_magent=1;
  bit has_sagent=0;

	bit has_scoreboard=0;
	//bit has_wagent=1;
//	bit has_ragent=1;
	bit has_virtual_sequencer=0;
	
  //abp aget configuration handles
  apb_agent_config m_cfg;
  
  //uart agent configuration handle
  //uart_agent_config s_cfg;
 virtual APB_UART_if vif;
 //uvm_event_pool event_pool=uvm_event_pool::get_global_pool;

//Control flags 
/*logic reset_flag;
logic write_read_flag;
logic TX_test_flag;
logic RX_test_flag;
logic Multi_Tx_test_flag;
logic Multi_Rx_test_flag;
logic Tx_Rx_test_flag;
logic Over_Rx_test_flag;
logic Over_Tx_test_flag; 
logic interrupt;
logic TX_test_cb_flag;
logic reg_seq_test_flag;*/

//**************************Methods**************************** 
  extern function new(string name="uart_env_config");
endclass:uart_env_config

//************************Constrctor**************************
function uart_env_config :: new(string name="uart_env_config");
  super.new(name);
endfunction:new

