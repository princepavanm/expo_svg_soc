class reset_driver extends uvm_driver#(reset_trans);
	 `uvm_component_utils(reset_driver)
	 
	virtual reset_if.RESET_DRIVER vif1;
	reset_config driver_cfg;
	
	//************************methods and functions***********************
	extern function new (string name="reset_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task reset_phase(uvm_phase phase);
	extern task configure_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task shutdown_phase(uvm_phase phase);
	extern task send_to_dut(reset_trans xtn);
endclass:reset_driver


//*******************************Constructor*******************************
function reset_driver :: new (string name="reset_driver",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void reset_driver ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

	//Get config_db
	if(!uvm_config_db #(reset_config)::get(this,"","reset_config",driver_cfg))
		`uvm_fatal("RESET DRIVER","Unable to get reset config in driver")
endfunction:build_phase

//*******************************Connect_phase*********************************
function void reset_driver::connect_phase(uvm_phase phase);
	`uvm_info("RESET DRIVER","///////Connect phase////////",UVM_MEDIUM)
	vif1=driver_cfg.vif1;
endfunction

//*******************************Run_phase*********************************
task reset_driver ::reset_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(2)
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
	phase.drop_objection(this);
endtask:reset_phase

task reset_driver ::configure_phase(uvm_phase phase);
	phase.raise_objection(this);
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
	phase.drop_objection(this);
endtask:configure_phase

task reset_driver ::main_phase(uvm_phase phase);
phase.raise_objection(this);
	repeat(3)
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
phase.drop_objection(this);
endtask:main_phase

task reset_driver ::shutdown_phase(uvm_phase phase);
	phase.raise_objection(this);
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
	phase.drop_objection(this);
endtask:shutdown_phase

task reset_driver::send_to_dut(reset_trans xtn);
	@(vif1.reset_driver_cb)
	if(!xtn.wdogresn && !xtn.presetn)
	begin
		vif1.reset_driver_cb.presetn<=1'b0;
		vif1.reset_driver_cb.wdogresn<=1'b0;
		//$display("TRIGGERING");
		//->e;
	end
	else if(!xtn.wdogresn && xtn.presetn)
	begin
		vif1.reset_driver_cb.presetn<=1'b1;
		vif1.reset_driver_cb.wdogresn<=1'b0;
	end
	else if(xtn.wdogresn && !xtn.presetn)
	begin
		vif1.reset_driver_cb.presetn<=1'b0;
		vif1.reset_driver_cb.wdogresn<=1'b1;
		->e;
	end
	else
	begin
		vif1.reset_driver_cb.wdogresn<=1'b1;
		vif1.reset_driver_cb.presetn<=1'b1;
	end
endtask
