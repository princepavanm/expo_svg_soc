class load_register extends uvm_reg;
	`uvm_object_utils(load_register)

	rand uvm_reg_field ld_reg;
	function new(string name="load_register");
   		super.new(name,32,UVM_NO_COVERAGE);
  	endfunction

        virtual function void build();
           ld_reg = uvm_reg_field::type_id::create("ld_reg");
           ld_reg.configure(this,32,0,"RW",0,'hFFFFFFFF,1,1,0);
		  
	   //Backdoor path
           add_hdl_path_slice("wdog_load",0,32);
        endfunction
endclass

class wdog_value extends uvm_reg;
	  `uvm_object_utils(wdog_value)

	  rand uvm_reg_field reg_count;
	  
	  function new(string name ="wdog_value");
		  super.new(name,32,UVM_NO_COVERAGE);
	  endfunction

	  virtual function void build();

	    reg_count = uvm_reg_field::type_id::create("reg_count");
	    
	  		//(parent,size,lsb_position,access,volatile,rest,has_reset,is_rand,individually_accessible)
	    
	    reg_count.configure(this,32,0,"RO",0,'hFFFFFFFF,1,1,0);
             //Backdoor path
        
           add_hdl_path_slice("reg_count",1,32);

       endfunction
endclass

class wdog_ctrl_reg extends uvm_reg;
	  `uvm_object_utils(wdog_ctrl_reg)

	  rand uvm_reg_field wdog_ctrl_inten;
	  rand uvm_reg_field wdog_ctrl_resen;

	  function new(string name ="wdog_ctrl_reg");
		  super.new(name,32,UVM_NO_COVERAGE);
	  endfunction

	  virtual function void build();

	    wdog_ctrl_inten = uvm_reg_field::type_id::create("wdog_ctrl_inten");
	    wdog_ctrl_resen = uvm_reg_field::type_id::create("wdog_ctrl_resen");
	  		//(parent,size,lsb_position,access,volatile,rest,has_reset,is_rand,individually_accessible)
	    wdog_ctrl_inten.configure(this,1,0,"RW",0,'h00000000,1,1,0);
	    wdog_ctrl_resen.configure(this,1,1,"RW",0,'h00000000,1,1,0);
             //Backdoor path
           add_hdl_path_slice("wdog_int_en",2,1);
           add_hdl_path_slice("wdog_res_en",2,1);

       endfunction
  endclass
