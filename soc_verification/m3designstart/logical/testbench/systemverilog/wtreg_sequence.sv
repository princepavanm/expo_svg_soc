`define RTL_REG_PATH tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_mps2_peripherals_wrapper.u_beetle_peripherals_fpga_subsystem.u_cmsdk_apb_watchdog.u_apb_watchdog_frc
class wtreg_sequence extends uvm_reg_sequence;
	`uvm_object_utils(wtreg_sequence)

  //apb_reg_block wdog_WATCHDOG_block_h;
  apb_reg_block    wdog_reg_block_h;
  env_config  env_cfg;

  uvm_status_e status;
  uvm_reg_data_t value;
  
  function new(string name= "wtreg_sequene");
	super.new(name);
	//create a new pool with given name
  endfunction

  virtual task body ();
	//$cast(wdog_WATCHDOG_block_h,model);

    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
    begin
      `uvm_fatal("Watchdog WATCHDOG Env in Reg Sequence","apb_wdog_WATCHDOG env_config getting unsuccessfull")
    end
    wdog_reg_block_h=env_cfg.wt_reg_block_h;

               
      /* Methods to try*/
      /*
      set()
      get()
      poke()
      peek()
      read()
      write()
      update()
      predict()
      mirror()
      */ 
      forever begin
     	 @(posedge `WDOG_RTL_PATH.PCLK)
            if	((`WDOG_RTL_PATH.PSEL==1) && (`WDOG_RTL_PATH.PENABLE==1) && (`WDOG_RTL_PATH.PWRITE==1)) begin
                //`uvm_info("WATCHDOG RAL_CHECK", $sformatf("PADDR=%0h, WDATA=%0h", `WDOG_RTL_PATH.PADDR,`WDOG_RTL_PATH.PWDATA),UVM_LOW)	            
		  check_des_mirrored_vals(`WDOG_RTL_PATH.PADDR, `WDOG_RTL_PATH.PWDATA);

            end else begin 
            if	((`WDOG_RTL_PATH.PSEL==1) && (`WDOG_RTL_PATH.PENABLE==1) && (`WDOG_RTL_PATH.PWRITE==0)) begin
                //`uvm_info("WATCHDOG RAL_CHECK", $sformatf("PADDR=%0h, WDATA=%0h", `WDOG_RTL_PATH.PADDR,`WDOG_RTL_PATH.PRDATA),UVM_LOW)	            
		  check_des_mirrored_vals(`WDOG_RTL_PATH.PADDR, `WDOG_RTL_PATH.PRDATA);
            end
            end 
      end
  endtask

// checking method
	task check_des_mirrored_vals (int unsigned addr, int unsigned act_data);
            int unsigned des_val, mirr_val, hw_reg_val;
            begin
	     #1; 
             case (addr) 
		'h000: 
		begin 
		   des_val = wdog_reg_block_h.ld_reg.get(); // to get desired value 
		   mirr_val= wdog_reg_block_h.ld_reg.get_mirrored_value();  
                    `uvm_info("WATCHDOG RAL_CHECK", $sformatf("ld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            
		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("WATCHDOG RAL_CHECK", $sformatf("ld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))	  
                   // backdoor update, poke, peek 
		   ld_reg_update_poke_peek_backdoor(); 
          
                end 
		'h001: 
		begin 
		  // Front door writes/reads from the processor
		   des_val = wdog_reg_block_h.value_reg.get(); 
		   mirr_val= wdog_reg_block_h.value_reg.get_mirrored_value();  
                   `uvm_info("WATCHDOG RAL_CHECK", $sformatf("FD wr/rd: value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            

		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("WATCHDOG RAL_CHECK", $sformatf("FD wr/rd: value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))
		  // Front door writes/reads from the processor
                  value_reg_wr_rd_backdoor();
                 end                   

		'h002: 
		begin 
		   des_val = wdog_reg_block_h.ctrl_reg.get(); 
		   mirr_val= wdog_reg_block_h.ctrl_reg.get_mirrored_value();  
                   `uvm_info("WATCHDOG RAL_CHECK", $sformatf("FD: ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            
		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("WATCHDOG RAL_CHECK", $sformatf("FD: ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))	            
                   // backdoor predict and mirror 
                   ctrl_reg_predict_mirror_backdoor();
		  
                 end                   
	       default:
                    `uvm_info("WATCHDOG RAL_CHECK", $sformatf("Entered Default case"),UVM_LOW)	            

             endcase 
            end
    endtask

    // Backdoor tasks functionality :  update, peek. poke
    task  ld_reg_update_poke_peek_backdoor(); 
      // set()
      wdog_reg_block_h.ld_reg.set(32'h000001); 	    
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD set(): ld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.ld_reg.get(), wdog_reg_block_h.ld_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_load), UVM_LOW)	            

      // update 
      wdog_reg_block_h.ld_reg.update(status, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD update(): ld  reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.ld_reg.get(), wdog_reg_block_h.ld_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_load), UVM_LOW)	            

      // poke 
      wdog_reg_block_h.ld_reg.poke(status, 32'h00000005, .parent(this)); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD poke(): ld  reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.ld_reg.get(), wdog_reg_block_h.ld_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_load), UVM_LOW)	            

      // peek  
      wdog_reg_block_h.ld_reg.peek(status, value, .parent(this)); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD peek(): ld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  wdog_reg_block_h.ld_reg.get(), wdog_reg_block_h.ld_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_load, value), UVM_LOW)	
   endtask

   // Backdoor tasks functionality : write/read
   task value_reg_wr_rd_backdoor(); 
     begin
      // set()
      wdog_reg_block_h.value_reg.set(32'h00000022); 	    
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD set(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.value_reg.get(), wdog_reg_block_h.value_reg.get_mirrored_value(), `RTL_REG_PATH.reg_count), UVM_LOW)	            

      // write 
      wdog_reg_block_h.value_reg.write(status, 32'h00000022, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD write(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.value_reg.get(), wdog_reg_block_h.value_reg.get_mirrored_value(), `RTL_REG_PATH.reg_count), UVM_LOW)	            

      // read
      wdog_reg_block_h.value_reg.read(status, value, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD read(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  wdog_reg_block_h.value_reg.get(), wdog_reg_block_h.value_reg.get_mirrored_value(), `RTL_REG_PATH.reg_count, value), UVM_LOW)	            
      end
    endtask

   // Backdoor tasks functionality : predict, mirror 
    task ctrl_reg_predict_mirror_backdoor(); 
      // set()
      wdog_reg_block_h.ctrl_reg.set(32'h00000011); 	    
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD set(): ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.ctrl_reg.get(), wdog_reg_block_h.ctrl_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_control), UVM_LOW)	            

      // predict 
      wdog_reg_block_h.ctrl_reg.predict(32'h00000011, UVM_BACKDOOR); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD predict: ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  wdog_reg_block_h.ctrl_reg.get(), wdog_reg_block_h.ctrl_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_control), UVM_LOW)	            

      //mirror 
      wdog_reg_block_h.ctrl_reg.mirror(status, UVM_CHECK, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("WATCHDOG RAL_CHECK", $sformatf("BD mirror(): ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  wdog_reg_block_h.ctrl_reg.get(), wdog_reg_block_h.ctrl_reg.get_mirrored_value(), `RTL_REG_PATH.wdog_control, value), UVM_LOW)	            
    endtask


endclass
