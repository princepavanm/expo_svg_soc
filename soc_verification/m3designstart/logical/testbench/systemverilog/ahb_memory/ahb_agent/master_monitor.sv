//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : Master_monitor
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class master_monitor extends uvm_monitor;
   `uvm_component_utils(master_monitor) // Factory Registration
  
 // ahb_agent_config magt_cfg;
  virtual AHB_SRAM_if.MMON_MP vif0; //interface through modports
	master_agent_config m_agt_cfg;    //master agent config handel declaration
	uvm_analysis_port #(master_AHB_xtn) monitor_port; //connection between master_monitor to dut through analysis port
	master_AHB_xtn data_send; //master_transaction handle declartion

//master_AHB_xtn mon_xtn;
//master_AHB_xtn driv_xtn;

//======================================================================  
//ahb_functional_Coverage 
//======================================================================  

   master_AHB_xtn ahb_cov_xtn;
  
 covergroup ahb_cov ();
  
  // coverage for reset signal
      HRESET:coverpoint ahb_cov_xtn.hresetn
      { 
        bins Reset_low={0};
        bins Reset_high={1};
      }
	  
  // coverage for transfer_type
      AHB_TRANSFER_TYPE:coverpoint ahb_cov_xtn.htrans
      {
        bins trans_nonseq={2'b10};
        bins trans_seq={2'b11};
      }
	  
  // coverage for slave select signal
      AHB_SEL:coverpoint ahb_cov_xtn.hsel
      {
        bins slave_select={1};
        bins slave_unselect={0};
      }
	  
  // coverage for address  
    AHB_ADDR:coverpoint ahb_cov_xtn.haddr
      {
        bins addr_low={[100:0]};
        bins addr_mid1={[150:101]};
        bins addr_mid2={[200:151]};
        bins addr_high={[255:201]};
      }
	  
  // coverage for tranfser size
       AHB_HSIZE_TYPE:coverpoint ahb_cov_xtn.hsize
      {
       bins size_byte={3'b000};
       bins size_halfword={3'b001};
       bins size_word={3'b010};
       } 
	  
  // coverage for tranfser size
       AHB_READ_WRITE:coverpoint ahb_cov_xtn.hwrite
      {
        bins read={0};
	      bins write={1};
      }
	  
  // coverage for write data 
      AHB_WRITE_DATA:coverpoint ahb_cov_xtn.hwdata
      {
        bins Write_data_low={[100:0]};
        bins Write_data_mid1={[300:101]};
	      bins Write_data_mid2={[700:301]};
	      bins Write_data_mid3={[1024:701]};
	          }
  // coverage for ready to transfer     
      AHB_READY:coverpoint ahb_cov_xtn.hready
      {
        bins ready_transfer={1};
        bins not_ready_transfer={0};
      }
 // coverage for slave ready to transfer     
     AHB_READYOUT:coverpoint ahb_cov_xtn.hreadyout
      {
      	bins Readyout_low={0};
      }	
 // coverage for response from slave         
      AHB_RESP:coverpoint ahb_cov_xtn.hresp
	   {
	    bins okay_resp={0}; 
		   }
 // coverage for read data  
     AHB_HRDATA:coverpoint ahb_cov_xtn.hrdata
     {
        bins read_data_low={[100:0]};
        bins read_data_mid1={[300:101]};
	      bins read_data_mid2={[700:301]};
	      bins read_data_mid3={[1024:701]};
	    }
 
  endgroup


//***************************Extern functions*********************************************************
  extern function new(string name="master_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

//*********************************Constractor*********************************************************
function master_monitor::new(string name="master_monitor", uvm_component parent);

super.new(name,parent);
	ahb_cov=new();

endfunction

//*********************************Build phase*********************************************************
function void master_monitor::build_phase(uvm_phase phase);

if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",m_agt_cfg))
	`uvm_fatal("MASTER_AGT_CONFIG","cannot get() m_agt_cfg from uvm_config")
super.build_phase(phase);

monitor_port=new("monitor_port",this);
endfunction

//*******************************Connect phase*********************************************************
function void master_monitor::connect_phase(uvm_phase phase);
vif0=m_agt_cfg.vif0;
endfunction

//**********************************Run phase*********************************************************
task master_monitor::run_phase(uvm_phase phase);
 @(vif0.wmon_cb);
 @(vif0.wmon_cb);
 //@(vif0.wmon_cb);
   forever
//repeat(10)	
	begin
		//$display($time,"monitor started");
		collect_data();
		      ahb_cov_xtn=data_send;
		      ahb_cov.sample();
		  //    $display($time,"monitor end");
           	
	end
	
endtask

//*********************************task collect_data***************************************************
task master_monitor::collect_data();
begin 
	//$display($time,"collect task monitor started");
 data_send=master_AHB_xtn::type_id::create("data_send" );
   
   @(vif0.wmon_cb);
//@(vif0.wmon_cb);
    if(vif0.wmon_cb.hwrite==1)
      begin
     data_send.hready=vif0.wmon_cb.hready;
      @(vif0.wmon_cb);
  
    data_send.hresetn=vif0.wmon_cb.hresetn;
    data_send.hsel =vif0.wmon_cb.hsel;
    data_send.hwrite=vif0.wmon_cb.hwrite ;
    data_send.hsize=vif0.wmon_cb.hsize;
    data_send.haddr=vif0.wmon_cb.haddr ;
    data_send.htrans=vif0.wmon_cb.htrans ;
    
   // @(vif0.wmon_cb);
    data_send.hwdata=vif0.wmon_cb.hwdata;

     //@(vif0.wmon_cb);
    
    // m_agt_cfg. count_ahb_monitor_xtn++;
 // data_send.hrdata=vif0.wmon_cb.hrdata;
		end
		else
		  begin
			  //@(vif0.wmon_cb); 
		  data_send.hsel =vif0.wmon_cb.hsel;
    data_send.hwrite=vif0.wmon_cb.hwrite ;
    data_send.hsize=vif0.wmon_cb.hsize;
    data_send.haddr=vif0.wmon_cb.haddr ;
    data_send.htrans=vif0.wmon_cb.htrans ;
    data_send.hready=vif0.wmon_cb.hready;
    @(vif0.wmon_cb);
  //  data_send.hwdata=vif0.wmon_cb.hwdata;

     //@(vif0.wmon_cb);
    
    // m_agt_cfg. count_ahb_monitor_xtn++;
  data_send.hrdata=vif0.wmon_cb.hrdata;
end
	//monitor_port.write(data_send);	
	//$display("============================= MASTER MONITOR ================================================");
	`uvm_info("MASTER_MONITOR", $sformatf(" Data received in Master Monitor %s",data_send.sprint()) , UVM_LOW)
	 //@(vif0.wmon_cb);
	//$display($time,"collect task monitorend");
end		
endtask
