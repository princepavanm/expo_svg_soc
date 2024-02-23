/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	virtual sequence class
 Filename:   	virtual_sequence.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(virtual_sequence)
  
//virtual sequence contains,virtual sequencer,main sequencer,
//environment config and SEQUENCE(apb_write)

// Handles of all sequencers  
  virtual_sequencer vsqr;
  apb_sequencer sqr;
  uart_env_config uart_env_cfg;
  uart_sequencer sequencer;
  reset_sequencer rst_sqr;
  
 
  
//SEQUENCE-1:read the default value of program model register  
apb_reset_seq apb_reset_obj;                    

//SEQUENCE-2:write and read the value from register
apb_write_read_check write_read_check;          

//SEQUENCE-3:set Buaddiv and control reg and wrtie the data on TXD
apb_write write;                                 


//SEQUENCE-4:set control and bauddiv value from abp sequence 
apb_control_rx apb_rx_control;        
//SEQUENCE-4:from uart, write data on RXD and read at ABP side          
uart_write rx_write;                            


//SEQUENCE-5:Setting register values and sending MULTIPLE data to UART
apb_multi_write multi_write;                    


//SEQUENCE-6:set control and bauddiv value from abp sequence
apb_control_multi_rx  apb_multi_rx_control;
//SEQUENCE-6:use repeat loop in UART sequence and sending multi data from UART      
uart_multi_write write_rx_multi;                


//SEQUENCE-7: write and read simultaniously set control register value
apb_write_read  write_read;                    
//SEQUENCE-7:from uart write data on RXD and read at ABP side 
uart_write_read  read_write;                    


//SEQUENCE-8: setting control register value for rx_over
apb_control_rx_over  apb_rx_over_control;     
//SEQUENCE-8: sending RXD value more then 8 bit for Rx_over  
uart_rx_over rx_over;                           


//SEQUENCE-9:set Buaddiv and control reg and wrtie the data on TXD for Txoverrun
apb_tx_overrun tx_over;                          

//ISR_SEQUENCE: Used to clear interrupt
isr_seq ISR_SEQ;

//SEQUENCE-10:Checking call back
apb_write_cb write_cb;                                 

//SEQUENCE -11:Register sequence for data_reg 
reg_sequence reg_seq;

//*******************************Methods***********************************  
extern function new(string name="virtual_sequence");
extern task body();  
endclass:virtual_sequence

//*****************************Constructor*********************************
function virtual_sequence :: new(string name="virtual_sequence");
  super.new(name);
endfunction:new

