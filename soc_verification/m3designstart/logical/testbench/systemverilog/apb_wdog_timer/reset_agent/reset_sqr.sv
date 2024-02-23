class reset_sequencer extends uvm_sequencer#(reset_trans);
	 `uvm_component_utils(reset_sequencer)

	//*********************************method********************************
	extern function new (string name="reset_sequencer",uvm_component parent);   
endclass:reset_sequencer

//****************************Constructor*******************************
function reset_sequencer :: new (string name="reset_sequencer",uvm_component parent); 
	 super.new(name,parent);
endfunction:new

