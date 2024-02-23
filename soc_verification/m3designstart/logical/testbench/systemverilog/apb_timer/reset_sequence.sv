
//**********************************************************
// Author:     Abhishek
// Module:     RESET_SEQUENCE
// Filename:   reset_sequence.sv
//**********************************************************/

class reset_sequence extends uvm_sequence#(apb_txn);
  `uvm_object_utils(reset_sequence)
  extern function new(string name="reset_sequence");
  
endclass

function reset_sequence::new(string name="reset_sequence");
  super.new(name);
endfunction 


//==============================================================================
//reset sequence
//==============================================================================

class reset_sequence_case extends reset_sequence;
  `uvm_object_utils(reset_sequence_case)
  extern function new(string name="reset_sequence_case");
  extern task body();
endclass

  function reset_sequence_case:: new(string name="reset_sequence_case");
    super.new(name);
  endfunction 
  
  //reset sequence
  
  task reset_sequence_case::body();
    req=apb_txn::type_id::create("req");
    
   start_item(req);
    	assert(req.randomize()) 
	req.presetn=0;
   finish_item(req);
 endtask 
  

//==============================================================================
//set sequence
//==============================================================================

class set_sequence extends reset_sequence;
  `uvm_object_utils(set_sequence)
  extern function new(string name="set_sequence");
  extern task body();
endclass

  function set_sequence:: new(string name="set_sequence");
    super.new(name);
  endfunction 
  
  //set sequence
  
  task set_sequence::body();
    req=apb_txn::type_id::create("req");
    
   start_item(req);
    assert(req.randomize())
    req.presetn=1;
   finish_item(req);
  endtask 
  
  
  
  
  
  
  
  
  
  
  
