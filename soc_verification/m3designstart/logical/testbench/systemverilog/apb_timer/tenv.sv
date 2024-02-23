// Timer env
class tenv extends uvm_env;
	 `uvm_component_utils(tenv)

  /********Timer related components ***********/
   apb_agent_config timer_apb_cfg_h;
   tenv_config tenv_cfg_h;
   apb_agent timer_agent; 
   apb_adapter  adapter_timer;
   uvm_reg_predictor#(apb_txn) predictor_timer;
   //reg_block timer_reg_blk;

   //env_config env_cfg;

  //************************methods and functions***********************
  extern function new (string name="tenv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
endclass:tenv

//*******************************Constructor*******************************
function tenv :: new (string name="tenv",uvm_component parent);
   super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void tenv ::build_phase(uvm_phase phase);
   super.build_phase(phase);

  //Timer apb_agent creation
  //Get config_db
  if(!uvm_config_db #(tenv_config)::get(this,"","tenv_config",tenv_cfg_h))
 	`uvm_fatal("Timer Env","Unable to get tenv config in t env")
     timer_apb_cfg_h = apb_agent_config ::type_id::create("timer_apb_cfg_h");
     timer_apb_cfg_h.vif = tenv_cfg_h.vif;
     timer_apb_cfg_h.is_active=UVM_PASSIVE;

  //if(env_cfg.has_apb_agent)
    //begin
      timer_agent=apb_agent::type_id::create("timer_agent",this);
      uvm_config_db#(apb_agent_config)::set(this,"*","apb_agent_config", timer_apb_cfg_h);
      /*uvm_component <cntxt>,<string inst_name>,<string field_name>,<type> value*/
    //end
   //RAL Components
      predictor_timer = uvm_reg_predictor#(apb_txn)::type_id::create("predictor_timer",this);
      adapter_timer = apb_adapter::type_id::create("adapter_timer");

endfunction:build_phase

//*****************************connect_phase*******************************
function void tenv ::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //if(env_cfg.has_virtual_sequencer)
  begin
    `uvm_info("Timer Env ","....Connect phase....",UVM_MEDIUM)
  end

  //Timer RAL Connections
 // if (tenv_cfg_h.blk.get_parent == null) begin
    
  //end
  predictor_timer.map = tenv_cfg_h.blk.apb_map;
  predictor_timer.adapter = adapter_timer;
  tenv_cfg_h.blk.apb_map.set_auto_predict(1);
  timer_agent.apb_mon.monitor_port.connect(predictor_timer.bus_in);
endfunction:connect_phase

uvm_report_server foo;
int err_cnt;
// Report phase
function void tenv::report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"Timer Env report phase entering",UVM_LOW)

    foo = uvm_report_server::get_server();
    err_cnt = foo.get_severity_count(UVM_ERROR);
    if (err_cnt == 0) 	
      begin
	$display("===================----TIMER ENV:NO UVM ERRORS----==================");
      end else 
      begin
	$display("===================----TIMER ENV:UVM ERRORS ----===================");
      end
endfunction




