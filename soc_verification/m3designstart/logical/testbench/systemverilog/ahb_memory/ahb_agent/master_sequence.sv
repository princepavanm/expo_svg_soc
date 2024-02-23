//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~Author      : PAVAN M    
//~~~~Module      : AHB_SRAM_TEST
//~~~~File name   : master_sequence
//~~~~Start Date  : 06/10/2017
//~~~~Finish Date :
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



class master_AHB_sequence extends uvm_sequence#(master_AHB_xtn);
`uvm_object_utils(master_AHB_sequence) // Factory Registration
  ahb_reg_block ahb_reg_block_h;
  env_config env_cfg;         //environment config handle

//***************************Extern functions*********************************************************
extern function new(string name="master_AHB_sequence");
extern task body();

endclass

//*********************************Constractor*********************************************************
function master_AHB_sequence::new(string name="master_AHB_sequence");
  super.new(name);
endfunction

task master_AHB_sequence::body();
	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
	begin
		`uvm_fatal("SEQUENCE BODY","FAILED TO GET IN SEQUENCE")
	end
	ahb_reg_block_h=env_cfg.ahb_reg_block_h;
endtask


//*********************************************************************************************************************************************************
//====================================================================================================
// TESTCASE-1
// HSIZE==000(Byte)
//====================================================================================================
class byte_test_seq extends master_AHB_sequence;
`uvm_object_utils(byte_test_seq)

//***************************Extern functions*********************************************************
extern function new(string name="byte_test_seq");
extern task body();
endclass

//*********************************Constractor*********************************************************
function byte_test_seq::new(string name="byte_test_seq");
super.new(name);
endfunction

task byte_test_seq::body();
super.body();
req=master_AHB_xtn::type_id::create("req");
//for (int i=0;i<3;i++)
//||||||||||||||||||||||||||||||||||||||||| write and read data ||||||||||||||||||||||||||||||||||||||||||||||||||

//==============================================================================================================
// Byte 0 HSIZE=000 
//==============================================================================================================
begin
start_item(req);
   assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h00;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
  assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h00;})
			    // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
	finish_item(req);
	               if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);             
                             
//==============================================================================================================
// Byte 1 HSIZE=000 
//==============================================================================================================
start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h01;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
  assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h01;})
			    // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
	finish_item(req);
			 if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//end

//==============================================================================================================
// Byte 2 HSIZE=000 
//==============================================================================================================
  start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h02;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

 start_item(req);
assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h02;})
			     // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
finish_item(req);
			  if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//==============================================================================================================
// Byte 3 HSIZE=000 
//==============================================================================================================
  start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h03;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

 start_item(req);
assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h03;})
			   // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
finish_item(req);
end
endtask
//********************************************************************************************************************************************************


//********************************************************************************************************************************************************
//====================================================================================================
// TESTCASE-2
// HSIZE==001(Half_word)
//====================================================================================================
class half_word_seq extends master_AHB_sequence;
  `uvm_object_utils(half_word_seq)
  
//***************************Extern functions*********************************************************
extern function new(string name="half_word_seq");
extern task body();
endclass
  
//*********************************Constractor********************************************************
function half_word_seq::new(string name="half_word_seq");
  super.new(name);
endfunction

//*********************************task body**********************************************************
task half_word_seq::body();
  super.body();
  req=master_AHB_xtn::type_id::create("req");
//  for(int i=0;i<4;i++)
 //|||||||||||||||||| WRITE=1  ||||||||||||||||||||
  begin
    start_item(req);
    	assert(req.randomize() with { 
				hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    //nonsequential
				hwrite==1'b1;	  //write_operation 
                                hsize==3'b001;    //001==16 bits
                                haddr==16'h30;}); 
                                `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
    finish_item(req);
    	
 //|||||||||||||||||| WRITE=0 ||||||||||||||||||||
    start_item(req);
    	assert(req.randomize() with {hsel==1'b1;
    				 hready==1'b1;
				 htrans==2'b10;	 //nonsequential
				 hwrite==1'b0;	 //read_opeartion
				 hsize==3'b001;	 //001==16 bits
				 haddr==16'h30;});
				 `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)
  	finish_item(req);

                          if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);

 //|||||||||||||||||| WRITE=1 ||||||||||||||||||||
    start_item(req);
    	assert(req.randomize() with { 
				hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    //nonsequential
				hwrite==1'b1;	  //write_operation 
                                hsize==3'b001;    //001==16 bits
                                haddr==16'haf;}); 
                                `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
    finish_item(req);
    	
 //|||||||||||||||||| WRITE=0 ||||||||||||||||||||
    start_item(req);
    	assert(req.randomize() with {hsel==1'b1;
    				 hready==1'b1;
				 htrans==2'b10;	 //nonsequential
				 hwrite==1'b0;	 //read_opeartion
				 hsize==3'b001;	 //001==16 bits
				 haddr==16'haf;});
				 `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)
  	finish_item(req);

                          if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);

