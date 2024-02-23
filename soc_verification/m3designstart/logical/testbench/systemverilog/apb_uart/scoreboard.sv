/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	scoreboard class
 Filename:   	scoreboard.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

// Environment configuration handle  
  env_config env_cfg;

// Transcation handle  
  apb_xtn  apb_data1;
  uart_xtn uart_data1;
  apb_xtn  apb_data2 [];
  uart_xtn uart_data2[];
  int i;
  int j;
// Declration of TLM_ANALYSIS_FIFO   
  uvm_tlm_analysis_fifo#(apb_xtn)apb_fifo;
  uvm_tlm_analysis_fifo#(uart_xtn)uart_fifo;  

  //***************************Methods*******************************
  extern function new(string name="scoreboard",  uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);
  extern function void check_data();
endclass :scoreboard

//***************************Constructor*****************************
function scoreboard::new(string name="scoreboard",  uvm_component parent);
  super.new(name,parent);
  apb_fifo=new("apb_fifo",this);
  uart_fifo=new("uart_fifo",this);
  //uart_data1=uart_xtn::type_id::create("uart_data1"); 
  //apb_data1=apb_xtn::type_id::create("apb_data1");

endfunction:new

//**************************Build_phase******************************
function void scoreboard:: build_phase(uvm_phase phase);
if (!uvm_config_db#(env_config)::get(this,"*","env_config",env_cfg))
   `uvm_fatal("ENV_CONFIG","get interface to scoreboard")
   super.build_phase(phase);
   apb_data2=new[8];
   uart_data2=new[8];
endfunction:build_phase 

//************************run_phase method*************************** 
task scoreboard::run_phase(uvm_phase phase);
  	fork
		forever
		  begin
		    apb_fifo.get(apb_data1);
		    apb_data2[i]=new apb_data1;
			i++;
			$display("/////i//////%d///////i////",i);
 $display("==============APB_SCOREBOARD===============");
  `uvm_info("APB_FIFO",$sformatf("data received from apb_monitor =%s",apb_data1.sprint()),UVM_LOW)
		  end

		forever
		  begin
		   uart_fifo.get(uart_data1);
		   uart_data2[j]=new uart_data1;
		   j++;
		$display("////j/////%d/////j////",j);
 
$display("==============UART_SCOREBOARD===============");
  `uvm_info("UART_FIFO",$sformatf("data received from uart monitor =%s",uart_data1.sprint()),UVM_LOW)
		  end
	join	
endtask:run_phase
	
//*******************************Check_phase*******************************
	function void scoreboard::check_phase(uvm_phase phase);
	  begin
	super.check_phase(phase);
	  check_data();
	   
	  end
	endfunction:check_phase
		
//***************************Check_data methods*******************************
 function void scoreboard::check_data();
	 	 
`uvm_info (get_type_name(),">>>>>>>>>>>>>>>>>>>>>>>>>>Check_Phase<<<<<<<<<<<<<<<<<<<<<<<<",UVM_MEDIUM)
	  
begin
  if(env_cfg.reset_flag==1)
  begin
  $display("Reset_check");
  env_cfg.reset_flag=0;
  end
 
 else if(env_cfg.write_read_flag==1)
    begin
    $display("write_read_Check");
    env_cfg.write_read_flag=0;  
  end

 else if(env_cfg.TX_test_flag==1)
      begin
 	      if(apb_data2[2].temp==uart_data2[0].wdata1)
	  	      begin
	           `uvm_info(get_type_name(),">>>>>>DATA_MATCHED",UVM_LOW)
		   $display("expected data wdata=%h,TXD=%h",apb_data2[2].temp,uart_data2[0].wdata1);
	         end
	     else
	       begin
	           `uvm_info(get_type_name(),">>>>>>DATA_NOT_MATCHED",UVM_LOW)
	           $display("expected data wdata=%h,TXD=%h",apb_data2[2].temp,uart_data2[0].wdata1);
	       end
	env_cfg.TX_test_flag=0;
    end
else if(env_cfg.RX_test_flag==1) 
   begin
     
	         if(apb_data2[2].rdata==uart_data2[0].rdata1)
	  	          begin
	               `uvm_info(get_type_name(),"DATA_MATCHED",UVM_LOW)
	               $display("expected data rdata=%h,RXD=%h",apb_data2[2].rdata,uart_data2[0].rdata1);
	             end
	         else
	             begin
	               `uvm_info(get_type_name(),"DATA_NOT_MATCHED",UVM_LOW)
	               $display("expected data rdata=%h,RXD=%h",apb_data2[2].rdata,uart_data2[0].rdata1);
	             end
	      
	env_cfg.RX_test_flag=0; 
   end
 else if(env_cfg.Multi_Tx_test_flag==1)
 begin
	 if(env_cfg.interrupt==1)
	         begin
	    	`uvm_info(get_type_name(),"MULTPLE TX VLAUE SUCESSFUL",UVM_MEDIUM)
	         end
	    else
	       	begin
	        `uvm_info(get_type_name(),"MULTPLE TX VLAUE NOT SUCESSFUL",UVM_MEDIUM)
	         end
			env_cfg.Multi_Tx_test_flag=0;
 end
	         
 else if(env_cfg.Multi_Rx_test_flag==1)
   		begin
      			if(env_cfg.interrupt==1)
        			begin
	    			`uvm_info(get_type_name(),"MULTPLE RX VLAUE SUCESSFUL",UVM_MEDIUM)
	         		end
	    		else
	       			begin
	             		`uvm_info(get_type_name(),"MULTPLE RX VLAUE NOT SUCESSFUL",UVM_MEDIUM)
	         		end
 			env_cfg.Multi_Rx_test_flag=0;

	         end
  else if(env_cfg.Tx_Rx_test_flag==1)

  begin
	  if(env_cfg.interrupt==1)
	  	begin
	    		`uvm_info(get_type_name(),"BOTH READ AND WRITE OPERARTION(DUPLEX) IS SUCESSFUL",UVM_MEDIUM)
	  	end
	   else     
	  	begin
	    		`uvm_info(get_type_name(),"BOTH READ AND WRITE OPERARTION(DUPLEX) NOT IS SUCESSFUL",UVM_MEDIUM)
	  	end
			
		env_cfg.Tx_Rx_test_flag=0;
  end
 
  else if(env_cfg.Over_Rx_test_flag==1)
   		begin
      			if(env_cfg.interrupt==1)
        			begin
	    			`uvm_info(get_type_name()," RX OVERFLOW SUCCESSFUL ",UVM_MEDIUM)
	         		end
	    		else
	       			begin
	             		`uvm_info(get_type_name(),"RX OVERFLOW NOT SUCCESSFUL",UVM_MEDIUM)
	         		end
  		env_cfg.Over_Rx_test_flag=0;
	        end
  else if(env_cfg.Over_Tx_test_flag==1)
   		begin
      			if(env_cfg.interrupt==1)
        			begin
	    			`uvm_info(get_type_name()," TX OVERFLOW SUCCESSFUL ",UVM_MEDIUM)
	         		end
	    		else
	       			begin
	             		`uvm_info(get_type_name(),"TX OVERFLOW NOT SUCCESSFUL",UVM_MEDIUM)
	         		end
  		env_cfg.Over_Tx_test_flag=0;
	         end
  
  
 else if(env_cfg.TX_test_cb_flag==1)
    begin
    $display("-----------call back check---------------------");
    env_cfg.TX_test_cb_flag=0;  
  end
	else
     		begin
       			$display("SOMETHING WENT WORONG");
       		end

 end   
   
endfunction:check_data
