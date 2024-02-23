//class env_parent extends uvm_env; 
//    function new(string name = "env_parent",uvm_component parent);
//	super.new(name,parent);
//    endfunction
//endclass

class wtenv extends uvm_env;
	 `uvm_component_utils(wtenv)
      /********Watchdog Timer related components ***********/
	master_agent wdog_agent;
	master_config wdog_master_cfg_h;
	wtenv_config wtenv_cfg_h;
	reg_adapter adapter_wdog;
	uvm_reg_predictor#(master_trans) predictor_wdog;

 	//************************methods and functions***********************
	extern function new (string name="wtenv",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void report_phase(uvm_phase phase);
endclass:wtenv


//*******************************Constructor*******************************
function wtenv :: new (string name="wtenv",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void wtenv ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

	//Get config_db
	if(!uvm_config_db #(wtenv_config)::get(this,"","wtenv_config",wtenv_cfg_h))
		`uvm_fatal("Watchdog Env","Unable to get env config in wt env")
             wdog_master_cfg_h = master_config ::type_id::create("wdog_master_cfg_h");
             wdog_master_cfg_h.vif = wtenv_cfg_h.vif ;
             //wdog_master_cfg_h.has_master_agent=wtenv_cfg_h.has_master_agent;
             wdog_master_cfg_h.IS_ACTIVE=UVM_PASSIVE;

	//creating master top
	//if(wdog_master_cfg_h.has_master_agent)
        
        wdog_agent=master_agent::type_id::create("wdog_agent",this);
        uvm_config_db #(master_config)::set(this, "*","master_config",wdog_master_cfg_h);

/*
	begin
	   wdog_agent=master_agent_top::type_id::create("wdog_agent",this);
	   foreach(wtenv_cfg_h.master_cfg[i])
	     begin
		uvm_config_db #(master_config)::set(this,$sformatf("wdog_agent.agent_h[%0d]*",i),"master_config",wtenv_cfg_h.master_cfg[i]);
	   end
	end
*/

	predictor_wdog = uvm_reg_predictor#(master_trans)::type_id::create("predictor_wdog",this);
	//Adapter creation
	adapter_wdog = reg_adapter::type_id::create("adapter_wdog",this);
endfunction:build_phase

//*****************************connect_phase*******************************
function void wtenv ::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //if(env_cfg.has_virtual_sequencer)
  begin
    `uvm_info("WatchDog Timer Environment","....Connect phase....",UVM_MEDIUM)
  end

  // watchdog timer RAL model hookup
  //wtenv_cfg.apb_rb.apb_map.set_sequencer(.sequencer(wdog_agent.master_sequencer),.adapater(adapter_wdog));
  predictor_wdog.map = wtenv_cfg_h.apb_rb.apb_map;
  predictor_wdog.adapter = adapter_wdog;
  wtenv_cfg_h.apb_rb.apb_map.set_auto_predict(0);
  wdog_agent.monitor_h.monport.connect(predictor_wdog.bus_in);
  
endfunction:connect_phase

    uvm_report_server foo;
    int err_cnt;

// Report phase
function void wtenv::report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"watch dog Timer Env report phase entering",UVM_LOW)

    foo = uvm_report_server::get_server();
    err_cnt = foo.get_severity_count(UVM_ERROR);
    if (err_cnt == 0) 	
      begin
	$display("===================----WDOG TIMER:NO UVM ERRORS----==================");
      end else 
      begin
	$display("===================----WDOG TIMER:UVM ERRORS ----===================");
      end
endfunction




