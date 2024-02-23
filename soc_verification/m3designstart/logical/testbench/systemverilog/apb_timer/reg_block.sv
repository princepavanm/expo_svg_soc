////////////////////////////////////////////////////////////
//Filename     : reg_block.sv
//start date   : 31/07/2019 
////////////////////////////////////////////////////////////


class reg_block extends uvm_reg_block;
	`uvm_object_utils(reg_block)
	
	//include registers
	rand control_reg       ctl_reg;
	rand value_reg         val_reg;
	rand reload_reg        rld_reg;
	rand int_status_reg    intr_reg;
	     pid_reg           pid_regg;	
	//register map 
	uvm_reg_map apb_map;

	function new(string name="reg_block");
		super.new(name,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		//Control Register
		ctl_reg=control_reg::type_id::create("ctl_reg"); // Create an instance for every register
		ctl_reg.configure(this);// Configure every register instance
		ctl_reg.add_hdl_path_slice("reg_ctrl",'h0,4,"RTL");
		ctl_reg.build();// Call the build() function to build all register fields within each register

		//Value Register
		val_reg=value_reg::type_id::create("val_reg");
		val_reg.configure(this);
		val_reg.build();
		val_reg.add_hdl_path_slice("reg_curr_val",'h00,32,"RTL");
// extern function void add_hdl_path_slice(string name, int offset, int size, bit first = 0, string kind = "RTL");

		//Reload Register
		rld_reg=reload_reg::type_id::create("rld_reg");
		rld_reg.configure(this);
		rld_reg.build();
		rld_reg.add_hdl_path_slice("reg_reload_val",'h00,32,"RTL");

		//Interrupt_Status Register
		intr_reg=int_status_reg::type_id::create("intr_reg");
		intr_reg.configure(this);
		intr_reg.add_hdl_path_slice("nxt_curr_val",'h00,1,"RTL");
		intr_reg.build();

		//PID Register
		pid_regg=pid_reg::type_id::create("pid_regg");
		pid_regg.configure(this);
                //pid_regg.add_hdl_path_slice("....",'h03,1);
		pid_regg.build();


		//hdl path
		
		//Create Address map
		apb_map=create_map("apb_map",'h0,4,UVM_LITTLE_ENDIAN);
		
		default_map = apb_map;
		
		//Add registers to address_map
		apb_map.add_reg(ctl_reg,32'h0,"RW");
		apb_map.add_reg(val_reg,32'h1,"RW");
		apb_map.add_reg(rld_reg,32'h2,"RW");
		apb_map.add_reg(intr_reg,32'h3,"RW");
		apb_map.add_reg(pid_regg,32'h3f4,"RO");
		
		//hdl_path
		//add_hdl_path("top.DUT","RTL");
		
                add_hdl_path("tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_iot_top.u_beid_peripheral_f0.u_p_beid_peripheral_f0_timer0");
	
		//extern function void add_hdl_path (uvm_hdl_path_slice slices[],string kind = "RTL");
		
		lock_model();
	endfunction
endclass





/*

 extern function void add_hdl_path (uvm_hdl_path_slice slices[],
                                      string kind = "RTL");


   // Function: add_hdl_path_slice
   //
   // Append the specified HDL slice to the HDL path of the register instance
   // for the specified design abstraction.
   // If ~first~ is TRUE, starts the specification of a duplicate
   // HDL implementation of the register.
   //
   extern function void add_hdl_path_slice(string name,
                                           int offset,
                                           int size,
                                           bit first = 0,
                                           string kind = "RTL");







*/












/*
function uvm_reg_map create_map(string name, // Name of the map handle
				uvm_reg_addr_t base_addr, // The maps base address
				int unsigned n_bytes, // Map access width in bytes
				uvm_endianness_e endian, // The endianess of the map
				bit byte_addressing=1); // Whether byte_addressing is supported


function void add_reg 	(uvm_reg rg, // Register object handle
			uvm_reg_addr_t offset, // Register address offset
			string rights = "RW", // Register access policy
			bit unmapped=0, // If true, register does not appear in the address map
			// and a frontdoor access needs to be defined
			uvm_reg_frontdoor frontdoor=null);// Handle to register frontdoor access object

			*/
