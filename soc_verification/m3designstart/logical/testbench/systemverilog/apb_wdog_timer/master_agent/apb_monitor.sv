/***********************************************************
Author 		: Ramkumar 
File 		: master_monitor.sv
Module name     : master_monitor 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class master_monitor extends uvm_monitor;
	 `uvm_component_utils(master_monitor)

//Declare the handles
virtual wtapb_if.APB_MONITOR vif;
master_config monitor_cfg;
master_trans mon_xtn;
master_trans cov_data;

//Implementing a internal counter
static logic [31:0] count;

//Declaring analysis port
uvm_analysis_port #(master_trans) monport;

//Declaring covergroup for write transaction
covergroup cg_apb;
	option.per_instance=1;
addr: coverpoint cov_data.paddr {
				bins low = {[0:500]};
				bins high = {[501:1024]};
				}
data: coverpoint cov_data.pwdata {
				bins low = {[0:5000000]};
				bins high = {[5000000:42949673]};
				}
write: coverpoint cov_data.pwrite {
				bins low = {0};
				bins high = {1};
				}

endgroup


//************************methods and functions***********************
extern function new (string name="master_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task counter(master_trans ctr_xtn);
endclass:master_monitor

//*******************************Constructor*******************************
function master_monitor::new (string name="master_monitor",uvm_component parent);
	 super.new(name,parent);
	 cg_apb=new();
endfunction:new

//*******************************Build_phase*******************************
function void master_monitor ::build_phase(uvm_phase phase);
	 super.build_phase(phase);

//Get config_db
if(!uvm_config_db #(master_config)::get(this,"*","master_config",monitor_cfg))
	`uvm_fatal("MASTER MONITOR","Unable to get master config in driver")
monport=new("monport",this);
mon_xtn=master_trans::type_id::create("mon_xtn");
endfunction:build_phase

//*******************************Connect_phase*********************************
function void master_monitor::connect_phase(uvm_phase phase);
   `uvm_info("MASTER MONITOR","....Connect phase.....",UVM_MEDIUM)
   vif=monitor_cfg.vif;
endfunction

//*******************************Run_phase*********************************
task master_monitor ::run_phase(uvm_phase phase);

forever
 begin
 
   @(vif.apb_monitor_cb);
    
     if ((vif.apb_monitor_cb.psel==1)  && (vif.apb_monitor_cb.presetn==1) && vif.apb_monitor_cb.penable==1) begin
           mon_xtn.presetn=vif.apb_monitor_cb.presetn;
           mon_xtn.paddr[11:2]=vif.apb_monitor_cb.paddr[11:2];
          
    	   mon_xtn.pwrite=vif.apb_monitor_cb.pwrite;
           mon_xtn.psel=vif.apb_monitor_cb.psel;
           mon_xtn.penable=vif.apb_monitor_cb.penable;
    	   mon_xtn.pwdata=vif.apb_monitor_cb.pwdata;
	   mon_xtn.prdata=vif.apb_monitor_cb.prdata;
	   monport.write(mon_xtn);
         //  `uvm_info("MASTER MONITOR",$sformatf("\nPrinting From Master Monitor",mon_xtn.sprint()),UVM_LOW)
          `uvm_info("MASTER MONITOR",$sformatf(mon_xtn.sprint()),UVM_LOW)
	   cov_data=mon_xtn;
	   cg_apb.sample();
     end
  end
endtask:run_phase

//*******************************Down Counting*********************************
task master_monitor::counter(master_trans ctr_xtn);
if(ctr_xtn.paddr== 24'h0)
begin

count=ctr_xtn.pwdata;
		@(vif.apb_monitor_cb);

	repeat(ctr_xtn.pwdata)
		begin
		@(vif.apb_monitor_cb);
		count=count-1'b1;
		$display("======*************=======count=%0d",count);
		//import_task(count);
		end
if(count==0)
mon_xtn.intp=1'b1;
end
endtask


