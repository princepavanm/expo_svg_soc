//************************************************************************************
//			Author name  : Meghana B N
//			project name : APB_UART
//			file name    : uvm_reg
//			Start date   : 9-9-2019
//			Finish date  : 9-9-2019
//************************************************************************************
class data_reg extends uvm_reg;
	`uvm_object_utils(data_reg)

	rand uvm_reg_field d_reg;

	  function new(string name="data_reg");
   		super.new(name,8,UVM_NO_COVERAGE);
  	  endfunction

	       virtual function void build();

	          d_reg = uvm_reg_field::type_id::create("d_reg");
		  d_reg.configure(this,8,0,"RW",0,'h0,1,1,0);
		  
		  //Backdoor path
	          add_hdl_path_slice("reg_tx_buf",0,8);

  		endfunction

  endclass


  //###############control reg ##################
  class ctrl_reg extends uvm_reg;
	  `uvm_object_utils(ctrl_reg)

	  rand uvm_reg_field ct_reg;
	  function new(string name="ctrl_reg");
		  super.new(name,7,UVM_NO_COVERAGE);
	  endfunction

	  virtual function void build();
	  ct_reg = uvm_reg_field::type_id::create("ct_reg");
	  ct_reg.configure(this,7,0,"RW",0,'h0,1,1,0);

	  //backdoor path
	  add_hdl_path_slice("reg_ctrl",0,7);
  endfunction
  endclass


