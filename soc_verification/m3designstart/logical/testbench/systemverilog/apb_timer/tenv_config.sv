class tenv_config extends uvm_object;
  	`uvm_object_utils(tenv_config)

	//Env configuration for Timer	  
	  bit has_apb_agent=1;
	  bit has_timer_agent=0;
	  bit has_reset_agent=0;
	  bit has_virtual_sequencer=0;
	  //bit has_scoreboard=1;
	  bit INT_TEMP;
	  //reg [31:0] temp_prdata;
	    
	////declare the apb_agent_config and timer_agent_configs here
	reg_block        blk;
	apb_agent_config apb_agent_cfg;
	//timer_agent_config timer_agent_cfg;
	//reset_agent_config reset_agent_cfg;

        virtual apb_timer_if vif;
	//*******************************Methods************************
	extern function new(string name="tenv_config");
endclass:tenv_config

//***************************constructor************************
function tenv_config :: new(string name="tenv_config");
  	super.new(name);
     blk=reg_block::type_id::create("blk");
endfunction
