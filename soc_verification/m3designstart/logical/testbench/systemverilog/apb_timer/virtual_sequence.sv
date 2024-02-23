class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(virtual_sequence)
  
  virtual apb_timer_if vif;
  virtual_sequencer virtual_seqr;
  
  //===agent_sequencers handles===//
  apb_sequencer apb_seqr;
  timer_sequencer timer_seqr; 
  reset_sequencer reset_seqr;
  
  env_config  env_cfg;
  
  
  //////////---test_case_1---////////// 
    wr_rd_all_reg apb_tc_1;
    psel_penable_comb apb_tc_2;
    wr_rd_timer_reg apb_tc_3;
    pid_cid_checks apb_tc_4;
    extin_disable apb_tc_5;
    change_reload_val apb_tc_6;
    set_timer_fr_isr apb_tc_7;
    timer_test_case_1 timer_tc_1; 
    timer_test_case_2 timer_tc_2; 
    ISR isr;
  
  //apb reset & set test_sequences
    reset_sequence_case reset_seq; 
    set_sequence  set_seq;
  extern function new(string name="virtual_sequence");
  extern task body();
endclass

//=======================================================================================
//construct the class
//=======================================================================================

function virtual_sequence::new(string name="virtual_sequence");
	super.new(name);
endfunction 

//=======================================================================================
//body of base class virtual sequence
//=======================================================================================

task virtual_sequence::body();
       	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db, Have to set() it")           
  
  assert($cast(virtual_seqr, m_sequencer)) 
  else
  begin
	  `uvm_fatal(get_full_name(), "Virtual Sequencer cast failed!") 
  end
    
      apb_seqr = virtual_seqr.apb_seqr;
      timer_seqr = virtual_seqr.timer_seqr;
      reset_seqr= virtual_seqr.reset_seqr; 
endtask


//=======================================================================
//virtual_sequence_1
//=======================================================================
class virtual_test_case_1 extends virtual_sequence;
	`uvm_object_utils(virtual_test_case_1)
  
  extern function new(string name="virtual_test_case_1"); 
  extern task body();
endclass

//construct extendend class
function virtual_test_case_1:: new(string name="virtual_test_case_1");
	super.new(name); endfunction 

//body method for virtual_test_case_1

