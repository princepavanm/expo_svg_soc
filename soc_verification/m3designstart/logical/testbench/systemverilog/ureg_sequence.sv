`define RTL_REG_PATH tb_fpga_shield.u_fpga_top.u_fpga_system.u_user_partition.u_mps2_peripherals_wrapper.u_beetle_peripherals_fpga_subsystem.u_cmsdk_apb_uart_1 

class ureg_sequence extends uvm_reg_sequence;
	`uvm_object_utils(ureg_sequence)

  uart_reg_block    apb_reg_block_h;
  env_config  env_cfg;

  uvm_status_e status;
  uvm_reg_data_t value;
 // int act_data=8'hf;
  
  function new(string name= "ureg_sequence");
	super.new(name);
	//create a new pool with given name
  endfunction

  virtual task body ();
	//$cast(wdog_WATCHDOG_block_h,model);

    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
    begin
      `uvm_fatal("uart Env in Reg Sequence","apb_uart env_config getting unsuccessfull")
    end
    apb_reg_block_h=env_cfg.u_reg_block_h;

               
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
     	 @(posedge `UART_RTL_PATH.PCLK)
            if	((`UART_RTL_PATH.PSEL==1) && (`UART_RTL_PATH.PENABLE==1) && (`UART_RTL_PATH.PWRITE==1)) begin
                `uvm_info("UART RAL_CHECK", $sformatf("PADDR=%0h, WDATA=%0h", `UART_RTL_PATH.PADDR,`UART_RTL_PATH.PWDATA),UVM_LOW)	            
		  check_des_mirrored_vals(`UART_RTL_PATH.PADDR, `UART_RTL_PATH.PWDATA);

            end else begin 
            if	((`UART_RTL_PATH.PSEL==1) && (`UART_RTL_PATH.PENABLE==1) && (`UART_RTL_PATH.PWRITE==0)) begin
                `uvm_info("UART RAL_CHECK", $sformatf("PADDR=%0h, WDATA=%0h", `UART_RTL_PATH.PADDR,`UART_RTL_PATH.PRDATA),UVM_LOW)	            
		  check_des_mirrored_vals(`UART_RTL_PATH.PADDR, `UART_RTL_PATH.PRDATA);
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
	/*	'h000: 
		begin 
		   des_val = apb_reg_block_h.d_reg.get(); // to get desired value 
		   mirr_val= apb_reg_block_h.d_reg.get_mirrored_value();  
                    `uvm_info("UART RAL_CHECK", $sformatf("d reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            
		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("UART RAL_CHECK", $sformatf("d reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))	  
                   // backdoor update, poke, peek 
		   d_reg_update_poke_peek_backdoor(); 
          
                end */
	/*	'h001: 
		begin 
		  // Front door writes/reads from the processor
		   des_val = apb_reg_block_h.value_reg.get(); 
		   mirr_val= apb_reg_block_h.value_reg.get_mirrored_value();  
                   `uvm_info("UART RAL_CHECK", $sformatf("FD wr/rd: value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            

		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("UART RAL_CHECK", $sformatf("FD wr/rd: value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))
		  // Front door writes/reads from the processor
                  value_reg_wr_rd_backdoor();
                 end  */                 

		'h002: 
		begin 
		   des_val = apb_reg_block_h.ct_reg.get(); 
		   mirr_val= apb_reg_block_h.ct_reg.get_mirrored_value();  
                   `uvm_info("UART RAL_CHECK", $sformatf("FD: ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data), UVM_LOW)	            
		   if ((des_val != act_data) && (mirr_val != act_data)) 
                    `uvm_error("UART RAL_CHECK", $sformatf("FD: ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n", des_val, mirr_val, act_data))	            
                   // backdoor predict and mirror 
                   ct_reg_predict_mirror_backdoor();
		  
                 end              
	       default:
                    `uvm_info("UART RAL_CHECK", $sformatf("Entered Default case"),UVM_LOW)	            

             endcase 
            end
    endtask

    // Backdoor tasks functionality :  update, peek. poke
  /*  task  d_reg_update_poke_peek_backdoor(); 
      // set()
      apb_reg_block_h.d_reg.set(32'h000001); 	    
      `uvm_info("UART RAL_CHECK", $sformatf("BD set(): d reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.d_reg.get(), apb_reg_block_h.d_reg.get_mirrored_value(), `RTL_REG_PATH.reg_tx_buf), UVM_LOW)            

      // update 
      apb_reg_block_h.d_reg.update(status, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD update(): d  reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.d_reg.get(), apb_reg_block_h.d_reg.get_mirrored_value(), `RTL_REG_PATH.reg_tx_buf), UVM_LOW)	            

      // poke 
     apb_reg_block_h.d_reg.poke(status, 32'h00000005, .parent(this)); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD poke(): d  reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.d_reg.get(), apb_reg_block_h.d_reg.get_mirrored_value(), `RTL_REG_PATH. reg_tx_buf), UVM_LOW)	            

      // peek  
      apb_reg_block_h.d_reg.peek(status, value, .parent(this)); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD peek(): d reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  apb_reg_block_h.d_reg.get(), apb_reg_block_h.d_reg.get_mirrored_value(), `RTL_REG_PATH.reg_tx_buf, value), UVM_LOW)	
   endtask*/

   // Backdoor tasks functionality : write/read
   /*task value_reg_wr_rd_backdoor(); 
     begin
      // set()
      apb_reg_block_h.value_reg.set(7'hff); 	    
      `uvm_info("UART RAL_CHECK", $sformatf("BD set(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.value_reg.get(), apb_reg_block_h.value_reg.get_mirrored_value(), `RTL_REG_PATH.reg_count), UVM_LOW)	            

      // write 
      apb_reg_block_h.value_reg.write(status, 7'hff, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD write(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.value_reg.get(), apb_reg_block_h.value_reg.get_mirrored_value(), `RTL_REG_PATH.reg_count), UVM_LOW)	            

      // read
      apb_reg_block_h.value_reg.read(status, value, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD read(): value reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  apb_reg_block_h.value_reg.get(), apb_reg_block_h.value_reg.get_mirrored_value(), `RTL_REG_PATH.reg_count, value), UVM_LOW)	            
      end
    endtask*/

   // Backdoor tasks functionality : predict, mirror 
    task ct_reg_predict_mirror_backdoor(); 
      // set()
      apb_reg_block_h.ct_reg.set(32'h00000011); 	    
      `uvm_info("UART RAL_CHECK", $sformatf("BD set(): ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.ct_reg.get(), apb_reg_block_h.ct_reg.get_mirrored_value(), `RTL_REG_PATH.reg_ctrl), UVM_LOW)	            

      // predict 
     /* apb_reg_block_h.ct_reg.predict(32'h00000011, UVM_BACKDOOR); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD predict: ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h,  \n",  apb_reg_block_h.ct_reg.get(), apb_reg_block_h.ct_reg.get_mirrored_value(), `RTL_REG_PATH.reg_ctrl), UVM_LOW)*/	            

      //mirror 
      apb_reg_block_h.ct_reg.mirror(status, UVM_CHECK, UVM_BACKDOOR, .parent(this)); 
      `uvm_info("UART RAL_CHECK", $sformatf("BD mirror(): ctrl reg - des_val=%0h, mirr_val=%0h, hw_reg_val=%0h, read_val=%0h \n",  apb_reg_block_h.ct_reg.get(), apb_reg_block_h.ct_reg.get_mirrored_value(), `RTL_REG_PATH.reg_ctrl, value), UVM_LOW)	            
    endtask


endclass
