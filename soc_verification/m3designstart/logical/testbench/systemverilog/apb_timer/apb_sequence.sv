 ////////////////////////////////////////////////////////////
 //Author:     Abhishek eemani
 //Module:     apb_sequence
 //Filename:   apb_sequence.sv
 //start date: 23/10/2017 
 ////////////////////////////////////////////////////////////

 class apb_sequence extends uvm_sequence#(apb_txn);
   `uvm_object_utils(apb_sequence)
   
   env_config       env_cfg;
   reg_block        blk;

   //Declaring a method within a "CLASS SCOPE" as 'extern' and then define it outside the scope.
   extern function new(string name="apb_sequence");
   extern task body();
 endclass:apb_sequence
  
/////------apb_sequence class construction ------/////
  function apb_sequence::new(string name="apb_sequence");
    super.new(name);
  endfunction:new

  task apb_sequence::body();

    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
    begin
    `uvm_fatal("APB_SEQ","apb_timer env_config getting unsuccessfull")
   end
   blk=env_cfg.blk;

  endtask


//==================================================================
// PASSING ISR SEQUENCE TO CLEAR THE INT_STATUS REGISTER
//==================================================================
 class ISR extends apb_sequence;
   `uvm_object_utils(ISR)
   extern function new(string name="ISR");
   extern task body();
 endclass:ISR
 
/////------ISR class construction ------/////

 function ISR::new(string name="ISR");
   super.new(name);
 endfunction:new
 
 //THIS TASK WILL SEND ISR SEQUENCE SEQUENCER
task ISR::body();
 m_sequencer.grab(this);
    req = apb_txn::type_id::create("req");
     begin
            start_item(req);
     		       			assert(req.randomize() with {pwrite==1'b1;
                        		             paddr== `INTSTATUS_ADDR;//003
                                    		     psel==1'b1;
                                    		     penable==1'b1;
                                    		     pwdata==32'b001;})//001
    	 finish_item(req);
		`uvm_info("ISR_SEQUENCE",$sformatf("after clearing INT_STATUS(====1====) register PRDATA=%X \n",temp_prdata),UVM_LOW)
     end

m_sequencer.ungrab(this);
endtask:body
 
//============================================================================
// WR_RD OF ALL REGISTER
//============================================================================
 
 class wr_rd_all_reg extends apb_sequence;
  `uvm_object_utils(wr_rd_all_reg)

  extern function new(string name="wr_rd_all_reg");
  extern task body();
 endclass:wr_rd_all_reg
 
 
/////------wr_rd_all_registers class constructor ------/////
 function wr_rd_all_reg::new(string name="wr_rd_all_reg");
  super.new(name);
 endfunction:new

 //RANDOMIZE THE SEQUECNE_ITEM AND SEND TO SEQUENCER
 task wr_rd_all_reg::body();
   
 reg [11:2]addr;
   req = apb_txn::type_id::create("req");
   
/////////1.======================READING DEFAULT VALUES OF PID & CID REGISTERS=========================////////
     begin
        for(int j=0; j<12; j++) begin
         addr=10'h3f4+j;
          start_item(req);
            assert(req.randomize() with {pwrite==1'b0;
                                         psel==1'b1;
                                         paddr==addr;
                                         penable==1'b1;})                               
           finish_item(req);
           
    //`uvm_info("WR_RD_ALL_REG",$sformatf("PRINTING DEFAULT (R0) SEQUENCE \n"),UVM_LOW)
                                end
     end
       
//////////2.=========================READING RESET VALUES OF TIMER REGISTERS============================////////
       begin
        for(int j=0; j<4; j++) begin
         addr=10'h000+j*4;
         start_item(req);
           assert(req.randomize() with {pwrite==1'b0;
                                        psel==1'b1;
                                        paddr==addr;
                                        penable==1'b1;})
         finish_item(req);
                              end
        end
           
////////////========== WRITES AND READS OF RELOAD,CTRL,CURRRENT VALUE,INTSTATUS ============////////////
        begin
        //WRITING RELOAD REGISTER 
        start_item(req);
          assert(req.randomize() with {pwrite==1'b1;
                                       paddr== `RELOAD_ADDR;//002
                                       psel==1'b1;
                                       penable==1'b1;
                                       pwdata== `RELOAD_DATA;})//ff                           
        finish_item(req);
        //WRITING CONTROL REGISTER 
        start_item(req);
          assert(req.randomize() with {pwrite==1'b1;
                                       paddr== `CTRL_ADDR;//000
                                       psel==1'b1;
                                       penable==1'b1;
                                       pwdata== `CTRL_DATA;})//1011                             
        finish_item(req);
/////////3.=================READING RELOAD VALUE REGISTER==================////////////////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `RELOAD_ADDR;//002
                                       psel==1'b1;
                                       penable==1'b1;})
        finish_item(req);
////////4.===================READING CONTROL VALUE REGISTER=================///////////////////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `CTRL_ADDR;//000
                                       psel==1'b1;
                                       penable==1'b1;})
        finish_item(req);
///////5.====================READING CURRENT VALUE REGISTER( READ---> 1)==================//////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;})
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 2)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })                           
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 3)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })                           
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 4)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })        
        finish_item(req);
         //READING CURRENT VALUE REGISTER( READ---> 5)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })        
        finish_item(req);
