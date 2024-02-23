/////////////////////////////////////////////
// Author:     ABHISHEK EEMANI
// Module:     virtual_sequencer
// Filename:   virtual_sequencer.sv
// Start Date: 23/10/2017
/////////////////////////////////////////////

class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)
  
  apb_sequencer apb_seqr;
  timer_sequencer timer_seqr;
  reset_sequencer reset_seqr;
  
  tenv_config env_cfg;
  
  extern function new(string name="virtual_sequencer",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass:virtual_sequencer
    
    function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
      super.new(name,parent);
    endfunction 
    
//================================================================================
// build_phase
//================================================================================
    
    function void virtual_sequencer::build_phase(uvm_phase phase);      
      if(!uvm_config_db#(tenv_config)::get(this,"","tenv_config",env_cfg))
        `uvm_fatal("VIRTUAL_SEQUENCER","getting unsuccessful")
        super.build_phase(phase);

    endfunction 
    
