/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb driver class
 Filename:   	apb_driver.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/
`ifdef original
typedef class apb_xtn;
//typedef class apb_driver;

class apb_driver extends uvm_driver #(apb_xtn);
  `uvm_component_utils(apb_driver)
  
  //declare agent configation and virtual interface
  apb_agent_config apb_agt_cfg;
  virtual APB_UART_if.DRV_MP vif;
  
`uvm_register_cb(apb_driver,driver_callback)

//*******************************Methods***********************************
  extern function new(string name="apb_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(apb_xtn xtn);
  extern task inject_err(apb_xtn xtn);
endclass:apb_driver

//******************************Constructor*********************************
function apb_driver:: new (string name="apb_driver",uvm_component parent);
  super.new(name,parent);
endfunction:new

//*****************************Build_phase**********************************
function void apb_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",apb_agt_cfg))
    `uvm_fatal("DRIVER_VIF0","get interface to driver")
  endfunction:build_phase
  
//*****************************Connect_phase*********************************  
function void apb_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif=apb_agt_cfg.vif;
endfunction

//*******************************Run_phase***********************************
task apb_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
endtask:run_phase

//*************************Send to Dut Method****8****************************
task apb_driver::send_to_dut(apb_xtn xtn);

if(xtn.call_back)
inject_err(xtn);	

 $display("============== APB_DRIVER==============");
 //`uvm_info("APB_DRIVER",$sformatf("printing from apb_driver\n %s",xtn.sprint),UVM_LOW)
if(xtn.trans_type==write)
  begin
    //*******************************WRITE OPERATION*************************//
    
@(vif.drv_cb);
    vif.drv_cb.addr	    <=	xtn.addr;
    vif.drv_cb.trans_type  <=	write;
    vif.drv_cb.sel	    <=	1'b1;
    vif.drv_cb.enable	    <=	1'b0;
    vif.drv_cb.wdata	    <=	xtn.wdata;
    
    
@(vif.drv_cb);
 $display($time,"addr=%0d===================",vif.drv_cb.addr);   
 $display($time,"driver_wdata=%0d===================",vif.drv_cb.wdata);   
vif.drv_cb.sel         <=  1'b1;
    vif.drv_cb.enable      <=  1'b1;
    
@(vif.drv_cb);
    vif.drv_cb.sel         <=  1'b0;
    vif.drv_cb.enable      <=  1'b0;
  
   xtn.temp=vif.drv_cb.wdata;
   $display("temp=%h",xtn.temp);
  
  end
else
  //*****************************READ OPERATION***********************************//
  begin
    
@(vif.drv_cb);
    vif.drv_cb.addr        <=  xtn.addr;
    vif.drv_cb.trans_type  <=  read;
    vif.drv_cb.sel         <=  1'b1;
    vif.drv_cb.enable      <=  1'b0;
    
@(vif.drv_cb);
    vif.drv_cb.sel	    <=  1'b1;
    vif.drv_cb.enable      <=  1'b1;
    
@(vif.drv_cb);
    xtn.rdata=vif.drv_cb.rdata;
    $display($time,"Rdata>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=%h",xtn.rdata);
    vif.drv_cb.sel         <=  1'b0;
    vif.drv_cb.enable      <=  1'b0;
 
  end
endtask:send_to_dut

task apb_driver::inject_err(apb_xtn xtn);
	`uvm_do_callbacks(apb_driver,driver_callback,inject_err(this,xtn))
endtask

`else
typedef class apb_xtn;
//typedef class apb_driver;

class apb_driver extends uvm_driver #(apb_xtn);
  `uvm_component_utils(apb_driver)
  
  //declare agent configation and virtual interface
  apb_agent_config m_cfg;
  virtual APB_UART_if.DRV_MP vif;
  
`uvm_register_cb(apb_driver,driver_callback)

