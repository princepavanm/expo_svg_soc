// base test...
///----------------------------
`ifdef ADD_TIMER
  `include "treg_sequence.sv"
`endif

`ifdef ADD_SRAM0
  `include "sreg_sequence.sv"
`endif 
`ifdef ADD_WDOG_TIMER
  `include "wtreg_sequence.sv"
`endif 
`ifdef ADD_UART
	`include "ureg_sequence.sv"
`endif
class base_test extends uvm_test;
	 `uvm_component_utils(base_test)
	//Declaring handle
	env env_h;
	env_config env_cfg;

`ifdef ADD_WDOG_TIMER
	apb_reg_block wt_reg_block_h;
        wtreg_sequence wtreg_seq;
`endif
 
  
`ifdef ADD_TIMER
        reg_block  t_reg_block_h;
	treg_sequence treg_seq;
`endif

`ifdef ADD_SRAM0
	ahb_reg_block s_reg_block_h;
	sreg_sequence sreg_seq;
`endif
`ifdef ADD_UART
	uart_reg_block u_reg_block_h;
	ureg_sequence ureg_seq;
`endif
	//uvm_domain domain; //declaration of domain for phase jumping

	//uvm_phase schedule;
	//*********************************method*******************************
	extern function new (string name="base_test",uvm_component parent);   
	extern function void build_phase(uvm_phase phase);
	//extern function void start_of_simulation_phase(uvm_phase phase);
	extern function void apb_config();
	//extern function void connect_phase(uvm_phase phase);
	extern task run_phase (uvm_phase phase);
endclass:base_test

//****************************Constructor*******************************
function base_test :: new (string name="base_test",uvm_component parent); 
	 super.new(name,parent);
endfunction:new

//************************bulding component*****************************
function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
	//creating a envirnment config
      env_cfg=env_config::type_id::create("env_cfg");
//creating a testbench
      env_h=env::type_id::create("env_h",this);

`ifdef ADD_WDOG_TIMER
   //Creating the reg model
   wt_reg_block_h = apb_reg_block::type_id::create("wt_reg_block_h");
   wt_reg_block_h.build();
   env_cfg.wt_reg_block_h = wt_reg_block_h;
   if (!uvm_config_db #(virtual wtapb_if)::get(this,"*", "vif_wt",env_cfg.vif_wt))
          `uvm_fatal("In Test: Watchdog Timer Virtual I/F","FATAL")
`endif

`ifdef ADD_TIMER
   t_reg_block_h = reg_block::type_id::create("t_reg_block_h");
   t_reg_block_h.build();
   env_cfg.t_reg_block_h = t_reg_block_h;
        if (!uvm_config_db #(virtual apb_timer_if)::get(this,"*", "vif_t", env_cfg.vif_t))
           `uvm_error("In Test: Timer Virtual I/F","ERROR")
`endif

`ifdef ADD_SRAM0
   s_reg_block_h = ahb_reg_block::type_id::create("s_reg_block_h");
   s_reg_block_h.build();
   env_cfg.s_reg_block_h = s_reg_block_h;
        if (!uvm_config_db #(virtual AHB_SRAM_if)::get(this,"*", "vif_s", env_cfg.vif_s))
           `uvm_error("In Test: SRAM Virtual I/F","ERROR")
`endif

`ifdef ADD_UART
	u_reg_block_h = uart_reg_block::type_id::create("u_reg_block_h");
	u_reg_block_h.build();
	env_cfg.u_reg_block_h=u_reg_block_h;
	if(!uvm_config_db #(virtual APB_UART_if)::get(this, "*","vif_u",env_cfg.vif_u))
		`uvm_error("In Test: UART Virtual Interface","ERROR")
`endif
      //setting the config file
      //uvm_config_db #(env_config)::set(this,"*","vif_wt", env_cfg.vif_wt);
      //uvm_config_db #(env_config)::set(this,"*","vif_t", env_cfg.vif_t);

      uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);

endfunction


function void base_test::apb_config();
          $display ("Test Building in progress \n");
endfunction
//*********************************Run_phase***************************

task base_test::run_phase(uvm_phase phase);
  `uvm_info("TEST"," ======Run phase in base_test started : TIMER, WDOG TIMER SRAM0 and UART RALs enabled ======= ",UVM_MEDIUM)
  phase.raise_objection(this);
  uvm_top.print_topology();

  treg_seq=treg_sequence::type_id::create("treg_seq"); //TIMER RAL SEQUENCE
  wtreg_seq=wtreg_sequence::type_id::create("wtreg_seq"); //WATCHDOG TIMER RAL SEQUENCE
`ifdef ADD_SRAM0
  sreg_seq=sreg_sequence::type_id::create("sreg_seq"); //SRAM RAL SEQUENCE
`endif 
`ifdef ADD_UART
	ureg_seq=ureg_sequence::type_id::create("ureg_seq");// UART RAL SEQUENCE
`endif

  fork 
`ifdef ADD_TIMER
    //treg_seq.start(env_h.tenv_h.timer_agent.apb_dummy_seqr);
`endif

`ifdef ADD_WDOG_TIMER
   // wtreg_seq.start(env_h.wtenv_h.wdog_agent.wdog_dummy_seqr);
`endif

`ifdef ADD_SRAM0
    //sreg_seq.start(env_h.senv_h.magenth.sram_dummy_seqr);
`endif
`ifdef ADD_UART
	ureg_seq.start(env_h.uart_env_h.magent.uart_dummy_sqr);
`endif

  join 
  
  #5023879;
 `uvm_info("TEST"," =======Run phase in base_test finished====== ",UVM_MEDIUM)
  phase.drop_objection(this);
 
endtask


