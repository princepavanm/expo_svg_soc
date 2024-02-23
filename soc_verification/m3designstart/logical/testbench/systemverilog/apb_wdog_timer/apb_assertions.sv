module apb_assertions(input clk,resetn,enable,sel,addr,write,wdata,dogclk,dogclken,dogresn,ecr,rdata,dogint,dogres);

wire clk,resetn,enable,sel,dogclk,dogclken,dogresn,ecr,dogint,dogres,write;
wire [11:2]addr;
wire [31:0]wdata,rdata;

//property 1
property sel_enb;
@(posedge clk) disable iff(!resetn || $isunknown(addr)) ($rose(sel) |=> (sel && enable));
endproperty

SELECT:assert property(sel_enb);

//property2
property read;
@(posedge clk) disable iff(!resetn) (enable && !write) |-> (!$isunknown(rdata));
endproperty

READ:assert property(read);

//property 2
property write_prop;
@(posedge clk) disable iff(!resetn) (enable && write) |-> (!$isunknown(write));
endproperty

WRITE:assert property(write_prop);

//property 3
property ctrl_sel_prop;
@(posedge clk) disable iff(!resetn || !sel) 
(!$isunknown(addr) && !write && sel) |=> sel;
endproperty

CNTRL_SEL:assert property(ctrl_sel_prop);



endmodule
                             
                            
                          
                           
                                    
                          
                                    
                             
                                    
                            
                           