//****************************body Method**********************************
task virtual_sequence::body();
  if(!uvm_config_db#(uart_env_config)::get(null,get_full_name(),"uart_env_config",env_cfg))
    
    // use null here dont use this
    
    `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it")
    sqr=new[env_cfg.has_apb_agent];
    sequencer=new[env_cfg.has_uart_agent];
    rst_sqr=new[env_cfg.has_reset_agent];

    
    assert($cast(vsqr,m_sequencer))
  else
    begin
       `uvm_fatal(get_full_name(), "Virtual Sequencer cast failed!")
    end
    
    //connect virtual sequencer with actual sequencer
   // sqr=vsqr.sqr;
    //sequencer=vsqr.sequencer;
  
  endtask:body
  

//****************************************************************************
//////////////SEQUENCE-1
//****************************************************************************
class apb_reset_virtual_seq extends virtual_sequence;
    `uvm_object_utils(apb_reset_virtual_seq)

  //*******************************Methods***********************************
    extern function new(string name="apb_reset_virtual_seq");
    extern task body();
  endclass:apb_reset_virtual_seq
  
  //**************************Constructor************************************
  function apb_reset_virtual_seq::new(string name="apb_reset_virtual_seq");
    super.new(name);
  endfunction:new
  
  
  //****************************body method***********************************
  task apb_reset_virtual_seq::body();
    super.body();
  apb_reset_obj= apb_reset_seq::type_id::create("apb_reset_obj"); //SEQUENCE-1                    
    
  fork
  env_cfg.reset_flag=1;
  apb_reset_obj.start(sqr);	//SEQUENCE-1
  join

endtask:body    

//****************************************************************************
////////////SEQUENCE-2
//****************************************************************************
class apb_write_read_virtual_seq extends virtual_sequence;
    `uvm_object_utils(apb_write_read_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="apb_write_read_virtual_seq");
    extern task body();
  endclass:apb_write_read_virtual_seq
  
  //**************************Constructor********************************************
  function apb_write_read_virtual_seq::new(string name="apb_write_read_virtual_seq");
    super.new(name);
  endfunction:new
  
  
  //****************************body method******************************************
  task apb_write_read_virtual_seq::body();
    super.body();
    write_read_check=apb_write_read_check::type_id::create("write_read_check");  //SEQUENCE-2
    
  fork
  env_cfg.write_read_flag=1;
  write_read_check.start(sqr);	//SEQUENCE-2
  join

endtask:body  

//****************************************************************************
////////////SEQUENCE-3
//****************************************************************************
class TX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(TX_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="TX_virtual_seq");
    extern task body();
  endclass:TX_virtual_seq
  
  //**************************Constructor************************************
  function TX_virtual_seq::new(string name="TX_virtual_seq");
    super.new(name);
  endfunction:new
  
  //****************************body method***********************************
  task TX_virtual_seq::body();
    super.body();
     write=apb_write::type_id::create("write");                  //SEQUENCE-3
    ISR_SEQ=isr_seq::type_id::create("ISR_SEQ"); 		 //ISR
  
  fork
  env_cfg.TX_test_flag=1;
  write.start(sqr);	//SEQUENCE-3
  begin
  wait(env_cfg.interrupt==1)  
  ISR_SEQ.start(sqr);
  end
  join

 
endtask:body  

//****************************************************************************
////////////SEQUENCE-4
//****************************************************************************
class RX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(RX_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="RX_virtual_seq");
    extern task body();
  endclass:RX_virtual_seq
  
  //**************************Constructor************************************
  function RX_virtual_seq::new(string name="RX_virtual_seq");
    super.new(name);
  endfunction:new
  
  //*********************************body method***********************************
  task RX_virtual_seq::body();
    super.body();
    apb_rx_control=apb_control_rx::type_id::create("apb_rx_control"); //SEQUENCE-4
    rx_write=uart_write::type_id::create("rx_write");                 //SEQUENCE-4 
    ISR_SEQ=isr_seq::type_id::create("ISR_SEQ"); 		      //ISR

  fork
  env_cfg.RX_test_flag=1;
  apb_rx_control.start(sqr);	//SEQUENCE-4
  rx_write.start(sequencer);	//SEQUENCE-4
  begin
  wait(env_cfg.interrupt==1)  
  ISR_SEQ.start(sqr);
  end
  join

endtask:body

//****************************************************************************
////////////SEQUENCE-5
//****************************************************************************
class Multi_TX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(Multi_TX_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="Multi_TX_virtual_seq");
    extern task body();
  endclass:Multi_TX_virtual_seq
  
  //**************************Constructor************************************
  function Multi_TX_virtual_seq::new(string name="Multi_TX_virtual_seq");
    super.new(name);
  endfunction:new
  
  //****************************body method***********************************
  task Multi_TX_virtual_seq::body();
    super.body();
    multi_write=apb_multi_write::type_id::create("multi_write");  //SEQUENCE-5
    ISR_SEQ=isr_seq::type_id::create("ISR_SEQ"); 		  //ISR
   
   fork
  env_cfg.Multi_Tx_test_flag=1;
  multi_write.start(sqr);	//SEQUENCE-5
  begin
  wait(env_cfg.interrupt==1)  
  ISR_SEQ.start(sqr);
  end
  join

endtask:body  

//****************************************************************************
////////////SEQUENCE-6
//****************************************************************************
class Multi_RX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(Multi_RX_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="Multi_RX_virtual_seq");
    extern task body();
  endclass:Multi_RX_virtual_seq
  
  //**************************Constructor************************************
  function Multi_RX_virtual_seq::new(string name="Multi_RX_virtual_seq");
    super.new(name);
  endfunction:new
  
  //*******************************************body method********************************************
  task Multi_RX_virtual_seq::body();
    super.body();
    apb_multi_rx_control=apb_control_multi_rx::type_id::create("apb_multi_rx_control");   //SEQUENCE-6
    write_rx_multi=uart_multi_write::type_id::create("write_rx_multi");         
    ISR_SEQ=isr_seq::type_id::create("ISR_SEQ"); 		      			  //ISR

    fork
  env_cfg.Multi_Rx_test_flag=1;
  apb_multi_rx_control.start(sqr);	//SEQUENCE-6   
  write_rx_multi.start(sequencer);	//SEQUENCE-6
   begin
  wait(env_cfg.interrupt==1)  
  ISR_SEQ.start(sqr);
  end
  join

endtask:body 

//****************************************************************************
////////////SEQUENCE-7
//****************************************************************************
class Tx_RX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(Tx_RX_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="Tx_RX_virtual_seq");
    extern task body();
  endclass:Tx_RX_virtual_seq
  
  //**************************Constructor************************************
  function Tx_RX_virtual_seq::new(string name="Tx_RX_virtual_seq");
    super.new(name);
  endfunction:new
  
  //****************************body method***********************************
  task Tx_RX_virtual_seq::body();
    super.body();
    write_read=apb_write_read::type_id::create("write_read");    //SEQUENCE-7
    read_write=uart_write_read::type_id::create("read_write");   //SEQUENCE-7
  
  fork
  env_cfg.Tx_Rx_test_flag=1;
  write_read.start(sqr);	//SEQUENCE-7
  read_write.start(sequencer);	//SEQUENCE-7
  begin
  wait(env_cfg.interrupt==1)
  $display("TX-RX operation");
  end  
 join

endtask:body 

//****************************************************************************
////////////SEQUENCE-8
//****************************************************************************
class Over_RX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(Over_RX_virtual_seq)
    uvm_event_pool  ev_pool;
    uvm_event ev_1;

  //*******************************Methods***********************************
    extern function new(string name="Over_RX_virtual_seq");
    extern task body();
  endclass:Over_RX_virtual_seq
  
  //**************************Constructor************************************
  function Over_RX_virtual_seq::new(string name="Over_RX_virtual_seq");
    super.new(name); 
  endfunction:new
  
  //**********************************************body method********************************************
  task Over_RX_virtual_seq::body();
    super.body();
    apb_rx_over_control=apb_control_rx_over::type_id::create("apb_rx_over_control");	//SEQUENCE-8
    rx_over=uart_rx_over::type_id::create("rx_over"); 					//SEQUENCE-8
   ISR_SEQ=isr_seq::type_id::create("ISR_SEQ");      					//ISR
   
 fork
  env_cfg.Over_Rx_test_flag=1;
  apb_rx_over_control.start(sqr);	//SEQUENCE-8
  rx_over.start(sequencer);		//SEQUENCE-8
  begin
  wait(env_cfg.interrupt==1)
  ISR_SEQ.start(sqr);
  end
join

endtask:body 

//****************************************************************************
////////////SEQUENCE-9
//****************************************************************************
class Over_TX_virtual_seq extends virtual_sequence;
    `uvm_object_utils(Over_TX_virtual_seq)
    
  //*******************************Methods***********************************
    extern function new(string name="Over_TX_virtual_seq");
    extern task body();
  endclass:Over_TX_virtual_seq
  
  //**************************Constructor************************************
  function Over_TX_virtual_seq::new(string name="Over_TX_virtual_seq");
    super.new(name);
  endfunction:new
  
  //****************************body method***********************************
  task Over_TX_virtual_seq::body();
    super.body();
    tx_over=apb_tx_overrun::type_id::create("tx_over");		//SEQUENCE-9     
  fork
  env_cfg.Over_Tx_test_flag=1;
  tx_over.start(sqr);		//SEQUENCE-9
  join

endtask:body 

                                       
//****************************************************************************
////////////SEQUENCE-10
//****************************************************************************
class TX_virtual_seq_cb extends virtual_sequence;
    `uvm_object_utils(TX_virtual_seq_cb)
    
  //*******************************Methods***********************************
    extern function new(string name="TX_virtual_seq_cb");
    extern task body();
  endclass:TX_virtual_seq_cb
  
  //**************************Constructor************************************
  function TX_virtual_seq_cb::new(string name="TX_virtual_seq_cb");
    super.new(name);
  endfunction:new
  
  //****************************body method***********************************
  task TX_virtual_seq_cb::body();
    super.body();
     write_cb=apb_write_cb::type_id::create("write_cb");                  //SEQUENCE-10
    //ISR_SEQ=isr_seq::type_id::create("ISR_SEQ"); 		 //ISR
  
  fork
  env_cfg.TX_test_cb_flag=1;
  write_cb.start(sqr);	//SEQUENCE-10
  begin
  //wait(env_cfg.interrupt==1)  
  //ISR_SEQ.start(sqr);
  end
  join

 
endtask:body  

//****************************************************************************
//SEQUENCE 11
//****************************************************************************
class vir_reg_sequence extends virtual_sequence;
`uvm_object_utils(vir_reg_sequence)

//*************************methods************************
extern function new (string name="vir_reg_sequence");
extern task body();
endclass

//*********************constructor***********************
function vir_reg_sequence:: new (string name="vir_reg_sequence");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_reg_sequence::body();
super.body();

reg_seq=reg_sequence::type_id::create("reg_sequence");

fork 
env_cfg.reg_seq_test_flag=1;
`uvm_info("VIRTUAL SEQUENCE T.C. 10","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
reg_seq.start(sqr);
join
endtask