///////////6.==================READING THE INTSTATUS REGISTER=================//////////////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `INTSTATUS_ADDR;
                                       psel==1'b1;
                                       penable==1'b1;})
        finish_item(req);
      end      
     
  endtask
//=============================================================================
//(COMBINATION OF PSEL(0,1),PENABLE(0,1) VALUES) 
//=============================================================================

class psel_penable_comb extends apb_sequence;
  `uvm_object_utils(psel_penable_comb)
  
  extern function new(string name="psel_penable_comb");
  extern task body();
endclass

/////------psel_penable_comb class construction ------/////
function psel_penable_comb::new(string name="psel_penable_comb");
  super.new(name);
endfunction

task psel_penable_comb::body();
  req=apb_txn::type_id::create("req");
  begin
////////////////////WRITE//////////////////////////////////////////   
     
     start_item(req);
     assert(req.randomize() with {pwrite==1'b1;                                   //WRITE IS HAPENNING FOR THIS SEQUENCE EVEN PENABLE=0
                                  psel==1'b1;
                                  paddr==`RELOAD_ADDR;      	                                  
                                  penable==1'b0;
                                  pwdata==`RELOAD_DATA;})                               
    finish_item(req);
////========READ========////
    start_item(req);
     assert(req.randomize() with {pwrite==1'b0;                                   //READ IS HAPPENNING BECOZ OF WRITE
                                  psel==1'b1;
                                  paddr==`RELOAD_ADDR;                                            
                                  penable==1'b1;})                               
   finish_item(req); 

    ////////////////////============Data checks============////////////////     
`ifdef ASSERT_ON
if(temp_pwdata==temp_prdata)
 `uvm_info("PSEL_PENABLE_COMB(1)",$sformatf("DATA CHECKS PWDATA=%0X and PRDATA=%0X MATCHED \n",temp_pwdata,temp_prdata),UVM_LOW)
