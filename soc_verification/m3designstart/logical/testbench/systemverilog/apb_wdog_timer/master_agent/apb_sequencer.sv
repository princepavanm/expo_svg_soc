/***********************************************************
Author 		: Ramkumar 
File 		: master_sequencer.sv
Module name     : master_sequencer 
Description     :        
Started DATA    : 06/03/2018  
***********************************************************/ 

class master_sequencer extends uvm_sequencer#(master_trans);
	 `uvm_component_utils(master_sequencer)

//*********************************method********************************
extern function new (string name="master_sequencer",uvm_component parent);   
extern function integer user_priority_arbitration(integer avail_sequences[$]);
endclass:master_sequencer

//****************************Constructor*******************************
function master_sequencer :: new (string name="master_sequencer",uvm_component parent); 
	 super.new(name,parent);
endfunction:new

function integer master_sequencer ::user_priority_arbitration(integer avail_sequences[$]);
      int min_pri = 2**31-1;
      int min_i = -1;
      foreach (avail_sequences[i])
      begin
        integer            index = avail_sequences[i];
        uvm_sequence_request req = arb_sequence_q[index];
        int                  pri = req.item_priority;
        uvm_sequence_base    seq = req.sequence_ptr;
      
        // Select the sequence with the lowest priority instead of the highest
        if (pri < min_pri)
        begin
          min_pri = pri;
          min_i = i;
        end
      end
      return min_i;
endfunction