end
endtask
//********************************************************************************************************************************************************


//********************************************************************************************************************************************************
//====================================================================================================
// TESTCASE-3
// HSIZE==010(word)
//====================================================================================================
class word_test_seq extends master_AHB_sequence;
  `uvm_object_utils(word_test_seq)
  
//***************************Extern functions*********************************************************
extern function new(string name="word_test_seq");
extern task body();
endclass
  
//*********************************Constractor********************************************************
function word_test_seq::new(string name="word_test_seq");
  super.new(name);
endfunction

//*********************************task body**********************************************************
task word_test_seq::body();
  super.body();
  req=master_AHB_xtn::type_id::create("req");
  for(int i=0;i<10;i++)
 //|||||||||||||||||| WRITE=1 write_opeartion=>nonsequential_data ||||||||||||||||||||
  begin
    start_item(req);
    	assert(req.randomize() with { 
				hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    //nonsequential
				hwrite==1'b1;	  //write_operation 
                                hsize==3'b010;    //010==32 bits
                                haddr==16'h8000+i*4;}); 
                                `uvm_info(get_full_name(),$sformatf("ahb_sequence write \n %s",req.sprint()),UVM_MEDIUM)
    finish_item(req);
    	
    start_item(req);
    	assert(req.randomize() with {hsel==1'b1;
    				 hready==1'b1;
				 htrans==2'b10;	 //nonsequential
				 hwrite==1'b0;	 //read_opeartion
				 hsize==3'b010;	 //010==32 bits
				 haddr==16'h8000+i*4;});
				 `uvm_info(get_full_name(),$sformatf("ahb_sequence Read \n %s",req.sprint()),UVM_MEDIUM)
  	finish_item(req);
 end
endtask
//*********************************************************************************************************************************************************

//*********************************************************************************************************************************************************
//====================================================================================================
// TESTCASE-4
// HSIZE==000,001,010(byte,half_word,word)
//====================================================================================================
class variable_size_test_seq extends master_AHB_sequence;
`uvm_object_utils(variable_size_test_seq)

//***************************Extern functions*********************************************************
extern function new(string name="variable_size_test_seq");
extern task body();
endclass

//*********************************Constractor*********************************************************
function variable_size_test_seq::new(string name="variable_size_test_seq");
super.new(name);
endfunction

task variable_size_test_seq::body();
super.body();
req=master_AHB_xtn::type_id::create("req");
//for (int i=0;i<3;i++)
//||||||||||||||||||||||||||||||||||||||||| write and read data ||||||||||||||||||||||||||||||||||||||||||||||||||

//==============================================================================================================
// Byte 0 HSIZE=000 
//==============================================================================================================
begin
start_item(req);
   assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h00;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
  assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h00;})
			                     // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
	finish_item(req);
	               if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);             
                             
//==============================================================================================================
// Byte 1 HSIZE=000 
//==============================================================================================================
	start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h01;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
  assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h01;})
			                     // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
	finish_item(req);
			 if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
end

//==============================================================================================================
// Byte 2 HSIZE=000 
//==============================================================================================================
  start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h02;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

 start_item(req);
assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h02;})
			                     // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
finish_item(req);
			  if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//==============================================================================================================
// Byte 3 HSIZE=000 
//==============================================================================================================
  start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'b000;      
                              haddr==16'h03;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

 start_item(req);
assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b000;    
                                haddr==16'h03;})
			                   // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
