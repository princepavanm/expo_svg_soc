class env_parent extends uvm_env; 
    function new(string name = "env_parent",uvm_component parent);
	super.new(name,parent);
    endfunction
endclass

class env extends env_parent;
    `uvm_component_utils(env)
    env_config env_config_h;

`ifdef ADD_WDOG_TIMER
    wtenv_config wtenv_config_h;
    wtenv wtenv_h;
`endif
`ifdef ADD_TIMER
    tenv_config tenv_config_h;
    tenv  tenv_h;
`endif
`ifdef ADD_SRAM0
    senv_config senv_config_h;
    senv  senv_h;
`endif
`ifdef ADD_UART
	uart_env_config uart_env_cfg_h;
	uart_env uart_env_h;
`endif
	


	//************************methods and functions***********************
	extern function new (string name="env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	//extern function void report_phase(uvm_phase phase);
	//extern function void final_phase(uvm_phase phase);
endclass:env

//*******************************Constructor*******************************
function env :: new (string name="env",uvm_component parent);
	 super.new(name,parent);
endfunction:new

//*******************************Build_phase*******************************
function void env ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

    if (!uvm_config_db #(env_config)::get(this,"*","env_config",env_config_h))
      `uvm_fatal("Env Config","Unable to get env config in env")

`ifdef ADD_WDOG_TIMER
    wtenv_h=wtenv::type_id::create("wtenv_h",this);
    wtenv_config_h=wtenv_config::type_id::create("wtenv_config_h");
    wtenv_config_h.vif = env_config_h.vif_wt;
    wtenv_config_h.apb_rb = env_config_h.wt_reg_block_h;
    uvm_config_db #(wtenv_config)::set(this,"*","wtenv_config",wtenv_config_h); 
`endif 

`ifdef ADD_TIMER
    tenv_h=tenv::type_id::create("tenv_h",this);
    tenv_config_h=tenv_config::type_id::create("tenv_config_h");
    tenv_config_h.vif = env_config_h.vif_t;
    tenv_config_h.blk = env_config_h.t_reg_block_h;
    uvm_config_db #(tenv_config)::set(this,"*","tenv_config",tenv_config_h);
`endif

`ifdef ADD_SRAM0
    senv_h=senv::type_id::create("senv_h",this);
    senv_config_h=senv_config::type_id::create("senv_config_h");
    senv_config_h.vif0 = env_config_h.vif_s;
    senv_config_h.blk = env_config_h.s_reg_block_h;
    uvm_config_db #(senv_config)::set(this,"*","senv_config",senv_config_h);
`endif

`ifdef ADD_UART
	uart_env_h = uart_env::type_id::create("uart_env",this);
	uart_env_cfg_h = uart_env_config::type_id::create("uart_env_cfg_h",this);
	uart_env_cfg_h.vif=env_config_h.vif_u;
	uart_env_cfg_h.apb_rb=env_config_h.u_reg_block_h;
	uvm_config_db #(uart_env_config)::set(this,"*","uart_env_config",uart_env_cfg_h);
`endif
endfunction:build_phase

//*****************************connect_phase*******************************
function void env ::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //if(env_cfg.has_virtual_sequencer)apb_reg_block
  begin
    `uvm_info("Top Env Testbench", "...Connect phase...", UVM_MEDIUM)
  end

endfunction:connect_phase




