/***********************************************************
Author 		: Ramkumar 
File 		: master_driver.sv
Module name     : master_driver 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 
`ifdef original
typedef class master_trans;

class master_driver extends uvm_driver#(master_trans);
	 `uvm_component_utils(master_driver)
//Declaring Handles
virtual wtapb_if.APB_DRIVER vif;
master_config driver_cfg;

`uvm_register_cb(master_driver,driver_callback)

//************************methods and functions***********************
extern function new (string name="master_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(master_trans xtn);
extern task inject_err(master_trans trans);
extern task inject_apb_err(master_trans trans);
endclass:master_driver


//*******************************Constructor*******************************
function master_driver :: new (string name="master_driver",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void master_driver ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(master_config)::get(this,"","master_config",driver_cfg))
	`uvm_fatal("MASTER DRIVER","Unable to get master config in driver")

endfunction:build_phase

//*******************************Connect_phase*********************************
function void master_driver::connect_phase(uvm_phase phase);
`uvm_info("MASTER DRIVER","///////Connect phase////////",UVM_MEDIUM)
vif=driver_cfg.vif;
endfunction

//*******************************Run_phase*********************************
task master_driver ::run_phase(uvm_phase phase);
	master_trans mtx;
forever
	begin
		`uvm_info("MASTER DRIVER","///////Run phase////////",UVM_MEDIUM)
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end

endtask:run_phase

task master_driver::send_to_dut(master_trans xtn);
//To enable callback for wdog corruption
if(xtn.enb_callback)
inject_err(xtn);
//To To enable callback for wdog corruption
if(xtn.apb_callback)
inject_apb_err(xtn);

    begin
     	`uvm_info("MASTER DRIVER","///////Send to dut phase////////",UVM_MEDIUM)
	if(xtn.pwrite==1)
 	 begin
		 //Reset logic
	if(!xtn.presetn)
	begin
	@(vif.apb_driver_cb)
	vif.apb_driver_cb.presetn<=1'b0;
	@(vif.apb_driver_cb)
	vif.apb_driver_cb.presetn<=1'b1;
	end

    	    @(vif.apb_driver_cb)
   	    vif.apb_driver_cb.paddr<=xtn.paddr;
   	    vif.apb_driver_cb.pwrite<=xtn.pwrite;
	    vif.apb_driver_cb.psel<=xtn.psel;
	    vif.apb_driver_cb.penable<=1'b0;
	    vif.apb_driver_cb.pwdata<=xtn.pwdata;
	    @(vif.apb_driver_cb)
    	    vif.apb_driver_cb.penable<=1'b1;
	    xtn.penable=1'b1;
`uvm_info("MASTER DRIVER",$sformatf("Printing From Master driver %s",req.sprint()),UVM_LOW)    

	    @(vif.apb_driver_cb)
	    vif.apb_driver_cb.psel<=1'b0;
	    vif.apb_driver_cb.penable<=1'b0;
          end
	else 
   	  begin   
	@(vif.apb_driver_cb)
    	  vif.apb_driver_cb.paddr<=xtn.paddr;
	  vif.apb_driver_cb.pwdata<=xtn.pwdata;
          vif.apb_driver_cb.pwrite<=xtn.pwrite;
          vif.apb_driver_cb.psel<=xtn.psel;
          vif.apb_driver_cb.penable<=1'b0;
          xtn.penable=1'b0;
          xtn.pwdata=0;
          `uvm_info("MASTER DRIVER",$sformatf("\nPrinting Read Transfer From Master Driver Control Part",xtn.sprint()),UVM_LOW)
          @(vif.apb_driver_cb)
          vif.apb_driver_cb.penable<=1'b1;
	  vif.apb_driver_cb.psel<=1'b1;
          xtn.penable=1'b1;
	  `uvm_info("MASTER DRIVER",$sformatf("\nPrinting Read Transfer From Master Driver Enable Part",xtn.sprint()),UVM_LOW)
	  @(vif.apb_driver_cb)
	  vif.apb_driver_cb.psel<=1'b0;
	  vif.apb_driver_cb.penable<=1'b0;
         end
     end

endtask

task master_driver::inject_err(master_trans trans);
`uvm_do_callbacks(master_driver,driver_callback,inject_err(this,trans))
endtask

task master_driver::inject_apb_err(master_trans trans);
`uvm_do_callbacks(master_driver,driver_callback,inject_apb_err(this,trans))
endtask

`else
typedef class master_trans;

class master_driver extends uvm_driver#(master_trans);
	 `uvm_component_utils(master_driver)
//Declaring Handles
virtual wtapb_if.APB_DRIVER vif;
master_config driver_cfg;

`uvm_register_cb(master_driver,driver_callback)

//************************methods and functions***********************
extern function new (string name="master_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
extern task reset_phase(uvm_phase phase);
extern task configure_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);
extern task shutdown_phase(uvm_phase phase);
extern task send_to_dut(master_trans xtn);
extern task inject_err(master_trans trans);
extern task inject_apb_err(master_trans trans);
endclass:master_driver


//*******************************Constructor*******************************
function master_driver :: new (string name="master_driver",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void master_driver ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(master_config)::get(this,"","master_config",driver_cfg))
	`uvm_fatal("MASTER DRIVER","Unable to get master config in driver")

endfunction:build_phase

//*******************************Connect_phase*********************************
function void master_driver::connect_phase(uvm_phase phase);
`uvm_info("MASTER DRIVER","///////Connect phase////////",UVM_MEDIUM)
vif=driver_cfg.vif;
endfunction

//*******************************Run_phase*********************************
/*task master_driver ::run_phase(uvm_phase phase);
	master_trans mtx;
	forever
	begin
	$display("%0t Running in driver",$time);
    	    	@(vif.apb_driver_cb)
        	if(vif.apb_driver_cb.presetn==1'b0)
		begin
			//->e;
			$display("uuuuuuuuuuuuuuuuuuuuuuuuu");
		end
	end


endtask:run_phase*/

