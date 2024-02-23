class my_seq_lib extends uvm_sequence_library #(master_trans);  //user defined seq_library
   `uvm_object_utils (my_seq_lib)             //factory registration of seq library
   `uvm_sequence_library_utils (my_seq_lib)   //registering userdefined seq_lib with uvm_sequence_library
 

//user defined selection mode
function int unsigned select_sequence(int unsigned max);
	int current_seq;
	do
	begin
	void'(std::randomize(current_seq) with {current_seq inside {[0 : max]};});
	end while (sequences[current_seq] != apb_intrpt_rst::get_type() && sequences[current_seq] != apb_locked_reg::get_type());
	return current_seq;
endfunction: select_sequence


function new (string name="my_seq_lib");   //constructor  
      super.new (name);
      add_typewide_sequences({apb_intrpt_rst::get_type(),apb_locked_reg::get_type(),apb_int_mode_rst::get_type()});  //adding in seq_lib
      init_sequence_library();   //invoking init_sequence_library  method in uvm_sequence_library
   endfunction
endclass

class my_seq_library extends uvm_sequence_library #(slave_trans);  //user defined seq_library
   `uvm_object_utils (my_seq_library)             //factory registration of seq library
   `uvm_sequence_library_utils (my_seq_library)   //registering userdefined seq_lib with uvm_sequence_library
 

//user defined selection mode
function int unsigned select_sequence(int unsigned max);
	int current_seq;
	do
	begin
	void'(std::randomize(current_seq) with {current_seq inside {[0 : max]};});
	end while (sequences[current_seq] != wdog_intrpt_rst::get_type() && sequences[current_seq] != wdog_locked_reg::get_type());
	return current_seq;
endfunction: select_sequence


function new (string name="my_seq_lib");   //constructor  
      super.new (name);
      add_typewide_sequences({wdog_intrpt_rst::get_type(),wdog_locked_reg::get_type(),wdog_int_mode_rst::get_type()});  //adding in seq_lib
      init_sequence_library();   //invoking init_sequence_library  method in uvm_sequence_library
   endfunction
endclass

//Methods to add sequences to sequence library
//1--add_typewide_sequences
//2--add_sequences
//3--`uvm_add_to_seq_lib

/*
The   most   convenient   location   to   place   the add_typewide_sequence() and/or add_typewide_sequences() call is in the constructor of the sequence_library type itself. You may  also  register  a  sequence  with  an  individual  instance  of  a  sequence  library  by  using  the add_sequence()  or add_sequences() method. This would typically be done in the test where the
sequence is instantiated.
*/
/*

UVM_SEQ_LIB_RAND     Random sequence selection
UVM_SEQ_LIB_RANDC    Random cyclic sequence selection
UVM_SEQ_LIB_ITEM     Emit only items, no sequence execution
UVM_SEQ_LIB_USER     Apply a user-defined random-selection algorithm
*/
