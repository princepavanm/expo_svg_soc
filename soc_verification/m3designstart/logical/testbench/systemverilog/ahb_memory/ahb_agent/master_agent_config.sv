//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : master_agent_config
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class master_agent_config extends uvm_object;
  `uvm_object_utils(master_agent_config)

virtual AHB_SRAM_if vif0;  
uvm_active_passive_enum is_active=UVM_PASSIVE;

static int mon_rcvd_xtn_cnt=0;
static int drv_data_send_cnt=0;

  
//***************************Extern functions*********************************************************
extern function new(string name="master_agent_config");
endclass

//*********************************Constractor*********************************************************
function master_agent_config::new(string name="master_agent_config");
super.new(name);
endfunction
