/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart monitor class
 Filename:   	uart_monitor.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)
 

//Interface Handles 
    virtual intf_UART.SMON_MP vif1;
  
// environment and agent configuration handles
    uart_agent_config s_cfg;
    env_config env_cfg;
  
//Analysis port to send collected values to scoreboard
    uvm_analysis_port #(uart_xtn) uart_monitor_port;

//transcation handle
    uart_xtn  uart_data;

// temporary variables for storing intermediate value	
 
//To store Intermediate values of TX
  reg [9:0]temp1; 

//To store intermediate values of RX
  reg [9:0]temp2; 
  reg [9:0]data;
  
// Transaction class handle for functional coverage
  uart_xtn xtn;


//*******************Function coverage********************  
covergroup uart_cover; 

  	// coverage for RXD signals
	RXD:coverpoint xtn.RXD
		{
			bins RXD={0,1};
		}

	// coverage for TXD signals
	TXD:coverpoint xtn.TXD
		{
			bins TXD={0,1};
		}
  
  	// coverage for TXEN signals
  	TXEN:coverpoint xtn.TXEN
		{
			bins TXEN={0,1};
		}	
	
	
	// coverage for BAUDTICK signals
	BAUDTICK:coverpoint xtn.BAUDTICK
		{
			bins BAUDTICK_low={0,1};
		}
	
	//coverage for RXINT
	RXINT:coverpoint xtn.RXINT
		{
			bins RXINT={0,1};
		}
		
	//coverage for TXINT
	TXINT:coverpoint xtn.TXINT
		{
			bins TXINT={0,1};
		}
	
	//coverage for UARTINT
	UARTINT:coverpoint xtn.UARTINT
		{
			bins UARTINT={0,1};
		}


	//coverage for TXOVRINT
	TXOVRINT:coverpoint xtn.TXOVRINT
		{
			bins TXOVRINT={0,1};
		}
		
	//coverage for UARTINT
	RXOVRINT:coverpoint xtn.RXOVRINT
		{
			bins RXOVRINT={0,1};
		}

endgroup

//*******************************Methods*******************************

extern function new(string name="uart_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass:uart_monitor

//*******************************Constrctor******************************
function uart_monitor::new(string name="uart_monitor", uvm_component parent);
  super.new(name,parent);
   uart_monitor_port= new("uart_monitor_port",this);
   uart_cover = new();
  // uartint=new("uartint");
endfunction:new


//**********************************Build_phase**********************************
function void uart_monitor::build_phase(uvm_phase phase);
 //inorder to pass control from monitor to environment 
  if(!uvm_config_db #(env_config)::get(this," ","env_config",env_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it")
  
  //Interface conection for uart agent
  if(!uvm_config_db#(uart_agent_config)::get(this,"*","uart_agent_config",s_cfg))
    `uvm_fatal("MONITOR VIF0","get interface to uart_monitor")
    
super.build_phase(phase);
endfunction:build_phase


//*****************************connect_phase****************************  
function void uart_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif1=s_cfg.vif1;
endfunction:connect_phase
  
task uart_monitor::run_phase(uvm_phase phase);	
	forever
	begin
		collect_data();
		xtn=uart_data;
		uart_cover.sample(); 
	end
endtask:run_phase


//*****************************collect_data method****************************
task uart_monitor::collect_data(); 
  uart_data=uart_xtn::type_id::create("uart_data",this);
begin
  
@(posedge vif1.smon_cb.BAUDTICK)
if((vif1.smon_cb.TXINT==1)&&(vif1.smon_cb.TXEN==1))  
begin
  
            for(int j=0;j<10;j++)
                begin 
                  for(int i=0;i<16;i++)
                      begin
                          @(posedge vif1.smon_cb.BAUDTICK)
                          $display($time,"BUADTICK");
                       end
                          temp1[j]=vif1.smon_cb.TXD;
                          $display("temp1=%b",temp1);
                        if(j==9)
                            begin
                              uart_data.wdata1=temp1[8:1];
                              $display("wdata=%h",uart_data.wdata1);
  	                         end
                end
end

else 
   
begin
    
            for(int k=0;k<10;k++)
                begin 
                  for(int f=0;f<16;f++)
                      begin
                        temp2[k]=vif1.smon_cb.RXD;
                        @(posedge vif1.smon_cb.BAUDTICK)
                        $display("temp2=%b",temp2[k]);
                        data[k]=temp2[k];
                        $display("temp2=%b",temp2);
                        $display("data=%b",data);
                        uart_data.rdata1=data[8:1];
                        $display("rdata1=%h",uart_data.rdata1);
                      end
      
                end
end
  
begin

if(env_cfg.TX_test_flag==1 ||env_cfg.Multi_Tx_test_flag==1 )
	begin
		wait(vif1.smon_cb.TXINT==1)
  			begin
			uart_data.INT=vif1.smon_cb.TXINT;
			env_cfg.interrupt=uart_data.INT;
			end
	end


else if(env_cfg.RX_test_flag==1 || env_cfg.Multi_Rx_test_flag==1 )
	begin
		wait(vif1.smon_cb.RXINT==1)
  			begin
			uart_data.INT=vif1.smon_cb.RXINT;
			env_cfg.interrupt=uart_data.INT;
			end
	end

else if(env_cfg.Tx_Rx_test_flag==1 )
	begin
		wait(vif1.smon_cb.UARTINT==1)
  			begin
			uart_data.INT=vif1.smon_cb.UARTINT;
			env_cfg.interrupt=uart_data.INT;
			end
	end

else if(env_cfg.Over_Rx_test_flag==1)
	begin
		wait(vif1.smon_cb.RXOVRINT==1)
  			begin
			uart_data.INT=vif1.smon_cb.RXOVRINT;
			env_cfg.interrupt=uart_data.INT;
			end
	end



end
end
uart_monitor_port.write(uart_data); //send data to scoareboard from monitor through analysis port

endtask:collect_data
