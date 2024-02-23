 ////////////////////////////////////////////////////////////
 //Author:     ABHISHEK EEMANI
 //Module:     apb_diver
 //Filename:   apb_driver.sv
 //Start Date: 24/10/2017
 /////////////////////////////////////////////////////////////

class apb_driver extends uvm_driver#(apb_txn);
  `uvm_component_utils(apb_driver)
  
  ////virtual interface 
 
  virtual apb_timer_if.APB_DRIVER vif;
  
  apb_agent_config apb_agent_cfg;
  
  //uvm_analysis_port#(apb_txn) driver_port;
  
  extern function new(string name="apb_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase); 
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(apb_txn txn);
  
endclass:apb_driver

//========================================================================================
// construction of apb_driver
//========================================================================================    

 function apb_driver::new(string name="apb_driver",uvm_component parent);
      super.new(name,parent);
 endfunction 
    
//========================================================================================
// build phase of driver
//========================================================================================    
function void apb_driver::build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",apb_agent_cfg))
        `uvm_fatal("APB_DRIVER","apb_agent_config getting unsuccesful");
        
        //driver_port=new("driver_port",this);
    endfunction 
//========================================================================================
// connect_phase(connecting the agent 'VIF' wit driver 'VIF')
//========================================================================================    
  function void apb_driver ::connect_phase(uvm_phase phase);
    vif=apb_agent_cfg.vif; 
  endfunction
//======================================================================================
//run_phase
//======================================================================================

  task apb_driver::run_phase(uvm_phase phase);
 @(vif.apb_driver_cb);
    vif.apb_driver_cb.presetn<=1'b0;
 @(vif.apb_driver_cb);
    vif.apb_driver_cb.presetn<=1'b1;
    forever
    //repeat(20)
      begin
        
        //$display($time,"DRIVER FOREVER LOOP");
         @(vif.apb_driver_cb);
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        seq_item_port.item_done();
      end
 endtask 

//======================================================================================
//send_to_dut_task 
//===================================================================================
task apb_driver::send_to_dut(apb_txn txn);
//$display("=========================APB_DRIVER===============================");
 //`uvm_info("APB_DRIVER",$sformatf("printing from driver \n %s",req.sprint()),UVM_LOW)


begin 

 //$display("=========================APB_DRIVER_WRITE===============================");
if(txn.pwrite == 1) begin
//  vif.apb_driver_cb.presetn<= txn.presetn;
  vif.apb_driver_cb.psel   <= txn.psel;
  vif.apb_driver_cb.pwrite <= txn.pwrite;//RHS side (txn.psel,txn.paddr....) are taking 1ns delay to assign to interface because 
  vif.apb_driver_cb.paddr  <= txn.paddr;// in interface we are giving (default input #1) that means assign txn.psel pin  
  vif.apb_driver_cb.penable<= ~txn.penable;//after 1ns and it is vice versa for the LHS
  vif.apb_driver_cb.pwdata <= txn.pwdata;
  //after one clock cycle delay penable asserted..  
 @(vif.apb_driver_cb);
   vif.apb_driver_cb.penable <=txn.penable;
  
 @(vif.apb_driver_cb); 
   vif.apb_driver_cb.penable<=~txn.penable;
   vif.apb_driver_cb.psel   <= ~txn.psel;  
  end
     
//////////////////////////// read operation///////////////////////////////////////

else begin 

  //$display("=========================APB_DRIVER_READ===============================");
  
  vif.apb_driver_cb.psel   <= txn.psel;
  vif.apb_driver_cb.pwrite <= txn.pwrite;
  vif.apb_driver_cb.paddr  <= txn.paddr;
  vif.apb_driver_cb.penable<= ~txn.penable;
  
  @(vif.apb_driver_cb);  
  vif.apb_driver_cb.penable <= txn.penable;
  txn.prdata = vif.apb_driver_cb.prdata;
  
  @(vif.apb_driver_cb);  
   vif.apb_driver_cb.penable <= ~txn.penable;
   vif.apb_driver_cb.psel <= ~txn.psel;   
end  
end
endtask
 
