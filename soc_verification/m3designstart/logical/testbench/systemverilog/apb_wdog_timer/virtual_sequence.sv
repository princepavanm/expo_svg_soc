/**********************************************************
Author 		: Ramkumar 
File 		: virtual_sequence.sv
Module name     : virtual_sequence 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
	 `uvm_object_utils(virtual_sequence)
//Declare virtual sequencer
virtual_sequencer vir_seqrh;
//Declare sequencer handles
master_sequencer master_seqrh[];
slave_sequencer slave_seqrh[];
reset_sequencer reset_seqrh[];
//Declare reset valaue Sequence handles
apb_read_default_values apb_def_values;
wdog_read_default_values wdog_def_values;
//Declare wdogreset Sequence handles
apb_wdog_rst apb_wdogrst;
wdog_wdog_rst wdog_wdogrst;
//Declare wdog read write Sequence handles
apb_wr_rd_values apb_wr_rd;
wdog_wr_rd_values wdog_wr_rd;
//Declare wdog interrupt clear Sequence handles
apb_intrpt_rst apb_rst;
wdog_intrpt_rst wdog_rst;
//Declare wdog locked Sequence handles
apb_locked_reg apb_lock;
wdog_locked_reg wdog_lock;
//Declare integrtion mode handle for reset
apb_int_mode_rst apb_int_rst;
wdog_int_mode_rst wdog_int_rst;
//Declare integrtion mode handle for reset
apb_int_mode_int apb_int_int;
wdog_int_mode_int wdog_int_int;
//Declare handle for callback sequence
apb_intrpt_rst_cb apb_cb;
wdog_intrpt_rst_cb wdog_cb;
//Declare handle for callback sequence
apb_psel_cb apb_psel_h;
wdog_psel_cb wdog_psel_h;
//Declare cinfig file
env_config ver_cfg;

//Regsequence
reg_sequence reg_seq;
wdog_read_default_values wreg_seq;
//Desire frontdoor compare
seq_desire_front_comp de_fd_h;
//update and mirror method
seq_desire_mirror des_mirr_h;

//arbitration
apb_arb apb_arb_seq;
wdog_arb wdog_arb_seq;
//phases
reset rst_h;
reset1 rst1_h;
reset2 rst2_h;
apb_default apb_def;
apb_phase apb_phase_seq;
apb_reload apb_load;
wdog_phase wdog_phase_seq;
//*************************methods************************
extern function new (string name="virtual_sequence");
extern task body();
endclass:virtual_sequence

//*********************constructor***********************
function virtual_sequence :: new (string name="virtual_sequence");
	 super.new(name);
endfunction:new

task virtual_sequence::body();
begin
	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",ver_cfg))
	
		`uvm_fatal("VIRTUAL SEQUENCER","Unable to get in virtual sequence")
		master_seqrh=new[ver_cfg.has_master_agent];
		slave_seqrh=new[ver_cfg.has_slave_agent];
		reset_seqrh=new[ver_cfg.has_reset_agent];
		//do dynamic casting between virtual sequencer and m_sequencer
		assert($cast(vir_seqrh,m_sequencer))
		else
		begin
		`uvm_fatal("VIRTUAL SEQUENCE","Unable to cast virtual and m_sequencer")
		end
		foreach(master_seqrh[i])
			master_seqrh[i]=vir_seqrh.master_seqrh[i];
		foreach(slave_seqrh[i])
			slave_seqrh[i]=vir_seqrh.slave_seqrh[i];
		foreach(reset_seqrh[i])
			reset_seqrh[i]=vir_seqrh.reset_seqrh[i];
	`uvm_info("VIRTUAL SEQUENCE","///////In Body of Virtual Sequence////////",UVM_MEDIUM)
end
endtask:body

//==================================================================//
// T.C. 1 :Reading default values of DUT
//==================================================================//
class vir_default_values extends virtual_sequence;
`uvm_object_utils(vir_default_values)

//*************************methods************************
extern function new (string name="vir_default_values");
extern task body();
endclass

//*********************constructor***********************
function vir_default_values :: new (string name="vir_default_values");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_default_values::body();
super.body();
apb_def_values=apb_read_default_values::type_id::create("apb_def_values");
wdog_def_values=wdog_read_default_values::type_id::create("wdog_def_values");
fork
`uvm_info("VIRTUAL SEQUENCE T.C. 1","///////In Body of Virtual Sequence T.C. 1 ////////",UVM_MEDIUM)
apb_def_values.start(vir_seqrh.master_seqrh[0]);
wdog_def_values.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 2 :Generating watchdog reset of DUT
//==================================================================//
class vir_wdog_rst extends virtual_sequence;
`uvm_object_utils(vir_wdog_rst)

//*************************methods************************
extern function new (string name="vir_wdog_rst");
extern task body();
endclass

//*********************constructor***********************
function vir_wdog_rst:: new (string name="vir_wdog_rst");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_wdog_rst::body();
super.body();
apb_wdogrst=apb_wdog_rst::type_id::create("apb_wdogrst");
wdog_wdogrst=wdog_wdog_rst::type_id::create("wdog_wdogrst");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 2","///////In Body of Virtual Sequence T.C. 2 ////////",UVM_MEDIUM)
apb_wdogrst.start(vir_seqrh.master_seqrh[0]);
wdog_wdogrst.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 3 :Writting to all registers and then reading the same 
// to check the behaviour
//==================================================================//
class vir_wdog_wr_rd extends virtual_sequence;
`uvm_object_utils(vir_wdog_wr_rd)

//*************************methods************************
extern function new (string name="vir_wdog_wr_rd");
extern task body();
endclass

//*********************constructor***********************
function vir_wdog_wr_rd:: new (string name="vir_wdog_wr_rd");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_wdog_wr_rd::body();
super.body();
apb_wr_rd=apb_wr_rd_values::type_id::create("apb_wr_rd");
wdog_wr_rd=wdog_wr_rd_values::type_id::create("wdog_wr_rd");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 3","///////In Body of Virtual Sequence T.C. 3 ////////",UVM_MEDIUM)
apb_wr_rd.start(vir_seqrh.master_seqrh[0]);
wdog_wr_rd.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 4 :Clearing the interrupt after interrupt
//==================================================================//
class vir_wdog_intrpt_rst extends virtual_sequence;
`uvm_object_utils(vir_wdog_intrpt_rst)

//*************************methods************************
extern function new (string name="vir_wdog_intrpt_rst");
extern task body();
endclass

//*********************constructor***********************
function vir_wdog_intrpt_rst:: new (string name="vir_wdog_intrpt_rst");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_wdog_intrpt_rst::body();
super.body();
apb_rst=apb_intrpt_rst::type_id::create("apb_rst");
wdog_rst=wdog_intrpt_rst::type_id::create("wdog_rst");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 4","///////In Body of Virtual Sequence T.C. 4 ////////",UVM_MEDIUM)
apb_rst.start(vir_seqrh.master_seqrh[0]);
wdog_rst.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 5 : Locking the watchdog to disable the write access
//==================================================================//
class vir_locked_reg extends virtual_sequence;
`uvm_object_utils(vir_locked_reg)

//*************************methods************************
extern function new (string name="vir_locked_reg");
extern task body();
endclass

//*********************constructor***********************
function vir_locked_reg:: new (string name="vir_locked_reg");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_locked_reg::body();
super.body();
apb_lock=apb_locked_reg::type_id::create("apb_rst");
wdog_lock=wdog_locked_reg::type_id::create("wdog_rst");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 5","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
apb_lock.start(vir_seqrh.master_seqrh[0]);
wdog_lock.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 6 : Observing watchdog in integration test mode	and reset 
// behaviour				
//==================================================================//
class vir_int_mode_rst extends virtual_sequence;
`uvm_object_utils(vir_int_mode_rst)

//*************************methods************************
extern function new (string name="vir_int_mode_rst");
extern task body();
endclass

//*********************constructor***********************
function vir_int_mode_rst:: new (string name="vir_int_mode_rst");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_int_mode_rst::body();
super.body();
apb_int_rst=apb_int_mode_rst::type_id::create("apb_int_rst");
wdog_int_rst=wdog_int_mode_rst::type_id::create("wdog_int_rst");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 5","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
apb_int_rst.start(vir_seqrh.master_seqrh[0]);
wdog_int_rst.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 7 : Observing watchdog in integration test mode	and interrupt 
// behaviour				
//==================================================================//

class vir_int_mode_int extends virtual_sequence;
`uvm_object_utils(vir_int_mode_int)

//*************************methods************************
extern function new (string name="vir_int_mode_int");
extern task body();
endclass

//*********************constructor***********************
function vir_int_mode_int:: new (string name="vir_int_mode_int");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_int_mode_int::body();
super.body();
apb_int_int=apb_int_mode_int::type_id::create("apb_int_int");
wdog_int_int=wdog_int_mode_int::type_id::create("wdog_int_int");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 5","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
apb_int_int.start(vir_seqrh.master_seqrh[0]);
wdog_int_int.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//==================================================================//
// T.C. 8 :Clearing the interrupt using callback method
//==================================================================//
class vir_int_rst_cb extends virtual_sequence;
`uvm_object_utils(vir_int_rst_cb)

//*************************methods************************
extern function new (string name="vir_int_rst_cb");
extern task body();
endclass

//*********************constructor***********************
function vir_int_rst_cb:: new (string name="vir_int_rst_cb");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_int_rst_cb::body();
super.body();
apb_cb=apb_intrpt_rst_cb::type_id::create("apb_cb");
wdog_cb=wdog_intrpt_rst_cb::type_id::create("wdog_cb");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 5","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
apb_cb.start(vir_seqrh.master_seqrh[0]);
wdog_cb.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//=====================================================================================//
// T.C. 9 :Corrupting the PSEL in the mid of transaction using callback method
//=====================================================================================//

class vir_psel_cb extends virtual_sequence;
`uvm_object_utils(vir_psel_cb)

//*************************methods************************
extern function new (string name="vir_psel_cb");
extern task body();
endclass

//*********************constructor***********************
function vir_psel_cb:: new (string name="vir_psel_cb");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_psel_cb::body();
super.body();
apb_psel_h=apb_psel_cb::type_id::create("apb_psel_h");
wdog_psel_h=wdog_psel_cb::type_id::create("wdog_psel_h");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 5","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
apb_psel_h.start(vir_seqrh.master_seqrh[0]);
wdog_psel_h.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//=====================================================================================//
// T.C. 10 : RAL SEQUENCE WITHOUT ADAPTER
//=====================================================================================//

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
//reg_seq.pwdata=reg_seq.data;
wreg_seq=wdog_read_default_values::type_id::create("wdog_read_default_values");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 10","///////In Body of Virtual Sequence T.C. 5 ////////",UVM_MEDIUM)
reg_seq.start(vir_seqrh.master_seqrh[0]);
wreg_seq.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//=====================================================================================//
// T.C. 11 : RAL SEQUENCE WITH SETTING DESIRED VALUE & COMPARING BACKDOOR
// READ 
//=====================================================================================//
class vir_des_fd extends virtual_sequence;
`uvm_object_utils(vir_des_fd)

//*************************methods************************
extern function new (string name="vir_des_fd");
extern task body();
endclass

//*********************constructor***********************
function vir_des_fd:: new (string name="vir_des_fd");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_des_fd::body();
super.body();
de_fd_h=seq_desire_front_comp::type_id::create("seq_desire_front_comp");
wreg_seq=wdog_read_default_values::type_id::create("wdog_read_default_values");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 11","///////In Body of Virtual Sequence T.C. 11 ////////",UVM_MEDIUM)
de_fd_h.start(vir_seqrh.master_seqrh[0]);
wreg_seq.start(vir_seqrh.slave_seqrh[0]);
join
endtask
//=====================================================================================//
// T.C. 12 : RAL SEQUENCE WITH SETTING UPDATE AND MIRROR
//=====================================================================================//
class vseq_desire_mirror extends virtual_sequence;
`uvm_object_utils(vseq_desire_mirror)

//*************************methods************************
extern function new (string name="vseq_desire_mirror");
extern task body();
endclass

//*********************constructor***********************
function vseq_desire_mirror:: new (string name="vseq_desire_mirror");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vseq_desire_mirror::body();
super.body();
des_mirr_h=seq_desire_mirror::type_id::create("des_mirr_h");
wreg_seq=wdog_read_default_values::type_id::create("wdog_read_default_values");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 12","///////In Body of Virtual Sequence T.C. 12 ////////",UVM_MEDIUM)
des_mirr_h.start(vir_seqrh.master_seqrh[0]);
wreg_seq.start(vir_seqrh.slave_seqrh[0]);
join
endtask

//=====================================================================================//
// T.C. 13 : PHASE JUMPING
//=====================================================================================//
class vir_phase_jumping extends virtual_sequence;
`uvm_object_utils(vir_phase_jumping)

//*************************methods************************
extern function new (string name="vir_phase_jumping");
extern task body();
endclass

//*********************constructor***********************
function vir_phase_jumping:: new (string name="vir_phase_jumping");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_phase_jumping::body();
super.body();
apb_lock=apb_locked_reg::type_id::create("apb_rst");
wdog_lock=wdog_locked_reg::type_id::create("wdog_rst");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 13","///////In Body of Virtual Sequence T.C. 13 ////////",UVM_MEDIUM)
apb_lock.start(vir_seqrh.master_seqrh[0]);
wdog_lock.start(vir_seqrh.slave_seqrh[0]);join
endtask

//=====================================================================================//
// T.C. 14 : ARBITRATION
//=====================================================================================//
class vir_arb_seq extends virtual_sequence;
`uvm_object_utils(vir_arb_seq)

//*************************methods************************
extern function new (string name="vir_arb_seq");
extern task body();
endclass

//*********************constructor***********************
function vir_arb_seq:: new (string name="vir_arb_seq");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_arb_seq::body();
super.body();
apb_arb_seq=apb_arb::type_id::create("apb_arb_seq");
wdog_arb_seq=wdog_arb::type_id::create("wdog_arb_seq");
fork 
`uvm_info("VIRTUAL SEQUENCE T.C. 13","///////In Body of Virtual Sequence T.C. 13 ////////",UVM_MEDIUM)
apb_arb_seq.start(vir_seqrh.master_seqrh[0]);
wdog_arb_seq.start(vir_seqrh.slave_seqrh[0]);join
endtask

//=====================================================================================//
// T.C. 16 : PHASES
//=====================================================================================//
class vir_reset extends virtual_sequence;
`uvm_object_utils(vir_reset)

//*************************methods************************
extern function new (string name="vir_reset");
extern task body();
endclass

//*********************constructor***********************
function vir_reset:: new (string name="vir_reset");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_reset::body();
	super.body();
	rst_h=reset::type_id::create("rst_h");
	apb_def=apb_default::type_id::create("apb_def");
	wdog_phase_seq=wdog_phase::type_id::create("wdog_phase_seq");
	fork
		`uvm_info("VIRTUAL SEQUENCE T.C. 13","///////In Body of Virtual Sequence T.C. 13 ////////",UVM_MEDIUM)
		rst_h.start(vir_seqrh.reset_seqrh[0]);
		apb_def.start(vir_seqrh.master_seqrh[0]);
		wdog_phase_seq.start(vir_seqrh.slave_seqrh[0]);
	join
endtask

class vir_reload extends virtual_sequence;
`uvm_object_utils(vir_reload)

//*************************methods************************
extern function new (string name="vir_reload");
extern task body();
endclass

//*********************constructor***********************
function vir_reload:: new (string name="vir_reload");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_reload::body();
super.body();
rst1_h=reset1::type_id::create("rst1_h");
apb_load=apb_reload::type_id::create("apb_load");
wdog_phase_seq=wdog_phase::type_id::create("wdog_phase_seq");
fork
`uvm_info("VIRTUAL SEQUENCE T.C. 13","///////In Body of Virtual Sequence T.C. 13 ////////",UVM_MEDIUM)
rst1_h.start(vir_seqrh.reset_seqrh[0]);
apb_load.start(vir_seqrh.master_seqrh[0]);
wdog_phase_seq.start(vir_seqrh.slave_seqrh[0]);join
endtask

class vir_phase_seq extends virtual_sequence;
`uvm_object_utils(vir_phase_seq)

//*************************methods************************
extern function new (string name="vir_phase_seq");
extern task body();
endclass

//*********************constructor***********************
function vir_phase_seq:: new (string name="vir_phase_seq");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_phase_seq::body();
super.body();
rst2_h=reset2::type_id::create("rst2_h");
apb_phase_seq=apb_phase::type_id::create("apb_phase_seq");
wdog_phase_seq=wdog_phase::type_id::create("wdog_phase_seq");
fork
`uvm_info("VIRTUAL SEQUENCE T.C. 13","///////In Body of Virtual Sequence T.C. 13 ////////",UVM_MEDIUM)
rst2_h.start(vir_seqrh.reset_seqrh[0]);
apb_phase_seq.start(vir_seqrh.master_seqrh[0]);
wdog_phase_seq.start(vir_seqrh.slave_seqrh[0]);join
endtask




/*
//=====================================================================================//
// T.C. 15 : SEQ_LIBRARY
//=====================================================================================//
class vir_seq_lib extends virtual_sequence;
`uvm_object_utils(vir_seq_lib)
my_seq_lib m_seq_lib0;
//*************************methods************************
extern function new (string name="vir_seq_lib");
extern task body();
endclass

//*********************constructor***********************
function vir_seq_lib:: new (string name="vir_seq_lib");
	 super.new(name);
endfunction:new

//*********************body method***********************
task vir_seq_lib::body();
super.body();
        m_seq_lib0 = my_seq_lib::type_id::create ("m_seq_lib0");
     // m_seq_lib0.selection_mode = UVM_SEQ_LIB_USER;   //mode selection
     // m_seq_lib0.min_random_count = 15;      //min and max vlues for randomization
     // m_seq_lib0.max_random_count = 15;
      
      
	m_seq_lib0.start(vir_seqrh.master_seqrh[0]);
endtask*/
