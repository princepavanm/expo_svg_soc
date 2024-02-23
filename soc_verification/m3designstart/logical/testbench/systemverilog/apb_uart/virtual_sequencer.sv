/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	virtual sequencer class
 Filename:   	virtual_sequencer.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)
  
//handles of uart and apb sequencer and Environment config
  uart_sequencer sequencer;
  apb_sequencer sqr;
  uart_env_config seqrh_cfg;;
  reset_sequencer rst_sqr;
  
//*******************************Methods*********************************** 
  extern function new(string name="virtual_sequencer",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass:virtual_sequencer

//*****************************Constructor********************************* 
function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction:new

//*****************************Build_phase**********************************
function void virtual_sequencer::build_phase(uvm_phase phase);
      if(!uvm_config_db#(uart_env_config)::get(this,"","uart_env_config",seqrh_cfg))
        `uvm_fatal("VIRTUAL_SEQUENCER","getting unsuccessful")
      super.build_phase(phase);

      if(seqrh_cfg.has_virtual_sequencer)
      begin
	      `uvm_info("VIRTUAL SEQUENCER","Build phase of virtual sequencer",UVM_MEDIUM)
	      sequencer=new[seqrh_cfg.has_virtual_sequencer];
	      sqr=new[seqrh_cfg.has_virtual_sequencer];
	      rst_sqr=new[seqrh_cfg.has_virtual_sequencer];
      end
endfunction:build_phase 
