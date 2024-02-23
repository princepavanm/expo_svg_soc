/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	uart sequence class
 Filename:   	uart_sequence.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

class uart_sequence extends uvm_sequence #(uart_xtn);
  `uvm_object_utils(uart_sequence)
  
//*******************************Method***********************************
 extern function new(string name="uart_sequence");
endclass:uart_sequence

//*****************************Constructor******************************** 
function uart_sequence :: new(string name="uart_sequence");
 super.new(name);
endfunction:new  

//************************************************************************
// TEST_SEQUNCES-4:setting register values and write from uart
//************************************************************************ 

class uart_write extends uart_sequence;
    `uvm_object_utils(uart_write)
    
//*******************************Methods*********************************** 
    extern function new(string name="uart_write");
    extern task body();
endclass:uart_write

//*****************************Constructor*********************************     
function uart_write::new (string name="uart_write");
  super.new(name);
endfunction:new


//*******************************uart_write********************************   
task uart_write::body();
  
  // always write an variable before super.new constructor
  
 //super.body();
  req=uart_xtn::type_id::create("uart_xtn");
  begin

  start_item(req);
  assert (req.randomize() with {RXD==1'b0;}); //startbit
  finish_item(req);
  
  repeat(8)
  begin
  start_item(req);
  assert (req.randomize());
  finish_item(req);
  end
  
  start_item(req);
  assert (req.randomize() with {RXD==1'b1;}); //stop bit
  finish_item(req);
  
  end
endtask:body

//**************************************************************************
// TEST_SEQUNCES-6:setting register values and sending multi data from UART
//************************************************************************** 

class uart_multi_write extends uart_sequence;
    `uvm_object_utils(uart_multi_write)
    
//********************************Methods*********************************** 
    extern function new(string name="uart_multi_write");
    extern task body();
endclass:uart_multi_write

//*******************************Constructor********************************   
function uart_multi_write::new (string name="uart_multi_write");
  super.new(name);
endfunction:new

//*********************uart multi writeMethod******************************* 
task uart_multi_write::body();
  
  // alwas write an variable before super.new constructor
 
 super.body();
  req=uart_xtn::type_id::create("uart_xtn");
    repeat(2)  //for multiple sequence
begin
  start_item(req);
  assert (req.randomize() with {RXD==1'b0;}); //startbit
  finish_item(req);
  
  repeat(6)
  begin
  start_item(req);
  assert (req.randomize());
  finish_item(req);
  end
  
  start_item(req);
  assert (req.randomize() with {RXD==1'b1;}); //stop bit
  finish_item(req);

end
endtask:body

//***************************************************************************
// TEST_SEQUNCES-7:setting register values and same time read and write
//***************************************************************************

class uart_write_read extends uart_sequence;
    `uvm_object_utils(uart_write_read)
    
//*******************************Methods*********************************** 
    extern function new(string name="uart_write_read");
    extern task body();
endclass:uart_write_read

//*****************************Constructor*********************************     
function uart_write_read::new (string name="uart_write_read");
  super.new(name);
endfunction:new


//***************************uart_write_read*******************************   
task uart_write_read::body();
  
  // always write an variable before super.new constructor
  
 //super.body();
  req=uart_xtn::type_id::create("uart_xtn");
begin
  

  start_item(req);
  assert (req.randomize() with {RXD==1'b0;}); //startbit
  finish_item(req);
  
  repeat(8)
  begin
  start_item(req);
  assert (req.randomize());
  finish_item(req);
  end
  
  start_item(req);
  assert (req.randomize() with {RXD==1'b1;}); //stop bit
  finish_item(req);



  end
endtask:body

//*******************************************************************************
// TEST_SEQUNCES-8:setting register values and same time read and write(over RX)
//*******************************************************************************

class uart_rx_over extends uart_sequence;
    `uvm_object_utils(uart_rx_over)
    
//**********************************Methods************************************* 
    extern function new(string name="uart_rx_over");
    extern task body();
endclass:uart_rx_over

//********************************Constructor***********************************     
function uart_rx_over::new (string name="uart_rx_over");
  super.new(name);
endfunction:new


//*********************************uart_rx_over*********************************   
task uart_rx_over::body();
  
  // always write an variable before super.new constructor
  
 //super.body();
  req=uart_xtn::type_id::create("uart_xtn");
begin
  repeat(2)
  begin
    
    start_item(req);
    assert (req.randomize() with {RXD==1'b0;}); //startbit
    finish_item(req);
  for(int j=0;j<8;j++)
   begin
  start_item(req);
  assert (req.randomize());
  finish_item(req);
  end
 
  start_item(req);
  assert (req.randomize() with {RXD==1'b1;}); //stop bit
  finish_item(req);
  
  end
end
endtask:body
