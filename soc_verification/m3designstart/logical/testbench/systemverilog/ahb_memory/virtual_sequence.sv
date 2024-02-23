//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : virtual sequence
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(virtual_sequence)
  
  virtual_sequencer virtual_seqr;   //virtual sequencer handle
  
  master_sequencer master_seqr;   //master sequencer handle
  master_agent_config m_cfg;      //master agent config handle
  env_config  env_cfg;            //environment config handle

  byte_test_seq 	 ahb_tc_1;        //master testcase_1 handle which is written in master_sequence
  half_word_seq 	 ahb_tc_2;        //msater testcase_2 handle which is written in master_sequence
  word_test_seq 	 ahb_tc_3;        //msater testcase_3 handle which is written in master_sequence
  variable_size_test_seq ahb_tc_4;        //msater testcase_4 handle which is written in master_sequence
  default_value_test_seq ahb_tc_5;	  //master testcase_5 handle which is written in master_sequence
  mem_test_seq ahb_tc_6; 

//***************************Extern functions*********************************************************  
 extern function new(string name="virtual_sequence");
 extern task body();
endclass

//*********************************Constractor*********************************************************
function virtual_sequence::new(string name="virtual_sequence");
  super.new(name);
endfunction 

//*********************************task body*********************************************************
task virtual_sequence::body();
  if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
    `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it")           
assert($cast(virtual_seqr, m_sequencer))
  else 
    begin
      `uvm_fatal(get_full_name(), "Virtual Sequencer cast failed!")
    end
       master_seqr = virtual_seqr.master_seqr;
endtask 



//==================================================================================================
//-----Test_case_1
//-----HSIZE==000
//==================================================================================================
class vir_byte_test_seq extends virtual_sequence;
	`uvm_object_utils(vir_byte_test_seq)

//***************************Extern functions********************************************************  
	extern function new(string name="vir_byte_test_seq");
	extern task body();
endclass

//*********************************Constractor*******************************************************
function vir_byte_test_seq::new(string name="vir_byte_test_seq");
super.new(name);
endfunction

//*********************************task body********************************************************
task vir_byte_test_seq::body();
super.body();
ahb_tc_1=byte_test_seq::type_id::create("ahb_tc_1");

   fork
	ahb_tc_1.start(master_seqr);
   join
endtask


//===================================================================================================
//-----Test_case_2
//-----HSIZE==001
//===================================================================================================
class vir_half_word_test extends virtual_sequence;
  `uvm_object_utils(vir_half_word_test)
  
//***************************Extern functions********************************************************  
extern function new(string name="vir_half_word_test");
extern task body();
endclass

//*********************************Constractor*******************************************************
function vir_half_word_test::new(string name="vir_half_word_test");
  super.new(name);
endfunction

//*********************************task body********************************************************
task vir_half_word_test::body();
  super.body();
  
  ahb_tc_2=half_word_seq::type_id::create("ahb_tc_2");
  fork
    ahb_tc_2.start(master_seqr);
  join
endtask


//===================================================================================================
//-----Test_case_3
//-----HSIZE==010
//===================================================================================================
class vir_word_test_seq extends virtual_sequence;
  `uvm_object_utils(vir_word_test_seq)
  
//***************************Extern functions********************************************************  
extern function new(string name="vir_word_test_seq");
extern task body();
endclass

//*********************************Constractor*******************************************************
function vir_word_test_seq::new(string name="vir_word_test_seq");
  super.new(name);
endfunction

//*********************************task body********************************************************
task vir_word_test_seq::body();
  super.body();
  
  ahb_tc_3=word_test_seq::type_id::create("ahb_tc_3");
  fork
    ahb_tc_3.start(master_seqr);
  join
endtask


//===================================================================================================
//-----Test_case_4
//-----HSIZE==000,001,010
//===================================================================================================
class vir_variable_size_test_seq extends virtual_sequence;
  `uvm_object_utils(vir_variable_size_test_seq)
  
//***************************Extern functions********************************************************  
extern function new(string name="vir_variable_size_test_seq");
extern task body();
endclass

//*********************************Constractor*******************************************************
function vir_variable_size_test_seq::new(string name="vir_variable_size_test_seq");
  super.new(name);
endfunction

//*********************************task body********************************************************
task vir_variable_size_test_seq::body();
  super.body();
  
  ahb_tc_4=variable_size_test_seq::type_id::create("ahb_tc_4");
  fork
    ahb_tc_4.start(master_seqr);
  join
endtask

//===================================================================================================
//-----Test_case_5
//-----
//===================================================================================================
class vir_default_value_test_seq extends virtual_sequence;
  `uvm_object_utils(vir_default_value_test_seq)
  
//***************************Extern functions********************************************************  
extern function new(string name="vir_default_value_test_seq");
extern task body();
endclass

//*********************************Constractor*******************************************************
function vir_default_value_test_seq::new(string name="vir_default_value_test_seq");
  super.new(name);
endfunction

//*********************************task body********************************************************
task vir_default_value_test_seq::body();
  super.body();
  
  ahb_tc_5=default_value_test_seq::type_id::create("ahb_tc_5");
  fork
    ahb_tc_5.start(master_seqr);
  join
endtask

//===================================================================================================
//-----Test_case_6
//-----
//===================================================================================================
class vir_mem_test_seq extends virtual_sequence;
  `uvm_object_utils(vir_mem_test_seq)
  
//***************************Extern functions********************************************************  
extern function new(string name="vir_mem_test_seq");
extern task body();
endclass

//*********************************Constractor*******************************************************
function vir_mem_test_seq::new(string name="vir_mem_test_seq");
  super.new(name);
endfunction

//*********************************task body********************************************************
task vir_mem_test_seq::body();
  super.body();
  
  ahb_tc_6=mem_test_seq::type_id::create("ahb_tc_6");
  fork
    ahb_tc_6.start(master_seqr);
  join
endtask







