class wtenv_config extends uvm_object;
  	`uvm_object_utils(wtenv_config)

	//Env configuration for watchdog timer
	int has_master_agent=1;
	int has_slave_agent=0;
	int has_reset_agent=`has_reset;
	int has_scoreboard=0;
	int has_virtual_sequencer=0;


	master_config master_cfg;
        //slave_config slave_cfg[];
	//if(has_reset_agent == 1)
	//reset_config reset_cfg[];

	virtual wtapb_if vif;
        
	apb_reg_block apb_rb;
	uvm_event_pool event_pool=uvm_event_pool::get_global_pool();


	//*******************************Methods************************
	extern function new(string name="wtenv_config");
endclass:wtenv_config

//***************************constructor************************
function wtenv_config :: new(string name="wtenv_config");
  	super.new(name);
endfunction
