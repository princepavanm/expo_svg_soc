class senv_config extends uvm_object;
  `uvm_object_utils(senv_config)
  
 // bit has_magent=1;
 // bit has_sagent=1;
   
 
  
  bit has_ahb_agent=1;
  bit has_scoreboard=0;
  bit has_functional_coverage=0;
  bit has_virtual_sequencer=0;
 
  
  master_agent_config m_cfg;
  ahb_reg_block blk;

  virtual AHB_SRAM_if vif0;
   
extern function new(string name="senv_config");
endclass

function senv_config::new(string name="senv_config");
super.new(name);
endfunction







