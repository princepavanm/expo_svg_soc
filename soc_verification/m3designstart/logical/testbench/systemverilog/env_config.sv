class env_config extends uvm_object;
  	`uvm_object_utils(env_config)


`ifdef ADD_WDOG_TIMER
	virtual wtapb_if vif_wt;
	apb_reg_block wt_reg_block_h;
`endif
 

`ifdef ADD_TIMER
	virtual apb_timer_if vif_t; 
	reg_block t_reg_block_h;
`endif

`ifdef ADD_SRAM0
	virtual  AHB_SRAM_if vif_s; 
	ahb_reg_block s_reg_block_h;
`endif 
`ifdef ADD_UART
	virtual APB_UART_if vif_u;
	uart_reg_block u_reg_block_h;
`endif
	

	//*******************************Methods**************
	extern function new(string name="env_config");

endclass:env_config
//***************************constructor************************
function env_config :: new(string name="env_config");
  	super.new(name);
endfunction