task virtual_test_case_1::body();
  
  if(!uvm_config_db
	  #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
  `uvm_fatal("INT_TEMP","NOT getting from config Have to set() it")
  super.body();
  
  apb_tc_1=wr_rd_all_reg::type_id::create("apb_tc_1");
  timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");
  isr=ISR::type_id::create("isr");
  `uvm_info(get_name(),"start of fork from virtual seq",UVM_LOW)
  fork 
    apb_tc_1.start(apb_seqr);
    timer_tc_1.start(timer_seqr);
  join
      
endtask 


//=======================================================================
//virtual_sequence_2
//=======================================================================
class virtual_test_case_2 extends virtual_sequence;
	`uvm_object_utils(virtual_test_case_2)
  
  extern function new(string name="virtual_test_case_2"); 
  extern task body();
endclass

//construct extendend class
function virtual_test_case_2:: new(string name="virtual_test_case_2");
	super.new(name); 
endfunction 

//body method for virtual_test_case_2

task virtual_test_case_2::body(); super.body();
	apb_tc_2=psel_penable_comb::type_id::create("apb_tc_2");
	timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1"); 
fork
	apb_tc_2.start(apb_seqr); 
	timer_tc_1.start(timer_seqr);
join
 endtask 


//=======================================================================
//virtual_sequence_3
//=======================================================================
class virtual_test_case_3 extends virtual_sequence;
	`uvm_object_utils(virtual_test_case_3)
  
  extern function new(string name="virtual_test_case_3"); 
  extern task body();
endclass

//construct extendend class
function virtual_test_case_3:: new(string name="virtual_test_case_3");
	super.new(name); 
endfunction 

//body method for virtual_test_case_3

task virtual_test_case_3::body(); super.body();
	apb_tc_3=wr_rd_timer_reg::type_id::create("apb_tc_3");
	timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");
//	reset_seq=reset_sequence_case::type_id::create("reset_seq"); 
  
    
     fork 
     apb_tc_3.start(apb_seqr); 
     timer_tc_1.start(timer_seqr);
    // reset_seq.start(apb_seqr);

     join 
endtask 


//=======================================================================
//virtual_sequence_4
//=======================================================================
class virtual_test_case_4 extends virtual_sequence;
	`uvm_object_utils(virtual_test_case_4)
  
  extern function new(string name="virtual_test_case_4"); 
  extern task body();
endclass

//construct extendend class
function virtual_test_case_4:: new(string name="virtual_test_case_4");
	super.new(name); 
endfunction 

//body method for virtual_test_case_4

task virtual_test_case_4::body();
       	super.body();
	apb_tc_4=pid_cid_checks::type_id::create("apb_tc_4");
	timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");

begin 
    
     fork
        apb_tc_4.start(apb_seqr);
        timer_tc_1.start(timer_seqr);
    join
end
    
endtask 


//=======================================================================
// virtual_sequence_5
//=======================================================================
class virtual_test_case_5 extends virtual_sequence;
  `uvm_object_utils(virtual_test_case_5)
  
  extern function new(string name="virtual_test_case_5");
  extern task body();
endclass

//construct extendend class
function virtual_test_case_5:: new(string name="virtual_test_case_5");
  super.new(name);
endfunction 

//body method for virtual_test_case_5

task virtual_test_case_5::body();
  super.body();
  apb_tc_5=extin_disable::type_id::create("apb_tc_5");
  timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");
  timer_tc_2=timer_test_case_2::type_id::create("timer_tc_2");   
     fork
        apb_tc_5.start(apb_seqr);
        timer_tc_1.start(timer_seqr);
        #400 timer_tc_2.start(timer_seqr);
     join     
endtask 


//=======================================================================
// virtual_sequence_6
//=======================================================================
class virtual_test_case_6 extends virtual_sequence;
  `uvm_object_utils(virtual_test_case_6)
  
  extern function new(string name="virtual_test_case_6");
  extern task body();
endclass

//construct extendend class
function virtual_test_case_6:: new(string name="virtual_test_case_6");
  super.new(name);
endfunction 

//body method for virtual_test_case_6

task virtual_test_case_6::body();
  super.body();
  apb_tc_6=change_reload_val::type_id::create("apb_tc_6");
 timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");
   
     fork
        apb_tc_6.start(apb_seqr);
        timer_tc_1.start(timer_seqr);
     join
endtask                                              
//=======================================================================
// virtual_sequence_7
//=======================================================================
class virtual_test_case_7 extends virtual_sequence;
  `uvm_object_utils(virtual_test_case_7)
  
  extern function new(string name="virtual_test_case_7");
  extern task body();
endclass

//construct extendend class
function virtual_test_case_7:: new(string name="virtual_test_case_7");
  super.new(name);
endfunction 

//body method for virtual_test_case_7

task virtual_test_case_7::body();
  if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
        `uvm_fatal("INT_TEMP","NOT getting from config Have to set() it")
  super.body();
  
  apb_tc_7=set_timer_fr_isr::type_id::create("apb_tc_7");
  timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");
  isr=ISR::type_id::create("isr");

 
    fork
       apb_tc_7.start(apb_seqr);
       timer_tc_1.start(timer_seqr);
	
      `uvm_info("VIRTUAL_SEQUENCE",$sformatf("INT_STATUS before register from ENV_CONFIG PRDATA=%X \n",env_cfg.INT_TEMP),UVM_LOW)
    begin
             
      `uvm_info("VIRTUAL_SEQUENCE_7",$sformatf("INSIDE BEGIN ENV_CONFIG PRDATA=%X \n",env_cfg.INT_TEMP),UVM_LOW)
      wait(env_cfg.INT_TEMP==1)
       `uvm_info("INTERRUPT",$sformatf("INT_STATUS after register from ENV_CONFIG PRDATA=%X \n",env_cfg.INT_TEMP),UVM_LOW)
        isr.start(apb_seqr);
end
join
          
endtask



//=======================================================================
// virtual_sequence_8(reset_sequence)
//=======================================================================
class virtual_test_case_8 extends virtual_sequence;
  `uvm_object_utils(virtual_test_case_8)
  
  extern function new(string name="virtual_test_case_8");
  extern task body();
endclass

//construct extendend class
function virtual_test_case_8:: new(string name="virtual_test_case_8");
  super.new(name);
endfunction 

//body method for virtual_test_case_8

task virtual_test_case_8::body();
  super.body();
  apb_tc_3=wr_rd_timer_reg::type_id::create("apb_tc_3");
  timer_tc_1=timer_test_case_1::type_id::create("timer_tc_1");
  reset_seq=reset_sequence_case::type_id::create("reset_seq");


     fork
        apb_tc_3.start(apb_seqr);
        timer_tc_1.start(timer_seqr);
 	#100 reset_seq.start(reset_seqr);
     join
endtask          



//=======================================================================
// virtual_sequence_9 >>>>>>RAL SEQUENCE
//=======================================================================
class register_vir extends virtual_sequence;
  `uvm_object_utils(register_vir)

  register_seq   seq;

  extern function new(string name="register_vir");
  extern task body();
endclass

function register_vir:: new(string name="register_vir");
  super.new(name);
endfunction 


task register_vir::body();
  super.body();
  seq=register_seq::type_id::create("seq");   

  begin
 	seq.start(apb_seqr);
  end
endtask 

