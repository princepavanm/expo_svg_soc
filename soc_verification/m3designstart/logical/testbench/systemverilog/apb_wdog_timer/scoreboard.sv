/***********************************************************
Author 		: Ramkumar 
File 		: scoreboard.sv
Module name     : scoreboard 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class scoreboard extends uvm_scoreboard;
	 `uvm_component_utils(scoreboard)

//Declare the TLM_ANALYSIS_FIFO 
uvm_tlm_analysis_fifo#(master_trans) master_fifo[];
uvm_tlm_analysis_fifo#(slave_trans) slave_fifo[];

//Declare handle of config file
wtenv_config sb_cfg;

//Declaring handles of transaction
master_trans master_data;
master_trans master_data_cp;
slave_trans slave_data;
slave_trans slave_data_cp;

//Declaring event pool
uvm_event_pool pool;
//Declaring event from event class
uvm_event event_sb;
//To skip the comparison in test case 3
int x=1;
//************************methods and functions***********************
extern function new (string name="scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
//extern function void check_phase(uvm_phase phase);
extern task check_default(master_trans sb_xtn);
endclass:scoreboard


//*******************************Constructor*******************************
function scoreboard :: new (string name="scoreboard",uvm_component parent);
	 super.new(name,parent);
 //create a new pool with given name
 pool=new();
 pool=pool.get_global_pool();
 event_sb=pool.get("lock");

endfunction:new

//*******************************Build_phase*******************************
function void scoreboard ::build_phase(uvm_phase phase);
	 super.build_phase(phase);
//Get config_db
if(!uvm_config_db #(wtenv_config)::get(this,"","wtenv_config",sb_cfg))
	`uvm_fatal("SLAVE DRIVER","Unable to get slave config in driver")
if(sb_cfg.has_master_agent)
begin
	master_fifo=new[sb_cfg.has_master_agent];
	foreach(master_fifo[i])
		master_fifo[i]=new($sformatf("master_fifo[%0d]",i),this);
end
if(sb_cfg.has_slave_agent)
begin
	slave_fifo=new[sb_cfg.has_slave_agent];
	foreach(slave_fifo[i])
		slave_fifo[i]=new($sformatf("slave_fifo[%0d]",i),this);

end
master_data=master_trans::type_id::create("master_data");
slave_data=slave_trans::type_id::create("master_data");
endfunction:build_phase

//*******************************Run_phase*********************************
task scoreboard ::run_phase(uvm_phase phase);
fork
	forever
	begin
		master_fifo[0].get(master_data);
		master_data_cp=new master_data;
		if(!master_data.intp && event_sb.is_off)
		begin
		check_default(master_data_cp);
		x=0;
		end
	end
	forever
	begin
		slave_fifo[0].get(slave_data);
		slave_data_cp=new slave_data;
	end

join
endtask:run_phase

task scoreboard::check_default(master_trans sb_xtn);
if(sb_xtn.pwdata==sb_xtn.prdata)
`uvm_info("SCOREBOARD","=============Comparison Successfull=============",UVM_LOW)
else
`uvm_info("SCOREBOARD","=============Comparison Failed=============",UVM_LOW)
endtask
/*
//=*******************************Check_phase*******************************
	function void scoreboard :: check_phase(uvm_phase phase);
if(master_data_cp.intp && slave_data_cp!=null && x)
// check respective data
begin
	
	if(master_data_cp.intp==slave_data_cp.wdogint)
	`uvm_info("SCOREBOARD","=============Interrupt Comparison Successfull=============",UVM_LOW)
	else
	`uvm_info("SCOREBOARD","=============Interrupt Comparison Failed=============",UVM_LOW)
	
end
endfunction:check_phase*/
