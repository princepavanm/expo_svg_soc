
class sreg_sequence extends uvm_reg_sequence;
	`uvm_object_utils(sreg_sequence)

  ahb_reg_block    ahb_reg_block_h;
  env_config  env_cfg;

   int check;
   rand bit[31:0] data;
   rand bit[31:0] data1;
   rand bit[15:0] addr;
   rand bit[15:0] addr1;

  uvm_status_e status;
  uvm_reg_data_t value,value1;

  function new(string name= "sreg_sequence");
	super.new(name);
  endfunction

  virtual task body ();
    
    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
    begin
      `uvm_fatal("sram Env in Reg Sequence","ahb_memory env_config getting unsuccessfull")
    end
    ahb_reg_block_h=env_cfg.s_reg_block_h;
               
      /* Methods to try*/
      /*
      poke()
      peek()
      read()
      write()
      burst_write()
      burst_read()
      */ 
     
      forever begin
     	 @(posedge `SRAM0_RTL_PATH.HCLK)
            if	((`SRAM0_RTL_PATH.HSEL==1) && (`SRAM0_RTL_PATH.HWRITE==1) && (`SRAM0_RTL_PATH.HSIZE==0)) 	     begin
                   check=randomize(addr);
	          /* check=randomize(data);
		   //`uvm_info("SEQUENCE",$sformatf("addr = %0h  wdata = %0h", addr, data),UVM_LOW);


		 //--------------------WRITE and PEEK------------------------------------------
		  ahb_reg_block_h.mem.write(status,addr, data,.parent(this));
		  
                  ahb_reg_block_h.mem.peek(status, addr, value,.parent(this));
		  if(data[7:0] != value[7:0]) begin
		     `uvm_error("SEQUENCE FD",$sformatf("written data = %0h  peeked data = %0h",data,value));
		  end else begin
		     `uvm_info("SEQUENCE FD",$sformatf("written data = %0h  peeked data = %0h",data,value),UVM_LOW);
		  end
		  //--------------------POKE and PEEK-------------------------------------------
	          check=randomize(data1);
		  ahb_reg_block_h.mem.poke(status,addr, data1, .parent(this));
                  ahb_reg_block_h.mem.peek(status, addr, value,.parent(this));
                  if (data1[7:0] != value[7:0]) begin
                    `uvm_error("SEQUENCE",$sformatf("poked data = %0h  peeked data=%0h",data1,value));
                  end else begin 
                    `uvm_info("SEQUENCE",$sformatf("poked data = %0h  peeked data=%0h",data1,value),UVM_LOW);
                  end
                  //--------------------READ -----------------------------------
		  ahb_reg_block_h.mem.read(status,addr, value1, .parent(this));
                  //ahb_reg_block_h.mem.peek(status, addr, value,.parent(this));
                  //$display($time, "2. peek done after read, value=%0h ", value);
		  if(data[7:0] != value1[7:0]) begin
		     `uvm_error("SEQUENCE FD",$sformatf("poked data = %0h read data = %0h peeked data=%0h",data1,value1, value));
	          end else begin
		     `uvm_info("SEQUENCE FD",$sformatf("poked data = %0h  read data = %0h peeked data=%0h",data1,value1, value),UVM_LOW);
	          end*/
                  // ---------------------WRITE AND READ BACKDOOR
                  check=randomize(data1);
                  ahb_reg_block_h.mem.write(status,addr, data1, .path(UVM_BACKDOOR), .parent(this));
                  ahb_reg_block_h.mem.read(status,addr, value1, .path(UVM_BACKDOOR), .parent(this));
                  if(data1[7:0] != value1[7:0]) begin
		     `uvm_error("SEQUENCE BD",$sformatf("poked data = %0h read data = %0h peeked data=%0h",data1,value1, value));
	          end else begin
		     `uvm_info("SEQUENCE BD",$sformatf("poked data = %0h  read data = %0h peeked data=%0h",data1,value1, value),UVM_LOW);
	          end
end
end
endtask

endclass
