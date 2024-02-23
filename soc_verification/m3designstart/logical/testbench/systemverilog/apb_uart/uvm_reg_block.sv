//************************************************************************************
//			Author name  : Meghana B N
//			project name : APB_UART
//			file name    : uvm_reg_block
//			Start date   : 9-9-2019
//			Finish date  : 9-9-2019
//************************************************************************************
import uvm_pkg::*;
  `include "uvm_macros.svh"

class uart_reg_block extends uvm_reg_block;
	`uvm_object_utils(uart_reg_block)

	rand data_reg d_reg;
	rand ctrl_reg ct_reg;

	uvm_reg_map apb_map;

	function new(string name = "uart_reg_block");
		super.new(name,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
	
//This is for APB_UART_data_reg
	d_reg =data_reg::type_id::create("d_reg");
	d_reg.configure(this);
	d_reg.build();
	d_reg.add_hdl_path_slice("reg_tx_buf",0,8);

//This is for UART control register
	ct_reg = ctrl_reg::type_id::create("ct_reg");
	ct_reg.configure(this);
	ct_reg.build();
	//name,offset,size,first,kind
	ct_reg.add_hdl_path_slice("reg_ctrl",'h02,7);

//creating address maps for the declared registers
	apb_map = create_map("apb_map",'h0,1,UVM_LITTLE_ENDIAN);

	default_map = apb_map;

	apb_map.add_reg(d_reg,'h0,"RW");
	$display("####################d_reg=%0h###################",d_reg);
	apb_map.add_reg(ct_reg,'h01,"RW");
	$display("&&&&&&&&&&&&&&&&&&&&ctrl_reg=%0h&&&&&&&&&&&&&&&&&",ct_reg);

	add_hdl_path("tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_mps2_peripherals_wrapper.u_beetle_peripherals_fpga_subsystem.u_cmsdk_apb_uart_1");

	lock_model();

endfunction
endclass
