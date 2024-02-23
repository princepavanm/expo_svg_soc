class ahb_reg_block extends uvm_reg_block;
	`uvm_object_utils(ahb_reg_block)

	rand ahb_mem mem;

	uvm_reg_map ahb_map;

	function new(string name = "ahb_reg_block");
	   super.new(name,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
//This is for AHB Memory
	mem =ahb_mem::type_id::create("mem");
	mem.configure(this);
	mem.build();
	//mem.add_hdl_path_slice("ram_data",0,8, "RTL");

	//creating address maps for the declared registers
	ahb_map = create_map("ahb_map",'h0, 1, UVM_LITTLE_ENDIAN);
	// offset, n_bytes

	default_map = ahb_map;

	ahb_map.add_mem(mem,'h0,"RW");

	add_hdl_path("top.DUT.u_ahb_ram_beh", "RTL");

	lock_model();

endfunction
endclass
