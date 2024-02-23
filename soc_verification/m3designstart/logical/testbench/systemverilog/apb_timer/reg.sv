////////////////////////////////////////////////////////////
//Filename     : reg.sv
//start date   : 31/07/2019 
////////////////////////////////////////////////////////////


//----------------Control Register----------------

class control_reg extends uvm_reg;
	`uvm_object_utils(control_reg)

	//Fields of Control_Register	
	rand uvm_reg_field enable;  //Enable
	rand uvm_reg_field input_en;  //Select external input as enable
	rand uvm_reg_field input_clk; //Select external input as clock
	rand uvm_reg_field interrupt_en;  //Timer interrupt enable

	//constructor
	function new(string name="control_reg");
		super.new(name,4,UVM_NO_COVERAGE);
	endfunction

	//build function
	virtual function void build();
		//Create object instance for each field
		enable=uvm_reg_field::type_id::create("enable");
		input_en=uvm_reg_field::type_id::create("input_en");
		input_clk=uvm_reg_field::type_id::create("input_clk");
		interrupt_en=uvm_reg_field::type_id::create("interrupt_en");
		
		//Configure each field
		enable.configure(this,1,0,"RW",0,0,1,1,0);
		input_en.configure(this,1,1,"RW",0,0,1,1,0);
		input_clk.configure(this,1,2,"RW",0,0,1,1,0);
		interrupt_en.configure(this,1,3,"RW",0,0,1,1,0);
	endfunction
endclass


//----------------Value Register----------------

class value_reg extends uvm_reg;
	`uvm_object_utils(value_reg)

	rand uvm_reg_field val;	

	function new(string name="value_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		//Create object instance for each field
		val=uvm_reg_field::type_id::create("val");
				
		//Configure each field
		val.configure(this,32,0,"RW",0,'h0,1,1,0);

		//Backdoor path
	        add_hdl_path_slice("reg_curr_val",0,32);

	endfunction
endclass



//----------------Relaod Register----------------

class reload_reg extends uvm_reg;
	`uvm_object_utils(reload_reg)

	rand uvm_reg_field reload;	

	function new(string name="reload_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		//Create object instance for each field
		reload=uvm_reg_field::type_id::create("reload");
				
		//Configure each field
		reload.configure(this,32,0,"RW",0,'h0,1,1,0);
	endfunction
endclass



//----------------int_stat_clear Register----------------

class int_status_reg extends uvm_reg;
	`uvm_object_utils(int_status_reg)

	rand uvm_reg_field status;	

	function new(string name="int_status_reg");
		super.new(name,1,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		//Create object instance for each field
		status=uvm_reg_field::type_id::create("status");
				
		//Configure each field
		status.configure(this,1,0,"RW",0,0,1,1,0);
	endfunction
endclass

//----------------PID Register----------------
class pid_reg extends uvm_reg;
	`uvm_object_utils(pid_reg)

	 uvm_reg_field pid;	

	function new(string name="pid_reg");
		super.new(name,8,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		//Create object instance for each field
		pid=uvm_reg_field::type_id::create("pid");
				
		//Configure each field
		pid.configure(this,8,0,"RO",0,0,1,0,0);
	endfunction
endclass

