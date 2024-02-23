//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : master_agent
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class master_agent extends uvm_agent;
  `uvm_component_utils(master_agent)
  
  master_sequencer seqrh, sram_dummy_seqr;   //master sequencer handle
  master_driver drivh;      //master driver handle
  master_monitor monh;      //master monitor handle
  

  master_agent_config m_agt_cfg; //master agent config handle

//***************************Extern functions*********************************************************  
extern function new(string name="master_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

//*********************************Constractor*********************************************************
function master_agent::new(string name="master_agent", uvm_component parent);
super.new(name,parent);
endfunction

//*********************************Build phase*********************************************************
function void master_agent::build_phase(uvm_phase phase);
super.build_phase(phase);
   if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",m_agt_cfg))
	`uvm_fatal("MASTER_AGT_CONFIG","cannot get() m_agt_cfg from uvm_config")
	
    monh=master_monitor::type_id::create("monh",this);
    sram_dummy_seqr=master_sequencer::type_id::create("sram_dummy_seqr",this);
   if(m_agt_cfg.is_active==UVM_ACTIVE)
      begin
        drivh=master_driver::type_id::create("drivh",this);
        seqrh=master_sequencer::type_id::create("seqrh",this);
      end
endfunction

//*******************************Connect phase*********************************************************
function void master_agent::connect_phase(uvm_phase phase);
if(m_agt_cfg.is_active==UVM_ACTIVE)
	begin
		drivh.seq_item_port.connect(seqrh.seq_item_export);
	end
endfunction
