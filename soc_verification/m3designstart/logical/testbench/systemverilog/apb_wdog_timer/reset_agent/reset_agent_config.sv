`ifdef original
	`define has_reset 0
`else
	`define has_reset 1
`endif
class reset_config extends uvm_object;
 	`uvm_object_utils(reset_config)

	//virtual interface declaration
	virtual reset_if vif1;
	int has_reset_agent=`has_reset;
	uvm_active_passive_enum IS_ACTIVE=UVM_ACTIVE;

	//*******************************Methods************************
	extern function new(string name="reset_config");
endclass:reset_config

//***************************constructor************************
function reset_config :: new(string name="reset_config");
  super.new(name);
endfunction:new
