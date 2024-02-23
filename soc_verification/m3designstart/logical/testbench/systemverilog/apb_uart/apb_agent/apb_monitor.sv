/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	apb monitor class
 Filename:   	apb_monitor.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
// virtual interface and agent congiguration handel  
  virtual APB_UART_if.MON_MP vif;
  apb_agent_config m_cfg;

// TLM anlysis port  declaration
  uvm_analysis_port #(apb_xtn) apb_monitor_port;

// transcation handle	
  apb_xtn data_sent;
  apb_xtn xtn;

//*******************Function coverage********************  
  
covergroup apb_cover; 

		// coverage for select signals
	sel:coverpoint xtn.sel
		{
			bins sel={0,1};
		}
	
	// coverage for select signals
	enable:coverpoint xtn.enable
		{
			bins enable={0,1};
		}
	//coverage for adress
	addr:coverpoint xtn.addr
	{
		bins addr_baud={10'h4};
		bins addr_control={10'h2};
		bins addr_data={10'h0};
	}
	//coverage for trans_type
	trans_type:coverpoint xtn.trans_type
	{
		bins write={0,1}; 
	}
	
  	//coverage for wdata
	wdata:coverpoint xtn.wdata
	{
		bins control={[0:7'h1A]};
		bins buad={[0:16'h5E]};
		bins data={[0:10]};
	}	
	//coverage for rdata
	rdata:coverpoint xtn.rdata
	{
		bins control={[0:7'h1A]};
		bins buad={[0:16'h5E]};
		bins data={[0:10]};
	}

endgroup

  
//*******************************Methods***********************************  
extern function new(string name="apb_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass:apb_monitor


//******************************Constructor********************************
function apb_monitor::new(string name="apb_monitor", uvm_component parent);
  super.new(name,parent);
  apb_monitor_port= new("apb_monitor_port",this);
  apb_cover = new();
endfunction:new

//****************************Build_phase**********************************
function void apb_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",m_cfg))
    `uvm_fatal("MONITOR VIF0","get interface to monitor")
  endfunction:build_phase

//****************************Connect_phase********************************
  function void apb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=m_cfg.vif;
  endfunction:connect_phase
  
//******************************Run_phase**********************************  
  task apb_monitor::run_phase(uvm_phase phase);	
		forever
		  begin
		    collect_data();
		    xtn=data_sent; //get value form datasent, monitored data will be stored in data sent from that we are checking data
        apb_cover.sample();
		  end
  endtask:run_phase

//*******************************Data collect Method*********************************
task apb_monitor::collect_data();
  data_sent=apb_xtn::type_id::create("data_sent",this);
    begin
        @(posedge vif.mon_cb.enable)
          if(vif.mon_cb.trans_type==1)
             begin
                data_sent.sel    =   vif.mon_cb.sel;
                data_sent.enable =   vif.mon_cb.enable;
                data_sent.trans_type  =   vif.mon_cb.trans_type;
                data_sent.addr   =   vif.mon_cb.addr;
                data_sent.wdata  =   vif.mon_cb.wdata;
                data_sent.temp    =   data_sent.wdata;
                $display($time,"wdata=%h",data_sent.temp);
            end
    else
            begin
                data_sent.sel    =   vif.mon_cb.sel;
                data_sent.enable =   vif.mon_cb.enable;
                data_sent.trans_type  =   vif.mon_cb.trans_type;
                data_sent.addr   =   vif.mon_cb.addr;
                data_sent.rdata  =   vif.mon_cb.rdata;        
                $display($time,"rdata=%h",data_sent.rdata);  
            end

    end
//*************************Send collected value analysis port*******************************
apb_monitor_port.write(data_sent);
   
 $display("==============APB_MONITOR===============");
  `uvm_info("APB_MONITOR",$sformatf("data received to monitor =%s",data_sent.sprint()),UVM_LOW)

endtask:collect_data