//*******************************Methods***********************************
  extern function new(string name="apb_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  //extern task run_phase(uvm_phase phase);
  extern task reset_phase(uvm_phase phase);
  extern task configure_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern task shutdown_phase(uvm_phase phase);
  extern task send_to_dut(apb_xtn xtn);
  extern task inject_err(apb_xtn xtn);
endclass:apb_driver

//******************************Constructor*********************************
function apb_driver:: new (string name="apb_driver",uvm_component parent);
  super.new(name,parent);
endfunction:new

//*****************************Build_phase**********************************
function void apb_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",m_cfg))
    `uvm_fatal("DRIVER_VIF0","get interface to driver")
  endfunction:build_phase
  
//*****************************Connect_phase*********************************  
function void apb_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif=m_cfg.vif;
endfunction

//*******************************Run_phase***********************************
/*task apb_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
endtask:run_phase*/

task apb_driver::reset_phase(uvm_phase phase);
	phase.raise_objection();
	repeat(10)
begin
	$display("%0t RESET",$time);
        	seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		$display("%0t RESET END",$time);
	end
	phase.drop_objection(phase);
endtask

task apb_driver ::configure_phase(uvm_phase phase);
	phase.raise_objection(phase);
	$display("%0t CONFIGURE",$time);
	$display("%0t get next item CONFIGURE",$time);
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done();
	$display("%0t item done CONFIGURE",$time);
	$display("%0t CONFIGURE END",$time);
	phase.drop_objection(phase);
endtask

task apb_driver ::main_phase(uvm_phase phase);
	phase.raise_objection(phase);
	$display("%0t MAIN",$time);
	begin
	$display("%0t get next item MAIN",$time);
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	$display("%0t item done MAIN",$time);
	end
	#1;
	repeat(3) 
	begin
	$display("%0t get next item MAIN",$time);
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	$display("%0t item done MAIN",$time);
	end
	$display("%0t MAIN END",$time);
	phase.drop_objection(phase);
endtask

task apb_driver ::shutdown_phase(uvm_phase phase);
	phase.raise_objection(phase);
	$display("%0t SHUTDOWN",$time);
	$display("%0t get next item SHUTDOWN",$time);
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done();
	$display("%0t item done SHUTDOWN",$time);
	$display("%0t SHUTDOWN END",$time);
	phase.drop_objection(phase);
endtask


//*************************Send to Dut Method****8****************************
task apb_driver::send_to_dut(apb_xtn xtn);

if(xtn.call_back)
inject_err(xtn);	

 $display("============== APB_DRIVER==============");
 //`uvm_info("APB_DRIVER",$sformatf("printing from apb_driver\n %s",xtn.sprint),UVM_LOW)
if(xtn.trans_type==write)
  begin
    //*******************************WRITE OPERATION*************************//
    
@(vif.drv_cb);
    vif.drv_cb.addr	    <=	xtn.addr;
    vif.drv_cb.trans_type  <=	write;
    vif.drv_cb.sel	    <=	1'b1;
    vif.drv_cb.enable	    <=	1'b0;
    vif.drv_cb.wdata	    <=	xtn.wdata;
    
    
@(vif.drv_cb);
 $display($time,"addr=%0d===================",vif.drv_cb.addr);   
 $display($time,"driver_wdata=%0d===================",vif.drv_cb.wdata);   
vif.drv_cb.sel         <=  1'b1;
    vif.drv_cb.enable      <=  1'b1;
    
@(vif.drv_cb);
    vif.drv_cb.sel         <=  1'b0;
    vif.drv_cb.enable      <=  1'b0;
  
   xtn.temp=vif.drv_cb.wdata;
   $display("temp=%h",xtn.temp);
  
  end
else
  //*****************************READ OPERATION***********************************//
  begin
    
@(vif.drv_cb);
    vif.drv_cb.addr        <=  xtn.addr;
    vif.drv_cb.trans_type  <=  read;
    vif.drv_cb.sel         <=  1'b1;
    vif.drv_cb.enable      <=  1'b0;
    
@(vif.drv_cb);
    vif.drv_cb.sel	    <=  1'b1;
    vif.drv_cb.enable      <=  1'b1;
    
@(vif.drv_cb);
    xtn.rdata=vif.drv_cb.rdata;
    $display($time,"Rdata>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=%h",xtn.rdata);
    vif.drv_cb.sel         <=  1'b0;
    vif.drv_cb.enable      <=  1'b0;
 
  end
endtask:send_to_dut

task apb_driver::inject_err(apb_xtn xtn);
	`uvm_do_callbacks(apb_driver,driver_callback,inject_err(this,xtn))
endtask
`endif