finish_item(req);
//==============================================================================================================
// Half_word HSIZE=001 
//==============================================================================================================
start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b1;
			      hsize==3'b001;      
                              haddr==16'hc;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
  assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b1;
				htrans==2'b11;    
				hwrite==1'b0;
                                hsize==3'b001;    
                                haddr==16'hc;})
			                       // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
	finish_item(req);
	
	start_item(req);
assert(req.randomize() with {
                              hsel==1'b0;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b0;
			      hsize==3'b001;      
                              haddr==16'hfe;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
  assert(req.randomize() with { 
                                hsel==1'b1;
				hready==1'b0;
				htrans==2'b10;    
				hwrite==1'b0;
                                hsize==3'b001;    
                                haddr==16'h5;})
			                       // `uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=0 \n %s",req.sprint()),UVM_MEDIUM)	
	finish_item(req);
			  
//==============================================================================================================
// word HSIZE=010 
//==============================================================================================================
// for (int i=0;i<3;i++)
  begin
    start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b1;
			      hsize==3'b010;      
                              haddr==16'h95;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b0;
			      hsize==3'b010;      
                              haddr==16'h95;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
			 if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//==============================================================================================================
// word HSIZE=010 
//==============================================================================================================
start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b1;
			      hsize==3'b001;      
                              haddr==16'hfa;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b0;
			      hsize==3'b001;      
                              haddr==16'hfa;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
			  if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//==============================================================================================================
// word HSIZE=010 
//==============================================================================================================
start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b0;
                              htrans==2'b11;      
			      hwrite==1'b1;
			      hsize==3'b010;      
                              haddr==16'hff;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
start_item(req);
assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b0;
                              htrans==2'b11;      
			      hwrite==1'b0;
			      hsize==3'b010;      
                              haddr==16'hff;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
			  if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//==============================================================================================================
// word HSIZE=010 
//==============================================================================================================
start_item(req);
assert(req.randomize() with {
                              hsel==1'b0;
		      	      hready==1'b0;
                              htrans==2'b11;      
			      hwrite==1'b1;
			      hsize==3'b010;      
                              haddr==16'hab;})
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
start_item(req);
assert(req.randomize() with {
                              hsel==1'b0;
		      	      hready==1'b0;
                              htrans==2'b11;      
			      hwrite==1'b0;
			      hsize==3'b010;      
                              haddr==16'hab;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
			  if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
//==============================================================================================================
// word HSIZE=010 
//==============================================================================================================
start_item(req);
assert(req.randomize() with {
                              hsel==1'b0;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b1;
			      hsize==3'b010;      
                              haddr==16'h28;})
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);
start_item(req);
assert(req.randomize() with {
                              hsel==1'b0;
		      	      hready==1'b1;
                              htrans==2'b11;      
			      hwrite==1'b0;
			      hsize==3'b010;      
                              haddr==16'h28;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

                          if(req.temp==req.hrdata)
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h matched **********",req.temp,req.hrdata);
                          else
                                 $display($time,"********* GIVEN DATA hwdata=%0h and EXPECTED DATA hrdata=%0h mismatched *******",req.temp,req.hrdata);
end
endtask
//*********************************************************************************************************************************************************

//*********************************************************************************************************************************************************
//====================================================================================================
// TESTCASE-5
// 
//====================================================================================================
class default_value_test_seq extends master_AHB_sequence;
`uvm_object_utils(default_value_test_seq)

//***************************Extern functions*********************************************************
extern function new(string name="default_value_test_seq");
extern task body();
endclass

//*********************************Constractor*********************************************************
function default_value_test_seq::new(string name="default_value_test_seq");
super.new(name);
endfunction

task default_value_test_seq::body();
super.body();
req=master_AHB_xtn::type_id::create("req");

//==============================================================================================================
// Byte 0 HSIZE=000 
//==============================================================================================================
begin
start_item(req);
   assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b0;
			      hsize==3'b010;      
                              haddr==16'h3a;}) 
                            //`uvm_info(get_full_name(),$sformatf("ahb_sequence WRITE=1 \n %s",req.sprint()),UVM_MEDIUM)
finish_item(req);

end
endtask
//*********************************************************************************************************************************************************

//*********************************************************************************************************************************************************
//====================================================================================================
// TESTCASE-6
// 
//====================================================================================================

class mem_test_seq extends master_AHB_sequence;
	`uvm_object_utils(mem_test_seq)
	rand bit [31:0] data ;
	rand bit [31:0] data1 ;
	rand bit [15:0] addr ;
	rand bit [15:0] addr1;
	int check;
     uvm_status_e               status;
     uvm_reg_data_t             value,value1;
     uvm_hdl_path_concat mem_hdl_path[$];

    function new(string name= "mem_test_seq");
	super.new(name);
    endfunction

	task body();
     		super.body();
		req=master_AHB_xtn::type_id::create("req");
	
	        for (int count=0; count < 10; count++) begin	
	          check=randomize(addr);
	          check=randomize(data);
		  /*
                  start_item(req);
                   assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b1;
			      hsize==3'h2;      
		          }) 
			  req.haddr[1:0]=0;
                  finish_item(req);
			  addr=req.haddr;
			  data=req.hwdata;

		  start_item(req);
                  assert(req.randomize() with {
                              hsel==1'b1;
		      	      hready==1'b1;
                              htrans==2'b10;      
			      hwrite==1'b0;
			      hsize==3'h2;      
			      haddr==addr;
		          }) 
			  req.haddr[1:0]=0;
                  finish_item(req);
		  */
                  addr=04+count*4;
                  addr[1:0] = 0;
		  `uvm_info("SEQUENCE",$sformatf("addr = %0h  wdata = %0h", addr, data),UVM_LOW);


		  //--------------------WRITE and PEEK------------------------------------------
		  ahb_reg_block_h.mem.write(status,addr, data,.parent(this));
		  
                  ahb_reg_block_h.mem.peek(status, addr, value,.parent(this));
		  if(data[7:0] != value[7:0]) begin
		     `uvm_error("SEQUENCE FD",$sformatf("written data = %0h  peeked data = %0h",data,value));
		  end else begin
		     `uvm_info("SEQUENCE FD",$sformatf("written data = %0h  peeked data = %0h",data,value),UVM_LOW);
		  end
		  //--------------------POKE and PEEK-------------------------------------------
	          check=randomize(data1);
		  ahb_reg_block_h.mem.poke(status,addr, data1, .parent(this));
                  ahb_reg_block_h.mem.peek(status, addr, value,.parent(this));
                  if (data1[7:0] != value[7:0]) begin
                    `uvm_error("SEQUENCE",$sformatf("poked data = %0h  peeked data=%0h",data1,value));
                  end else begin 
                    `uvm_info("SEQUENCE",$sformatf("poked data = %0h  peeked data=%0h",data1,value),UVM_LOW);
                  end
                  //--------------------READ -----------------------------------
		  ahb_reg_block_h.mem.read(status,addr, value1, .parent(this));
                  //ahb_reg_block_h.mem.peek(status, addr, value,.parent(this));
                  //$display($time, "2. peek done after read, value=%0h ", value);
		  if(data[7:0] != value1[7:0]) begin
		     `uvm_error("SEQUENCE FD",$sformatf("poked data = %0h read data = %0h peeked data=%0h",data1,value1, value));
	          end else begin
		     `uvm_info("SEQUENCE FD",$sformatf("poked data = %0h  read data = %0h peeked data=%0h",data1,value1, value),UVM_LOW);
	          end
                  // ---------------------WRITE AND READ BACKDOOR
                  check=randomize(data1);
                  ahb_reg_block_h.mem.write(status,addr, data1, .path(UVM_BACKDOOR), .parent(this));
                  ahb_reg_block_h.mem.read(status,addr, value1, .path(UVM_BACKDOOR), .parent(this));
                  if(data1[7:0] != value1[7:0]) begin
		     `uvm_error("SEQUENCE BD",$sformatf("poked data = %0h read data = %0h peeked data=%0h",data1,value1, value));
	          end else begin
		     `uvm_info("SEQUENCE BD",$sformatf("poked data = %0h  read data = %0h peeked data=%0h",data1,value1, value),UVM_LOW);
	          end

	          //burst_write
		  //burst_read

	        end
		
		endtask
endclass

