/***********************************************************
Author 		: Ramkumar 
File 		: virtual_sequencer.sv
Module name     : virtual_sequencer 
Description     :        
Started DATA    : 06/03/2018  
***********************************************************/ 

class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
	 `uvm_component_utils(virtual_sequencer)
//Declaring sequencer handles
master_sequencer master_seqrh[];
slave_sequencer slave_seqrh[];
wtenv_config seqrh_cfg;
reset_sequencer reset_seqrh[];
//*********************************method********************************
extern function new (string name="virtual_sequencer",uvm_component parent);
extern function void build_phase (uvm_phase phase);
endclass:virtual_sequencer

//****************************Constructor*******************************
function virtual_sequencer :: new (string name="virtual_sequencer",uvm_component parent); 
	 super.new(name,parent);
endfunction:new

//****************************Build_phase*******************************
function void virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(wtenv_config)::get(this,"","wtenv_config",seqrh_cfg))
		`uvm_fatal("VIRTUAL SEQUENCER","Unable to get config file in virtual sequener")
	if(seqrh_cfg.has_virtual_sequencer)
	begin
		`uvm_info("VIRTUAL SEQUENCER","///////Build Phase of Virtual Sequencer////////",UVM_MEDIUM)
		master_seqrh=new[seqrh_cfg.has_virtual_sequencer];
		slave_seqrh=new[seqrh_cfg.has_virtual_sequencer];
	//	if(`has_reset)
			reset_seqrh=new[seqrh_cfg.has_virtual_sequencer];
	end
endfunction
