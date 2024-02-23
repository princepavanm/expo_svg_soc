//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : Master_driver
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class master_driver extends uvm_driver#(master_AHB_xtn);
  `uvm_component_utils(master_driver) // Factory Registration

  master_agent_config magt_cfg; //master agent config handel declaration
  virtual AHB_SRAM_if.MDR_MP vif0; //interface through modports
  //ahb_agent_config ahb_agent_cfg;
uvm_analysis_port#(master_AHB_xtn) driver_port;

//***************************Extern functions*********************************************************
extern function new(string name="master_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(master_AHB_xtn xtn);
//extern function void report_phase(uvm_phase phase);
endclass

//*********************************Constractor*********************************************************
function master_driver::new(string name="master_driver", uvm_component parent);
  super.new(name,parent);
endfunction

//*********************************Build phase*********************************************************
function void master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(master_agent_config)::get(this,"","master_agent_config",magt_cfg))
	`uvm_fatal("MASTER_AGENT_CONFIG","cannot get() magt_cfg from uvm_config")
driver_port=new("driver_port",this);
endfunction

//*******************************Connect phase*********************************************************
function void master_driver::connect_phase(uvm_phase phase);
vif0=magt_cfg.vif0;
endfunction 

//**********************************Run phase*********************************************************
task master_driver::run_phase(uvm_phase phase);
//@(vif0.wdr_cb);
vif0.wdr_cb.hresetn<=0;
@(vif0.wdr_cb);
vif0.wdr_cb.hresetn<=1;
@(vif0.wdr_cb);
forever
//repeat(10)
  begin
	  	//$display($time,"driver started");
	 seq_item_port.get_next_item(req);
         send_to_dut(req);
	 seq_item_port.item_done();
	 //$display($time,"driver end");
  end
endtask

//*********************************task send_to_dut***************************************************
task master_driver::send_to_dut(master_AHB_xtn xtn);
//`uvm_info("WR_DRIVER",$sformatf("printing from master_driver\n %0s",xtn.sprint),UVM_LOW)
//$display($time,"driver task  started");
//-----write logic-----
if (xtn.hwrite==1)
  begin
     vif0.wdr_cb.hready<=xtn.hready;
 	  vif0.wdr_cb.hsel<=xtn.hsel;
	  vif0.wdr_cb.haddr<=xtn.haddr;
	  vif0.wdr_cb.hsize<=xtn.hsize;
	  vif0.wdr_cb.htrans<=xtn.htrans;
	  vif0.wdr_cb.hwrite<=xtn.hwrite;
	   @(vif0.wdr_cb); 
	  vif0.wdr_cb.hwdata<=xtn.hwdata;
	   xtn.temp=vif0.wdr_cb.hwdata;
   end
	else
//-----Read logic-----
    begin
   	  //@(vif0.wdr_cb);
          vif0.wdr_cb.hready<=xtn.hready;
	  vif0.wdr_cb.hsel<=xtn.hsel;
	  vif0.wdr_cb.haddr<=xtn.haddr;
	  vif0.wdr_cb.hsize<=xtn.hsize;
	  vif0.wdr_cb.htrans<=xtn.htrans;
	  vif0.wdr_cb.hwrite<=xtn.hwrite;
	  @(vif0.wdr_cb);
          @(vif0.wdr_cb);
	  xtn.hrdata=vif0.wdr_cb.hrdata;
          $display($time, "  AHB DRIVER addr=%0h, read data=%0h\n", xtn.haddr, xtn.hrdata);
	  magt_cfg.count_ahb_driver_xtn++;
    end
  
 	driver_port.write(xtn);
//	$display($time,"driver task end");
 @(vif0.wdr_cb); 
 //@(vif0.wdr_cb); 
endtask
