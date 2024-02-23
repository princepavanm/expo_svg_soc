//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : virtual sequencer
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)
  
  master_sequencer master_seqr; //master sequencer handle
//slave_sequencer slave_seqr;   //slave sequencer handle
   
  env_config env_cfg;           //environment handle
  
//***************************Extern functions*********************************************************  
  extern function new(string name="virtual_sequencer",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass
    
//*********************************Constractor*********************************************************
function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction 
    
//*********************************Build phase********************************************************* 
function void virtual_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
      if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
        `uvm_fatal("VIRTUAL_SEQUENCER","getting unsuccessful")
         //begin 
        super.build_phase(phase);
        //master_seqr=new[m_cfg.no_of_duts];
     // end
    endfunction 
