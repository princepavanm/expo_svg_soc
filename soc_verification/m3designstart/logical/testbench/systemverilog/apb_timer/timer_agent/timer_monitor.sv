 ////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     timer_monitor
 //Filename:   timer_monitor.sv
 //Start Date: 24/10/2017
 /////////////////////////////////////////////////////////////
 
class timer_monitor extends uvm_monitor;
   `uvm_component_utils(timer_monitor)
   env_config env_cfg;
  timer_agent_config timer_agent_cfg;
  
  uvm_analysis_port#(timer_txn) monitor_port;
  
  virtual apb_timer_if.TIMER_MONITOR vif;
  
  
  timer_txn timer_cov_txn;
  timer_txn data_send;
  
  covergroup timer_cov();
  
  //COVERAGE for external input 
     Timer_EXTIN:coverpoint timer_cov_txn.extin

     {
        bins external_high={1};
        bins external_low={0};
     }
  //coverage for TImer interrupt
          
     Timer_INTSTATUS:coverpoint timer_cov_txn.Timerint

     {
        bins interrupt_low={0};
        bins interrupt_high={1};
     }
     
   endgroup
  
  extern function new(string name="timer_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_txn();  
endclass:timer_monitor

//=========================================================================================
// constructor
//=========================================================================================

function timer_monitor::new(string name="timer_monitor",uvm_component parent);
  super.new(name,parent);
  timer_cov=new();
endfunction

//=========================================================================================
// build_phase
//=========================================================================================
    
  function void timer_monitor::build_phase(uvm_phase phase);
    if(!uvm_config_db #(env_config)::get(this,get_full_name(),"env_config",env_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db, Have to set() it")

    if(!uvm_config_db#(timer_agent_config)::get(this,"","timer_agent_config",timer_agent_cfg))
    `uvm_fatal("TIMER_monitor","agent_cfg unsuccessful")
       super.build_phase(phase);
       monitor_port=new("monitor_port",this);
     endfunction
//=========================================================================================
// connect_phase
//=========================================================================================
function void timer_monitor::connect_phase(uvm_phase phase);
  vif=timer_agent_cfg.vif;
endfunction
//=========================================================================================
// run_phase
//=========================================================================================  
      
  task timer_monitor::run_phase(uvm_phase phase);
       begin
       collect_txn();
       timer_cov_txn=data_send;
       timer_cov.sample();
     end
  endtask 
 //=========================================================================================
// collect_txn task 
//=========================================================================================  


task timer_monitor::collect_txn();

  
  data_send=timer_txn::type_id::create("data_send");

begin

  @(vif.timer_monitor_cb);
  @(vif.timer_monitor_cb);
   data_send.extin = vif.timer_monitor_cb.extin;
  @(vif.timer_monitor_cb);

   `uvm_info("TIMER_MONITOR",$sformatf("TIMER MONITOR BEFORE READ OF INT_TEMP \n %s",env_cfg.INT_TEMP),UVM_LOW)

   wait(vif.timer_monitor_cb.Timerint==1)

   data_send.extin = vif.timer_monitor_cb.extin;
   data_send.Timerint = vif.timer_monitor_cb.Timerint;
   env_cfg.INT_TEMP = data_send.Timerint;

  `uvm_info("TIMER_MONITOR",$sformatf(" TIMER_MONITOR AFTER READING TIMER_INT \n %s",data_send.sprint()),UVM_HIGH)
end   
  
      @(vif.timer_monitor_cb);
  endtask

