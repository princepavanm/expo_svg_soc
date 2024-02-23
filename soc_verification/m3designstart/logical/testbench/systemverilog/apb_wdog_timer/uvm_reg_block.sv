 import uvm_pkg::*;
  `include "uvm_macros.svh"

class apb_reg_block extends uvm_reg_block;
	`uvm_object_utils(apb_reg_block)

	rand load_register ld_reg;
	rand wdog_ctrl_reg ctrl_reg;
        rand wdog_value value_reg;

	uvm_reg_map apb_map;

	function new(string name = "apb_reg_block");
		super.new(name,UVM_NO_COVERAGE);
	endfunction

    virtual function void build();
//This is for APB_load_register
	ld_reg =load_register::type_id::create("load_register");
	ld_reg.configure(this);//,null,"");
	ld_reg.build();
	ld_reg.add_hdl_path_slice("wdog_load",0,32);

// Value register 
        value_reg = wdog_value::type_id::create("wdog_value");
        value_reg.configure(this);//,null,"");
	value_reg.build();
	value_reg.add_hdl_path_slice("reg_count",0,32);

//This is for WDOG control register
	ctrl_reg = wdog_ctrl_reg::type_id::create("ctrl_reg");
	ctrl_reg.configure(this);
	ctrl_reg.build();
	//name,offset,size,first,kind
	ctrl_reg.add_hdl_path_slice("wdog_control",0,2);

//creating address maps for the declared registers
	apb_map = create_map("apb_map",'h0,4,UVM_LITTLE_ENDIAN);
        apb_map.set_check_on_read(1); 

	default_map = apb_map;

	apb_map.add_reg(ld_reg,32'h0000,"RW");
        apb_map.add_reg(value_reg, 32'h0001, "RO");
	apb_map.add_reg(ctrl_reg,32'h0002,"RW");
    

	//add_hdl_path("top.DUT.u_apb_watchdog_frc","RTL");
	add_hdl_path("tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_mps2_peripherals_wrapper.u_beetle_peripherals_fpga_subsystem.u_cmsdk_apb_watchdog.u_apb_watchdog_frc");


	lock_model();

    endfunction
endclass
