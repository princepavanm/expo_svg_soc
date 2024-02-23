class apb_monitor extends uvm_monitor;
   `uvm_component_utils(apb_monitor)
 
  apb_agent_config apb_agent_cfg;
  
  uvm_analysis_port#(apb_txn) monitor_port;
  apb_txn data_send;
  
  virtual apb_timer_if.APB_MONITOR vif;
 
  apb_txn apb_cov_txn;
  
  
  covergroup apb_cov();

//coverage for reset signal

    PRESETn:coverpoint apb_cov_txn.presetn
      { 
        bins Reset_high={1};
        bins Reset_low={0};
      }
// coverage for slave select signal
  
    APB_SLEX:coverpoint apb_cov_txn.psel
      {
        bins slave_select={1};
        bins slave_unselect={0};
      }
// coverage for address
  
    APB_ADDR:coverpoint apb_cov_txn.paddr
      {
       bins pid4={`PID4}; 
       bins pid5={`PID5};
       bins pid6={`PID6};
       bins pid7={`PID7};
       bins pid0={`PID0};
       bins pid1={`PID1};
       bins pid2={`PID2};
       bins pid3={`PID3};
       bins cid0={`CID0};
       bins cid1={`CID1};
       bins cid2={`CID2};
       bins cid3={`CID3};
       
       bins value_addr={`VALUE_ADDR};
       bins ctrl_addr={`CTRL_ADDR};
       bins reload_addr={`RELOAD_ADDR};
       bins int_status={`INTSTATUS_ADDR};
       
       bins value_reset={`RESET_1};
       bins reload_reset={`RESET_2};
       bins int_status_reset={`RESET_3};
       bins ctrl_reset ={`RESET_4};
      }  
 // coverage for tranfser of read and write 
    
    APB_PWRITE:coverpoint apb_cov_txn.pwrite
      {
              bins read={0};
	      bins write={1};
      }
 // coverage for penable 
 
    APB_PENABLE: coverpoint apb_cov_txn.penable
      {
        bins enable_high={1};
        bins enable_low={0};
      } 
//coverage for write data

    APB_PWDATA: coverpoint apb_cov_txn.pwdata
      {
        bins Write_data={[100:0]};
      } 
    APB_PRDATA:coverpoint apb_cov_txn.prdata
     {
        bins read_data={[100:0]};
    }
  endgroup
  
  extern function new(string name="apb_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_txn();  
endclass:apb_monitor
//=========================================================================================
// constructor
//=========================================================================================

function apb_monitor::new(string name="apb_monitor",uvm_component parent);
  //apb_cov apb_cov_inst;
  super.new(name,parent);
  apb_cov=new();
endfunction
//=========================================================================================
// build_phase
//=========================================================================================
    
  function void apb_monitor::build_phase(uvm_phase phase);
    if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",apb_agent_cfg))
    `uvm_fatal("APB_monitor","agent_cfg unsuccessful")
       super.build_phase(phase);
       monitor_port=new("monitor_port",this);
     endfunction
//=========================================================================================
// connect_phase
//=========================================================================================
function void apb_monitor::connect_phase(uvm_phase phase);
  vif=apb_agent_cfg.vif;
endfunction
//=========================================================================================
// run_phase
//=========================================================================================  
      
  task apb_monitor::run_phase(uvm_phase phase);
   @(vif.apb_monitor_cb);
   @(vif.apb_monitor_cb);
   @(vif.apb_monitor_cb);
   
   forever
   
    begin
      //$display($time,"MONITOR FOREVER LOOP");
   @(vif.apb_monitor_cb);
    collect_txn();
    apb_cov_txn=data_send;
    apb_cov.sample();
  end
  endtask 
//=========================================================================================
// collect_txn task 
//=========================================================================================  


task apb_monitor::collect_txn();
 
  data_send=apb_txn::type_id::create("data_send",this);
    begin 
      if((vif.apb_monitor_cb.pwrite==1'b1) && (vif.apb_monitor_cb.psel==1)  && (vif.apb_monitor_cb.presetn==1) && (vif.apb_monitor_cb.penable==1))
       begin 
         data_send.psel=vif.apb_monitor_cb.psel;
         data_send.pwrite=vif.apb_monitor_cb.pwrite;
         data_send.paddr=vif.apb_monitor_cb.paddr;
         data_send.presetn=vif.apb_monitor_cb.presetn;
         data_send.penable=vif.apb_monitor_cb.penable;
         data_send.pwdata=vif.apb_monitor_cb.pwdata;
         temp_pwdata=data_send.pwdata;
         monitor_port.write(data_send);
         `uvm_info("APB_TIMER_MONITOR_W",$sformatf("printing from monitor \n %s",data_send.sprint()),UVM_LOW)        
       end   	
      else if((vif.apb_monitor_cb.pwrite==1'b0) && (vif.apb_monitor_cb.psel==1)  && (vif.apb_monitor_cb.presetn==1) && (vif.apb_monitor_cb.penable==1))
 
	begin 
         data_send.psel=vif.apb_monitor_cb.psel;
         data_send.presetn=vif.apb_monitor_cb.presetn;
         data_send.pwrite=vif.apb_monitor_cb.pwrite;
         data_send.paddr=vif.apb_monitor_cb.paddr;
         data_send.penable=vif.apb_monitor_cb.penable;
         data_send.prdata=vif.apb_monitor_cb.prdata;
         temp_prdata = data_send.prdata;
         monitor_port.write(data_send);
         `uvm_info("APB_TIMER_MONITOR_R",$sformatf("printing from monitor \n %s",data_send.sprint()),UVM_LOW)        
        end   
   end
 
endtask

