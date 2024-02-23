`define AW 16
class ahb_mem extends uvm_mem;
	`uvm_object_utils(ahb_mem)

	//rand uvm_reg_field mem;

	  function new(string name="ahb_mem");
   		super.new(name, 1<<`AW, 8,"RW",UVM_NO_COVERAGE);
		//name,address size, bit size,access,coverage
  	  endfunction

	       virtual function void build();
	          add_hdl_path_slice("ram_data",0,8);
  		endfunction
endclass