task master_driver ::reset_phase(uvm_phase phase);
	phase.raise_objection(phase);
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

task master_driver ::configure_phase(uvm_phase phase);
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

task master_driver ::main_phase(uvm_phase phase);
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

task master_driver ::shutdown_phase(uvm_phase phase);
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

task master_driver::send_to_dut(master_trans xtn);
//To enable callback for wdog corruption
if(xtn.enb_callback)
inject_err(xtn);
//To To enable callback for wdog corruption
if(xtn.apb_callback)
inject_apb_err(xtn);

    	begin
     		`uvm_info("MASTER DRIVER","///////Send to dut phase////////",UVM_MEDIUM)
		if(xtn.pwrite==1)
 	 	begin
    	    		@(vif.apb_driver_cb)
   	    		vif.apb_driver_cb.paddr<=xtn.paddr;
   	    		vif.apb_driver_cb.pwrite<=xtn.pwrite;
	    		vif.apb_driver_cb.psel<=xtn.psel;
	    		vif.apb_driver_cb.penable<=1'b0;
	    		vif.apb_driver_cb.pwdata<=xtn.pwdata;
	    		@(vif.apb_driver_cb)
    	    		vif.apb_driver_cb.penable<=1'b1;
	   		xtn.penable=1'b1;
			`uvm_info("MASTER DRIVER",$sformatf("Printing From Master driver %s",req.sprint()),UVM_LOW)    

	    		@(vif.apb_driver_cb)
	    		vif.apb_driver_cb.psel<=1'b0;
	    		vif.apb_driver_cb.penable<=1'b0;
          	end
		else 
   	  	begin   
			@(vif.apb_driver_cb)
    	  		vif.apb_driver_cb.paddr<=xtn.paddr;
	  		vif.apb_driver_cb.pwdata<=xtn.pwdata;
          		vif.apb_driver_cb.pwrite<=xtn.pwrite;
          		vif.apb_driver_cb.psel<=xtn.psel;
          		vif.apb_driver_cb.penable<=1'b0;
          		xtn.penable=1'b0;
          		xtn.pwdata=0;
          		`uvm_info("MASTER DRIVER",$sformatf("\nPrinting Read Transfer From Master Driver Control Part",xtn.sprint()),UVM_LOW)
          		@(vif.apb_driver_cb)
          		vif.apb_driver_cb.penable<=1'b1;
	  		vif.apb_driver_cb.psel<=1'b1;
          		xtn.penable=1'b1;
	  		`uvm_info("MASTER DRIVER",$sformatf("\nPrinting Read Transfer From Master Driver Enable Part",xtn.sprint()),UVM_LOW)
	  		@(vif.apb_driver_cb)
	  		vif.apb_driver_cb.psel<=1'b0;
	  		vif.apb_driver_cb.penable<=1'b0;
        	 end
     end

endtask

task master_driver::inject_err(master_trans trans);
`uvm_do_callbacks(master_driver,driver_callback,inject_err(this,trans))
endtask

task master_driver::inject_apb_err(master_trans trans);
`uvm_do_callbacks(master_driver,driver_callback,inject_apb_err(this,trans))
endtask
`endif
