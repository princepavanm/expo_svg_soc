// Register sequence to check backdoor accesses
// `define WDOG_RTL_PATH tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_mps2_peripherals_wrapper.u_beetle_peripherals_fpga_subsystem.u_cmsdk_apb_watchdog
//`define TIMER0_RTL_PATH //tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_iot_top.u_beid_peripheral_f0.u_p_beid_peripheral_f0_timer0

class treg_sequence extends uvm_reg_sequence;
	`uvm_object_utils(treg_sequence)

  //apb_reg_block wdog_timer_block_h;
  reg_block    timer_reg_block_h;
  env_config  env_cfg;

  uvm_status_e status;
  uvm_reg_data_t value;
  uvm_hdl_path_concat reg_hdl_path[$];

  function new(string name= "treg_sequene");
	super.new(name);
	//create a new pool with given name
  endfunction

  virtual task body ();
	//$cast(wdog_timer_block_h,model);

    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
    begin
      `uvm_fatal("Timer Env in Reg Sequence","apb_timer env_config getting unsuccessfull")
    end
    timer_reg_block_h=env_cfg.t_reg_block_h;

               
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
     	 @(posedge `TIMER0_RTL_PATH.PCLKG)
            if	((`TIMER0_RTL_PATH.PSEL==1) && (`TIMER0_RTL_PATH.PENABLE==1) && (`TIMER0_RTL_PATH.PWRITE==1)) begin
                `uvm_info("TIMER RAL_CHECK", $sformatf("PADDR=%0h, WDATA=%0h", `TIMER0_RTL_PATH.PADDR,`TIMER0_RTL_PATH.PWDATA),UVM_LOW)	            
		  check_des_mirrored_vals(`TIMER0_RTL_PATH.PADDR, `TIMER0_RTL_PATH.PWDATA);
		$display("=======================================================================================================");

            end else begin 
            if	((`TIMER0_RTL_PATH.PSEL==1) && (`TIMER0_RTL_PATH.PENABLE==1) && (`TIMER0_RTL_PATH.PWRITE==0)) begin
                `uvm_info("TIMER RAL_CHECK", $sformatf("PADDR=%0h, WDATA=%0h", `TIMER0_RTL_PATH.PADDR,`TIMER0_RTL_PATH.PRDATA),UVM_LOW)	            
		  check_des_mirrored_vals(`TIMER0_RTL_PATH.PADDR, `TIMER0_RTL_PATH.PRDATA);
		$display("================================================++++++++++++++++++++++++++++++++++++++++++===============================================================");
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
		$display("timer_11111111111");
		   des_val = timer_reg_block_h.ctl_reg.get(); // to get desired value 
		   mirr_val= timer_reg_block_h.ctl_reg.get_mirrored_value();  
                    `uvm_info("TIMER RAL_CHECK", $sformatf("ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            
		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("TIMER RAL_CHECK", $sformatf("ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))	  
                   // backdoor update, poke, peek 
		   ctl_reg_update_poke_peek_backdoor(); 
          
                end 
		'h001: 
		begin 
		$display("timer_222222222222222");
		  // Front door writes/reads from the processor
		   des_val = timer_reg_block_h.val_reg.get(); 
		   mirr_val= timer_reg_block_h.val_reg.get_mirrored_value();  
                   `uvm_info("TIMER RAL_CHECK", $sformatf("FD wr/rd: value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            

		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("TIMER RAL_CHECK", $sformatf("FD wr/rd: value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))
		  // Front door writes/reads from the processor
                  value_reg_wr_rd_backdoor();
                 end                   

		'h002: 
		begin 
		$display("timer_3333333333");
		   des_val = timer_reg_block_h.rld_reg.get(); 
		   mirr_val= timer_reg_block_h.rld_reg.get_mirrored_value();  
                   `uvm_info("TIMER RAL_CHECK", $sformatf("FD: rld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            
		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("TIMER RAL_CHECK", $sformatf("FD: rld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))	            
                   // backdoor predict and mirror 
                   rld_reg_predict_mirror_backdoor();
		  
                 end                   
	       default:
                    `uvm_info("TIMER RAL_CHECK", $sformatf("Entered Default case"),UVM_LOW)	            

             endcase 
            end
    endtask

    // Backdoor tasks functionality :  update, peek. poke
    task  ctl_reg_update_poke_peek_backdoor(); 
      // set()
      timer_reg_block_h.ctl_reg.set(32'h000001); 	    
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD set(): ctl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.ctl_reg.get(), timer_reg_block_h.ctl_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_ctrl), UVM_LOW)	            

      // update 
      timer_reg_block_h.ctl_reg.update(status, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD update(): ctl  reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.ctl_reg.get(), timer_reg_block_h.ctl_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_ctrl), UVM_LOW)	            

      // poke 
      timer_reg_block_h.ctl_reg.poke(status, 32'h00000005, .parent(this)); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD poke(): ctl  reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.ctl_reg.get(), timer_reg_block_h.ctl_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_ctrl), UVM_LOW)	            

      // peek  
      timer_reg_block_h.ctl_reg.peek(status, value, .parent(this)); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD peek(): ctl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  timer_reg_block_h.ctl_reg.get(), timer_reg_block_h.ctl_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_ctrl, value), UVM_LOW)	
   endtask

   // Backdoor tasks functionality : write/read
   task value_reg_wr_rd_backdoor(); 
     begin
      // set()
      timer_reg_block_h.val_reg.set(32'h00000022); 	    
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD set(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.val_reg.get(), timer_reg_block_h.val_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_curr_val), UVM_LOW)	            

      // write 
      timer_reg_block_h.val_reg.write(status, 32'h00000022, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD write(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.val_reg.get(), timer_reg_block_h.val_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_curr_val), UVM_LOW)	            

      // read
      timer_reg_block_h.val_reg.read(status, value, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD read(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  timer_reg_block_h.val_reg.get(), timer_reg_block_h.val_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_curr_val, value), UVM_LOW)	            
      end
    endtask

   // Backdoor tasks functionality : predict, mirror 
    task rld_reg_predict_mirror_backdoor(); 
      // set()
      timer_reg_block_h.rld_reg.set(32'h00000011); 	    
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD set(): rld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.rld_reg.get(), timer_reg_block_h.rld_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_reload_val), UVM_LOW)	            

      // predict 
      timer_reg_block_h.rld_reg.predict(32'h00000011, UVM_BACKDOOR); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD predict: rld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  timer_reg_block_h.rld_reg.get(), timer_reg_block_h.rld_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_reload_val), UVM_LOW)	            

      //mirror 
      timer_reg_block_h.rld_reg.mirror(status, UVM_CHECK, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("TIMER RAL_CHECK", $sformatf("BD mirror(): rld reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  timer_reg_block_h.rld_reg.get(), timer_reg_block_h.rld_reg.get_mirrored_value(), `TIMER0_RTL_PATH.reg_reload_val, value), UVM_LOW)	            
    endtask


endclass
