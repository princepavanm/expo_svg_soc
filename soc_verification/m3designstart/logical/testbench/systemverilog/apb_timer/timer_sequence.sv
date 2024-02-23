
////////////////////////////////////////////////////////////
 //Author:     ABHSIEHK EEMANI
 //Module:     timer_squence
 //Filename:   timer_sequence.sv
 //start date: 23/10/2017 
 ////////////////////////////////////////////////////////////
 //
class timer_sequence extends uvm_sequence#(timer_txn);
  `uvm_object_utils(timer_sequence)
  extern function new(string name="timer_sequence");
endclass:timer_sequence


/////------timer sequence class construction ------/////
 function timer_sequence::new(string name="timer_sequence");
  super.new(name);
endfunction

//==================================================================
// timer_sequence_1
//==================================================================
class timer_test_case_1 extends timer_sequence;
  `uvm_object_utils(timer_test_case_1)
  
  extern function new(string name="timer_test_case_1");
  extern task body();
endclass:timer_test_case_1
  
  function timer_test_case_1::new(string name="timer_test_case_1");
    super.new(name);
  endfunction
  
  task timer_test_case_1::body();
    
   req=timer_txn::type_id::create("req");
   
    begin
    start_item(req);
        assert(req.randomize()with {extin==1;})  
    finish_item(req);
    
  //$display($time, "Timer EXTIN input sequence extin=%X",req.extin);
    end
    
endtask

class timer_test_case_2 extends timer_sequence;
  `uvm_object_utils(timer_test_case_2)
  
  extern function new(string name="timer_test_case_2");
  extern task body();
endclass
  
  function timer_test_case_2::new(string name="timer_test_case_2");
    super.new(name);
  endfunction
  
  task timer_test_case_2::body();
    
   req=timer_txn::type_id::create("req");
   
    begin
    start_item(req);
        assert(req.randomize()with {extin==0;})  
    finish_item(req);
    
  //$display($time, "Timer EXTIN input sequence extin=%X",req.extin);
    end
    
endtask
