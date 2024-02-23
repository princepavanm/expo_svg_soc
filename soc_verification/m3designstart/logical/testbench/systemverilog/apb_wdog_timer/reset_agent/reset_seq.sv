class reset_sequence extends uvm_sequence #(reset_trans);
	 `uvm_object_utils(reset_sequence)
	//*************************methods************************
	extern function new (string name="reset_sequence");
endclass:reset_sequence

function reset_sequence :: new (string name="reset_sequence");
	 super.new(name);
endfunction:new

//==================================================================//
// T.C. 1 :Reset
//==================================================================//
class reset extends reset_sequence;
	`uvm_object_utils(reset) 

	//****************************Methods*******************************    
  	extern function new(string name="reset");
  	extern task body();
endclass:reset
  
//****************************Constructor***************************
function reset :: new(string name="reset");
	super.new(name);
endfunction
  
//***********************apb_read_default_values*********************** 
task reset::body();
   	req=reset_trans::type_id::create("req");
	begin
        	start_item(req);
		req.presetn=1'b0;
		req.wdogresn=1'b0;
            	finish_item(req);
	end
	
	begin
            	start_item(req);
		req.presetn=1'b1;
		req.wdogresn=1'b1;
            	finish_item(req);
	end
endtask

class reset1 extends reset_sequence;
	`uvm_object_utils(reset1) 

	//****************************Methods*******************************    
  	extern function new(string name="reset1");
  	extern task body();
endclass:reset1
  
//****************************Constructor***************************
function reset1 :: new(string name="reset1");
	super.new(name);
endfunction
  
//***********************apb_read_default_values*********************** 
task reset1::body();
   	req=reset_trans::type_id::create("req");
	begin
        	start_item(req);
		req.presetn=1'b1;
		req.wdogresn=1'b1;
            	finish_item(req);
	end	
endtask

class reset2 extends reset_sequence;
	`uvm_object_utils(reset2) 

	//****************************Methods*******************************    
  	extern function new(string name="reset2");
  	extern task body();
endclass:reset2
  
//****************************Constructor***************************
function reset2 :: new(string name="reset2");
	super.new(name);
endfunction
  
//***********************apb_read_default_values*********************** 
task reset2::body();
   	req=reset_trans::type_id::create("req");
	begin
        	start_item(req);
		req.presetn=1'b1;
		req.wdogresn=1'b1;
            	finish_item(req);
	end
	#30
	begin
        	start_item(req);
		req.presetn=1'b0;
		req.wdogresn=1'b1;
            	finish_item(req);
	end
	#10
	begin
        	start_item(req);
		req.presetn=1'b1;
		req.wdogresn=1'b1;
            	finish_item(req);
	end		
endtask