else
 `uvm_error("PSEL_PENABLE_COMB(1)","DATA CHECKS PWDATA and PRDATA MIS--MATCHED \n")
`endif
/////////////////////WRITE////////////////////////////////////////
    start_item(req);
     assert(req.randomize() with {pwrite==1'b1;                                               ///WRITE IS NOT HAPPENING BECAUSE OF PSEL=0
                                  psel==1'b0;
                                  paddr==`RELOAD_ADDR;
                                  penable==1'b0;
                                  pwdata==32'H100;})                               
    finish_item(req);
               //========READ=========//
     start_item(req);
     assert(req.randomize() with {pwrite==1'b0;                                                //READ IS NOT HAPPENING BECOZ OF WRITE IS NOT HAPPENING
                                  psel==1'b1;
                                  paddr==`RELOAD_ADDR;
                                  penable==1'b1;})                               
    finish_item(req); 

////////////////////============Data checks============////////////////
`ifdef ASSERT_ON
if(temp_pwdata==temp_prdata)
 `uvm_info("PSEL_PENABLE_COMB(2)",$sformatf("DATA CHECKS PWDATA=%0X and PRDATA=%0X MATCHED \n",temp_pwdata,temp_prdata),UVM_LOW)
else
 `uvm_error("PSEL_PENABLE_COMB(2)"," PWDATA and PRDATA MIS--MATCHED \n")
`endif 
   
//////////////////////WRITE/////////////////////////////////////// 
    start_item(req);
     assert(req.randomize() with {pwrite==1'b1;                                              //WRITE IS HAPPENNING(DATA MATCHED) 
                                  psel==1'b1;
                                  paddr==`RELOAD_ADDR;
                                  penable==1'b1;
                                  pwdata==32'HAA;})                               
    finish_item(req);
               //READ
     start_item(req);
     assert(req.randomize() with {pwrite==1'b0;                                               //READ IS HAPPENING EVEN PENABLE=0
                                  psel==1'b1;
                                  paddr==`RELOAD_ADDR;
                                  penable==1'b0;})                               
    finish_item(req);  
    ////////////////////============Data checks============//////////////// 
 `ifdef ASSERT_ON
 if(temp_pwdata==temp_prdata)
 	`uvm_info("PSEL_PENABLE_COMB(3)",$sformatf("DATA CHECKS PWDATA=%0X and PRDATA=%0X MATCHED \n",temp_pwdata,temp_prdata),UVM_LOW)
	else
	 `uvm_error("PSEL_PENABLE_COMB(3)"," PWDATA and PRDATA MIS--MATCHED \n")
 `endif  
    //////////////////////WRITE/////////////////////////////////////////////
    start_item(req);
     assert(req.randomize() with {pwrite==1'b1;                                             ///WRITE IS HAPENNING EVEN FOR PENABLE=0 
                                  psel==1'b1;
                                  paddr==`RELOAD_ADDR;
                                  penable==1'b0;
                                  pwdata==32'H123;})                               
    finish_item(req);
               //READ
     start_item(req);
     assert(req.randomize() with {pwrite==1'b0;
                                  psel==1'b0;
                                  paddr==`RELOAD_ADDR;                                      //READ IS NOT HAPPENING BECOZ OF PSEL=0
                                  penable==1'b1;
                                  })                               
    finish_item(req);
////////////////////============Data checks============//////////////// 
`ifdef ASSERT_ON
if(temp_pwdata==temp_prdata)
 	`uvm_info("PSEL_PENABLE_COMB(4)",$sformatf("DATA CHECKS PWDATA=%0X and PRDATA=%0X MATCHED \n",temp_pwdata,temp_prdata),UVM_LOW)
	 else
 	   `uvm_error("PSEL_PENABLE_COMB(4)","PWDATA and PRDATA MIS--MATCHED \n")
`endif
     end
endtask

//==================================================================
// WRITE AND READ OF TIMER REGISTERS
//==================================================================
 
class wr_rd_timer_reg extends apb_sequence;
  `uvm_object_utils(wr_rd_timer_reg)
  
  extern function new(string name="wr_rd_timer_reg");
  extern task body();
 endclass
 
/////------wr_rd_timer_reg class construction ------/////
function wr_rd_timer_reg::new(string name="wr_rd_timer_reg");
  super.new(name);
endfunction

task wr_rd_timer_reg::body();
  req = apb_txn::type_id::create("req");
   begin
/////////WRITING RELOAD REG, VALUE REG,CTRL VALUE,INTSTATUS VALUES////////////  
      start_item(req);
          assert(req.randomize() with { pwrite==1'b1;                                       //WRITING RELOAD VALUE REGISTER
                                        paddr== `RELOAD_ADDR;//002
                                        psel==1'b1;
                                        penable==1'b0;
                                        pwdata== `RELOAD_DATA;})                   
      finish_item(req);
   
      start_item(req);
          assert(req.randomize() with { pwrite==1'b1;                                        //WRITING CTRL VALUE REGISTER
                                        paddr== `CTRL_ADDR;
                                        psel==1'b1;
                                        penable==1'b0;
                                        pwdata== `CTRL_DATA;})                               
      finish_item(req);
     
     start_item(req);
         assert(req.randomize() with {pwrite==1'b0;                                         //READING RELOAD VALUE REGISTER
                                      paddr== `RELOAD_ADDR;//002
                                      psel==1'b1;
                                      penable==1'b1;})
     finish_item(req);

    
      start_item(req);
         assert(req.randomize() with {pwrite==1'b0;                                          //READING CTRL VALUE REGISTER
                                      paddr== `CTRL_ADDR;//000
                                      psel==1'b1;
                                      penable==1'b1;})
     finish_item(req);
     
      start_item(req);
         assert(req.randomize() with {pwrite==1'b0;                                           //READING CURRENT VALUE REGISTER
                                      paddr== `VALUE_ADDR;//001
                                      psel==1'b1;
                                      penable==1'b1;})
     finish_item(req);
     
     start_item(req);
         assert(req.randomize() with {pwrite==1'b0;                                           //READING INT_STATUS REGISTER
                                      paddr== `INTSTATUS_ADDR ;//001
                                      psel==1'b1;
                                      penable==1'b1;})
     finish_item(req);


end 
endtask
//==================================================================
//(PID & CID DEFAULT VALUES CHECK)
//==================================================================
 
class pid_cid_checks extends apb_sequence;
  `uvm_object_utils(pid_cid_checks)
  env_config env_cfg;

  extern function new(string name="pid_cid_checks");
  extern task body();
 endclass
 
/////------pid & cid checks class construction ------/////
function pid_cid_checks::new(string name="pid_cid_checks");
  super.new(name);
endfunction

task pid_cid_checks::body();
  int a[12] = {`PID4_DATA,`PID5_DATA,`PID6_DATA,`PID7_DATA,`PID0_DATA,`PID1_DATA,
               `PID2_DATA,`PID3_DATA,`CID0_DATA,`CID1_DATA,`CID2_DATA,`CID3_DATA};
  reg [11:2]addr;
  req = apb_txn::type_id::create("req");
  
  begin
   for(int j=0; j<12; j++)begin
   addr=10'h3f4+j;
     start_item(req);
     assert(req.randomize() with {psel==1'b1;
                                  pwrite==1'b0;
                                  paddr==addr;
                                  penable==1'b1;}) 
       
    finish_item(req);
   
    `uvm_info("APB_SEQUECNE",$sformatf("PRINTING from seq temp_PRDATA=%X\n",temp_prdata),UVM_LOW) 

    for (int j=0; j<12; j++) begin
		    if (temp_prdata == a[j]) begin
		     $display("=====================================DATA_CHECKS(SEQ)====================================");
   		    $display($time, "prdata=%X AND a[j]=%X DATA_MATCHED",temp_prdata,a[j]);
									               end
		//else
		//begin
		//	`uvm_error(get_name(),"ERROR SEQUENCE")
		//end
                              end

                          end
  end
  
endtask


//==================================================================
// EXTIN DISABLE WHILE DOWNCOUNTING
//==================================================================
 
class extin_disable extends apb_sequence;
  `uvm_object_utils(extin_disable)
  
  extern function new(string name="extin_disable");
  extern task body();
 endclass
 
/////------extin disbale class construction ------/////
function extin_disable::new(string name="extin_disable");
  super.new(name);
endfunction

task extin_disable::body();
  req = apb_txn::type_id::create("req");
   begin
/////////WRITING RELOAD REG, VALUE REG,CTRL VALUE,INTSTATUS VALUES////////////  
 start_item(req);
          assert(req.randomize() with { pwrite==1'b1;                                     //WRITING RELOAD VALUE REGISTER
                                        paddr== `RELOAD_ADDR;//002
                                        psel==1'b1;
                                        penable==1'b1;
                                        pwdata== `RELOAD_DATA;}) //ff                  
      finish_item(req);
   
      start_item(req);
          assert(req.randomize() with { pwrite==1'b1;                                     //WRITING CTRL VALUE REGISTER
                                        paddr== `CTRL_ADDR;
                                        psel==1'b1;
                                        penable==1'b1;
                                        pwdata== `CTRL_DATA;})                               
      finish_item(req);
     
      start_item(req);
          assert(req.randomize() with {pwrite==1'b0;                                      //READING RELOAD VALUE REGISTER
                                       paddr== `RELOAD_ADDR;//002
                                       psel==1'b1;
                                       penable==1'b1;})
      finish_item(req);

      
       start_item(req);
          assert(req.randomize() with {pwrite==1'b0;                                      //READING CTRL VALUE REGISTER
                                       paddr== `CTRL_ADDR;//000
                                       psel==1'b1;
                                       penable==1'b1;})
      finish_item(req);
      
       start_item(req);
          assert(req.randomize() with {pwrite==1'b0;                                      //READING CURRENT VALUE REGISTER
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;})
      finish_item(req);
      
      start_item(req);
          assert(req.randomize() with {pwrite==1'b0;                                     //READING INT_STATUS REGISTER
                                       paddr== `INTSTATUS_ADDR ;//001
                                       psel==1'b1;
                                       penable==1'b1;})
      finish_item(req);
 
    end
endtask



//=============================================================================
//CHANGE IN RELOAD VALUE WHILE DOWNCOUNTING
//=============================================================================

class change_reload_val extends apb_sequence;
  `uvm_object_utils(change_reload_val)
  
  extern function new(string name="change_reload_val");
  extern task body();
endclass

/////------change reload val class construction ------/////
function change_reload_val::new(string name="change_reload_val");
  super.new(name);
endfunction

task change_reload_val::body();
  //reg [11:2]addr;
  req=apb_txn::type_id::create("req");
  begin
 //WRITING RELOAD REGISTER 
        start_item(req);
          assert(req.randomize() with {pwrite==1'b1;
                                       paddr== `RELOAD_ADDR;//002
                                       psel==1'b1;
                                       penable==1'b1;
                                       pwdata== `RELOAD_DATA;})//ff                           
        finish_item(req);
        //WRITING CONTROL REGISTER 
        start_item(req);
          assert(req.randomize() with {pwrite==1'b1;
                                       paddr== `CTRL_ADDR;//000
                                       psel==1'b1;
                                       penable==1'b1;
                                       pwdata== `CTRL_DATA;})//1011                             
        finish_item(req);
        
        //////====================READING CURRENT VALUE REGISTER( READ---> 1)==================//////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;})
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 2)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })                           
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 3)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })                           
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 4)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })        
        finish_item(req);
         //READING CURRENT VALUE REGISTER( READ---> 5)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })        
        finish_item(req);
////////=========SETTING NEW RELOAD VALUE REGISTER========///////////////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b1;
                                       paddr== `RELOAD_ADDR;//002
                                       psel==1'b1;
                                       penable==1'b1;
                                       pwdata== 32'Hf;})//f                           
        finish_item(req);
         
//////====================READING CURRENT VALUE REGISTER WHILE COUNTING IS HAPPENNING( READ---> 1)==================//////
        start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;})
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 2)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })                           
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 3)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })                           
        finish_item(req);
        //READING CURRENT VALUE REGISTER( READ---> 4)
         start_item(req);
          assert(req.randomize() with {pwrite==1'b0;
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;
                                       })        
        finish_item(req);
        
    
   //$display($time, "READ OPERATION COMPLETED FROM SEQUENCE");
 end

endtask



//==================================================================
// SETTING TIMER FOR (ISR)
//==================================================================
 
class set_timer_fr_isr extends apb_sequence;
  `uvm_object_utils(set_timer_fr_isr)
  
  extern function new(string name="set_timer_fr_isr");
  extern task body();
 endclass
 
/////=====set_timer_fr_isr class construction=====/////
function set_timer_fr_isr::new(string name="set_timer_fr_isr");
  super.new(name);
endfunction

task set_timer_fr_isr::body();
  req = apb_txn::type_id::create("req");
   begin
/////////WRITING RELOAD REG, VALUE REG,CTRL VALUE,INTSTATUS VALUES////////////  
 
start_item(req);
          assert(req.randomize() with { pwrite==1'b1;                                     //WRITING RELOAD VALUE REGISTER
                                        paddr== `RELOAD_ADDR;//002
                                        psel==1'b1;
                                        penable==1'b1;
                                        pwdata== `RELOAD_DATA;}) //ff                  
      finish_item(req);
   
		`uvm_info("SET_TIMER_FR_ISR",$sformatf("PRDATA=%X \n",temp_prdata),UVM_LOW)
      
     start_item(req);
          assert(req.randomize() with { pwrite==1'b1;                                     //WRITING CTRL VALUE REGISTER
                                        paddr== `CTRL_ADDR;
                                        psel==1'b1;
                                        penable==1'b1;
                                        pwdata== `CTRL_DATA;})                               
      finish_item(req);
     
		`uvm_info("SET_TIMER_FR_ISR",$sformatf("PRDATA=%X \n",temp_prdata),UVM_LOW)
      
      start_item(req);
          assert(req.randomize() with {pwrite==1'b0;                                      //READING CURRENT VALUE REGISTER
                                       paddr== `VALUE_ADDR;//001
                                       psel==1'b1;
                                       penable==1'b1;})
      finish_item(req);
      
		`uvm_info("SET_TIMER_FR_ISR",$sformatf("PRDATA=%X \n",temp_prdata),UVM_LOW)
    end
endtask


//==================================================================
//REGISTER TESTCASE
//==================================================================
 
class register_seq extends apb_sequence;
  `uvm_object_utils(register_seq)
	
  int 		    data;
  uvm_status_e      status;
  uvm_reg_data_t    value;

  extern function new(string name="register_seq");
  extern task body();
  
  extern task control_reg();
  extern task value_reg();
  extern task reload_reg();
  extern task int_status();
  extern task pid_seq();


endclass
 
function register_seq::new(string name="register_seq");
  super.new(name);
endfunction

task register_seq::body();
	super.body();
	
	control_reg();
	value_reg();
	reload_reg();
	int_status();
	pid_seq();

endtask


task register_seq::control_reg();
	data = blk.ctl_reg.get();  //To get the desired value	
	$display("data=%h",data);

	blk.ctl_reg.set('hFE);  //To set the desired value
	
	data = blk.ctl_reg.get();  //To get the desired value
	$display("data=%h",data);

	blk.ctl_reg.write(status,'hE,.parent(this)); //Physical write to DUT register updates desired and mirror values in reg model
	data = blk.ctl_reg.get();  //To get the desired value

	blk.ctl_reg.set('hF);//set the desired value but mirror value will be the previous write

	blk.ctl_reg.update(status,(UVM_FRONTDOOR),.parent(this));  //compares desired and value in hardware reg....if any mismatch interally calls write method 
	
	blk.ctl_reg.predict('hF,.path(UVM_BACKDOOR));//sets the desired and mirrored value

	blk.ctl_reg.mirror(status,UVM_CHECK,(UVM_BACKDOOR),.parent(this));

	blk.ctl_reg.read(status,value,.parent(this)); //Read() method will read data from DUT and write to the value reg,mirror reg,desired reg 
	
 	blk.ctl_reg.poke(status,'hf,.parent(this));
       	
	blk.ctl_reg.peek(status,value,.parent(this));      //Backdoor read

endtask

task register_seq::value_reg();
	data = blk.val_reg.get();  //To get the desired value	
	$display("data=%h",data);

	blk.val_reg.set('hFE);  //To set the desired value
	
	data = blk.val_reg.get();  //To get the desired value
	$display("data=%h",data);

	blk.val_reg.write(status,'hCAFE,.parent(this)); //Physical write to DUT register updates desired and mirror values in reg model
	data = blk.val_reg.get();  //To get the desired value

	blk.val_reg.set('hFF);//set the desired value but mirror value will be the previous write

	blk.val_reg.update(status,(UVM_FRONTDOOR),.parent(this));  //compares desired and value in hardware reg....if any mismatch interally calls write method 
	
	blk.val_reg.predict(32'hCAF,.path(UVM_BACKDOOR));//sets the desired and mirrored value

	blk.val_reg.mirror(status,UVM_CHECK,(UVM_BACKDOOR),.parent(this));

	blk.val_reg.read(status,value,.parent(this)); //Read() method will read data from DUT and write to the value reg,mirror reg,desired reg 
	
 	blk.val_reg.poke(status,32'hffff_ffff,.parent(this));
       	
	blk.val_reg.peek(status,value,.parent(this));      //Backdoor read

endtask


task register_seq::reload_reg();
	data = blk.rld_reg.get();  //To get the desired value	
	$display("data=%h",data);

	blk.rld_reg.set('hFE);  //To set the desired value
	
	data = blk.rld_reg.get();  //To get the desired value
	$display("data=%h",data);

	blk.rld_reg.write(status,'hCAFE,.parent(this)); //Physical write to DUT register updates desired and mirror values in reg model
	data = blk.rld_reg.get();  //To get the desired value

	blk.rld_reg.set('hFF);//set the desired value but mirror value will be the previous write

	blk.rld_reg.update(status,(UVM_FRONTDOOR),.parent(this));  //compares desired and value in hardware reg....if any mismatch interally calls write method 
	
	blk.rld_reg.predict(32'hCAF,.path(UVM_BACKDOOR));//sets the desired and mirrored value

	blk.rld_reg.mirror(status,UVM_CHECK,(UVM_BACKDOOR),.parent(this));

	blk.rld_reg.read(status,value,.parent(this)); //Read() method will read data from DUT and write to the value reg,mirror reg,desired reg 
	
 	blk.rld_reg.poke(status,32'hffff_ffff,.parent(this));
       	
	blk.rld_reg.peek(status,value,.parent(this));      //Backdoor read

endtask




task register_seq::int_status();
	data = blk.intr_reg.get();  //To get the desired value	
	$display("data=%h",data);

	blk.intr_reg.set('h1);  //To set the desired value
	
	data = blk.intr_reg.get();  //To get the desired value
	$display("data=%h",data);

	blk.intr_reg.write(status,'h0,.parent(this)); //Physical write to DUT register updates desired and mirror values in reg model
	data = blk.intr_reg.get();  //To get the desired value

	blk.intr_reg.set('h1);//set the desired value but mirror value will be the previous write

	blk.intr_reg.update(status,(UVM_FRONTDOOR),.parent(this));  //compares desired and value in hardware reg....if any mismatch interally calls write method 
	
	blk.intr_reg.predict('h1,.path(UVM_BACKDOOR));//sets the desired and mirrored value

	blk.intr_reg.mirror(status,UVM_CHECK,(UVM_BACKDOOR),.parent(this));

	blk.intr_reg.read(status,value,.parent(this)); //Read() method will read data from DUT and write to the value reg,mirror reg,desired reg 
	
 	blk.intr_reg.poke(status,'h1,.parent(this));
       	
	blk.intr_reg.peek(status,value,.parent(this));      //Backdoor read
endtask


task register_seq::pid_seq();
	data = blk.pid_regg.get();  //To get the desired value	
	$display("data=%h",data);

	blk.pid_regg.set('hFE);  //To set the desired value
	
	data = blk.pid_regg.get();  //To get the desired value
	$display("data=%h",data);

	blk.pid_regg.write(status,'hE,.parent(this)); //Physical write to DUT register updates desired and mirror values in reg model
	data = blk.pid_regg.get();  //To get the desired value

	blk.pid_regg.set('hF);//set the desired value but mirror value will be the previous write

	blk.pid_regg.update(status,(UVM_FRONTDOOR),.parent(this));  //compares desired and value in hardware reg....if any mismatch interally calls write method 
	
	blk.pid_regg.predict('hF,.path(UVM_BACKDOOR));//sets the desired and mirrored value

	blk.pid_regg.mirror(status,UVM_CHECK,(UVM_BACKDOOR),.parent(this));

	blk.pid_regg.read(status,value,.parent(this)); //Read() method will read data from DUT and write to the value reg,mirror reg,desired reg 
	
 	blk.pid_regg.poke(status,'hf,.parent(this));
       	
	blk.pid_regg.peek(status,value,.parent(this));      //Backdoor read

endtask

