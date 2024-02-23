//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

interface AHB_SRAM_if(input bit hclk);

bit hresetn,hwrite,hready,hreadyout;
logic [31:0]hwdata,hrdata;
logic [15:0]haddr;
logic hsel;
logic [2:0]hsize;
logic hresp;
logic [1:0]htrans;


//--- MASTER DRIVER ---//

clocking wdr_cb@(posedge hclk);
   default input #1 output #1;
   input hrdata,hresp,hreadyout;
   output hresetn,hsel,htrans,hwrite,hready,hwdata,haddr,hsize;
endclocking

//--- MASTER MONITOR ---//

clocking wmon_cb@(posedge hclk);
   default input #1 output #1;
   input htrans,hwrite,hsel,hready,hwdata,haddr,hclk,hresetn,hrdata,hresp,hsize,hreadyout;
   endclocking

//--- modports ---//
modport MDR_MP(clocking wdr_cb); 
modport MMON_MP(clocking wmon_cb);


//========================================================================================
// Assertions
//========================================================================================
//property for write check
property writevalid;
@(posedge hclk)
(hsel && hready && htrans && hwrite) |=>(hwdata); 
endproperty

//property for read check
//property readvalid;
//@(posedge hclk)
//(hsel && hready && htrans && !hwrite) |=>(hrdata); 
//endproperty

//error response followed by idle trans 
property err_p;
@(posedge hclk) disable iff(!hresetn)
(hresp==1)##1(hresp==1)|=>(hresp==0);
endproperty

//retry response followed by idle trans
property retry_p;
@(posedge hclk) disable iff(!hresetn)
(hresp==2)##1(hresp==2)|=> (htrans==0);
endproperty

//split response followed by idle trans
property split_p;
@(posedge hclk) disable iff(!hresetn)
(hresp==3)##1(hresp==3)|=>(hresp==0);
endproperty

//okay response for idle trans
property idle_okay_p;
@(posedge hclk) disable iff(!hresetn)
(htrans==0) |=> (hresp==0);
endproperty

//1kb boundary check
property kb_boundary_p;
@(posedge hclk) disable iff(!hresetn)
(htrans==3)|->(haddr[10:0]!=11'b1_00000_00000);
endproperty

//HSIZE byte
property size_1_addr_p;
@(posedge hclk) disable iff(!hresetn)
hsize==1 |-> haddr[0]==0;
endproperty

//HSIZE half_word
property size_2_addr_p;
@(posedge hclk) disable iff(!hresetn)
hsize==2 |-> haddr[1:0]==0;
endproperty

//HSIZE word
property size_3_addr_p;
@(posedge hclk) disable iff(!hresetn)
hsize==3 |-> haddr[2:0]==0;
endproperty

//properties for response signals 
ERROR :assert property(err_p);
RETRY :assert property(retry_p);
SPLIT :assert property(split_p);
OKAY  :assert property(idle_okay_p);

//properties for size
BOUNDARY:assert property(kb_boundary_p);
BYTE  :assert property(size_1_addr_p);
HALF_WORD:assert property(size_2_addr_p);
WORD  :assert property(size_3_addr_p);

WRITE_VALID: assert property(writevalid);
//READ_VALID: assert property(readvalid);

endinterface
