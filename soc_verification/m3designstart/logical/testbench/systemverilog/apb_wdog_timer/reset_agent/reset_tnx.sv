class reset_trans extends uvm_sequence_item;
	 `uvm_object_utils(reset_trans)

	//***********************input signals****************
	bit presetn;
	bit wdogresn;

	//********************methods************************
	extern function new (string name="reset_trans");
endclass:reset_trans


//*********************Constructor********************
function reset_trans :: new (string name="reset_trans");    
	 super.new(name);
endfunction:new


