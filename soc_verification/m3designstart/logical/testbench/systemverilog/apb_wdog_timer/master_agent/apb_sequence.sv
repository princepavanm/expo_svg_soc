/**********************************************************
Author 		: Ramkumar 
File 		: master_sequence.sv
Module name     : master_sequence 
Description     :        
Started DATA    : 06/03/2018  
**********************************************************/ 

class master_sequence extends uvm_sequence #(master_trans);
	 `uvm_object_utils(master_sequence)

	 int q[$]={24'h59,24'h0,24'h1,24'h2,24'h3,24'h4,24'h5,24'h3C0,24'h3C1,24'h300};
  //Declaring event pool
  uvm_event_pool pool;
  //Declaring event from event class
  uvm_event event_sb;
  //Register model
  apb_reg_block apb_rb;
  //Env config (containing register model handle)
  env_config env_cfg;
  rand uvm_reg_data_t data;
  uvm_status_e status;
//*************************methods************************
extern function new (string name="master_sequence");
extern task body();
endclass:master_sequence


//*********************constructor************************
function master_sequence :: new (string name="master_sequence");
	 super.new(name);
  //create a new pool with given name
  pool=new();
 //Get global pool allows items to be shared amongst components thoughout the
 //vaerification environment
 pool=pool.get_global_pool();
 //get to return the item with given key
 event_sb=pool.get("lock");
endfunction:new

//*********************constructor************************
task master_sequence::body();
	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
	begin
		`uvm_fatal("SEQUENCE BODY","FAILED TO GET IN SEQUENCE")
	end
	apb_rb=env_cfg.apb_rb;
endtask

//==================================================================//
// T.C. 1 :Reading default values of DUT
//==================================================================//
class apb_read_default_values extends master_sequence;
  `uvm_object_utils(apb_read_default_values) 
   int j=4'h0;
//****************************Methods*******************************    
  extern function new(string name="apb_read_default_values");
  extern task body();
endclass:apb_read_default_values
  
//****************************Constructor***************************
function apb_read_default_values :: new(string name="apb_read_default_values");
  super.new(name);
endfunction
  
//***********************apb_read_default_values*********************** 
task apb_read_default_values::body();
   reg [11:2]addr;
   req=master_trans::type_id::create("req");
	  `uvm_info("called by seq_library  1","called by seq_library  1",UVM_MEDIUM); 
      begin
         for(j=0;j<9;j++)
	 begin
		 if(j==0)
	         req.presetn=1'b0;
	 	 else
		 req.presetn=1'b1;
	    addr=32'h0+1*j;
   	    `uvm_info("MASTER SEQUENCE","///////*******Body in sequence********////////",UVM_MEDIUM)
            start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b0;
                                  		paddr==addr;
				  		})

           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)   
            finish_item(req);
	  end
    end

endtask

//==================================================================//
// T.C. 2 :Generating watchdog reset of DUT
//==================================================================//

class apb_wdog_rst extends master_sequence;
`uvm_object_utils(apb_wdog_rst)

//****************************Methods******************************* 
extern function new(string name= "apb_wdog_rst");
extern task body();
endclass

//****************************Constructor***************************
function apb_wdog_rst::new(string name= "apb_wdog_rst");
super.new(name);
endfunction

//***********************apb_wdog_rst*********************************** 
task apb_wdog_rst::body();
req=master_trans::type_id::create("req");
	  `uvm_info("called by seq_library  2","called by seq_library  2",UVM_MEDIUM); 
//Resetting
begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

//Setting control register
	begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

//Loading the counter wdogload
      begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
	req.intp=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
endtask

//==================================================================//
// T.C. 3 :Writting to all registers and then reading the same 
// to check the behaviour
//==================================================================//

class apb_wr_rd_values extends master_sequence;
  `uvm_object_utils(apb_wr_rd_values) 
  // add reg block instance



  int j=0;
   //****************************Methods*******************************    
  extern function new(string name="apb_wr_rd_values");
  extern task body();
endclass:apb_wr_rd_values
  
//****************************Constructor***************************
function apb_wr_rd_values :: new(string name="apb_wr_rd_values");
  super.new(name);
endfunction
  
//***********************apb_wr_rd_values*********************** 
task apb_wr_rd_values::body();
   req=master_trans::type_id::create("req");
	  `uvm_info("called by seq_library  3","called by seq_library  3",UVM_MEDIUM); 
   req.constraint_mode(0);
   event_sb.trigger();
      begin
         for(j=0;j<10;j++)
	 begin
		 if(j==0)
	         req.presetn=1'b0;
	 	 else
		 req.presetn=1'b1;
	     start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b1;
                                  		paddr==  q[j];

				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    

	  
            finish_item(req);

	  end
    end
	
    begin
         for(j=0;j<10;j++)
	 begin
	     start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b0;
                                  		paddr==q[j];
				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
	  end
    end

            
endtask

//==================================================================//
// T.C. 4 :Clearing the interrupt after interrupt
//==================================================================//

class apb_intrpt_rst extends master_sequence;
  `uvm_object_utils(apb_intrpt_rst) 
 
  uvm_event_pool eve_pool;

uvm_event eve;

   //****************************Methods*******************************    
  extern function new(string name="apb_intrpt_rst");
  extern task body();
endclass:apb_intrpt_rst
  
//****************************Constructor***************************
function apb_intrpt_rst :: new(string name="apb_intrpt_rst");
  super.new(name);
  	 eve_pool=new();
	 eve_pool=eve_pool.get_global_pool();
	 eve=eve_pool.get("Interrupt");

endfunction
  
//***********************apb_intrpt_rst*********************** 
task apb_intrpt_rst::body();
   req=master_trans::type_id::create("req");
	  `uvm_info("called by seq_library  4","called by seq_library  4",UVM_MEDIUM); 
   req.constraint_mode(0);
   event_sb.trigger();
    //Resetting
	begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)  
            finish_item(req);
      end

  //Setting control register
	begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Loading the counter wdogload
      begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
     $display($time,"HELLO THIS IS BEFORE THE INTERRUPT");
      eve.trigger();
        $display($time,"INTERRUPT TRIGGERED AFTER THE EVENT");

//Clearing the interrupt to supress the event
begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3;
					     pwdata==32'hFFFFF;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

            
endtask


//==================================================================//
// T.C. 5 : Locking the watchdog to disable the write access
//==================================================================//

class apb_locked_reg extends master_sequence;
  `uvm_object_utils(apb_locked_reg) 
 
   //****************************Methods*******************************    
  extern function new(string name="apb_locked_reg");
  extern task body();
endclass:apb_locked_reg
  
//****************************Constructor***************************
function apb_locked_reg :: new(string name="apb_locked_reg");
  super.new(name);
endfunction
  
//***********************apb_locked_reg*********************** 
task apb_locked_reg::body();
   req=master_trans::type_id::create("req");
	  `uvm_info("called by seq_library  5","called by seq_library  5",UVM_MEDIUM); 
   req.constraint_mode(0);
event_sb.trigger();
//Now writting datas and trying to read same data
      begin
         for(int j=9;j>0;j--)
	 begin
		 if(j==10)
	         req.presetn=1'b0;
	 	 else
		 req.presetn=1'b1;
	 	req.intp=1'b1;
	     start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b1;
                                  		paddr==q[j];
				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
	  end
    end
//Checking Lock status
	begin
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b0;
					     paddr==24'h 300;
					     pwdata==32'h 124;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
    	end
//Reading the values from same register 
    begin
         for(int j=1;j<10;j++)
	 begin
	     start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b0;
                                  		paddr==q[j];
				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
	  end
    end

endtask

//==================================================================//
// T.C. 6 : Observing watchdog in integration test mode	and reset 
// behaviour				
//==================================================================//
class apb_int_mode_rst extends master_sequence;
  `uvm_object_utils(apb_int_mode_rst) 
 
   //****************************Methods*******************************    
  extern function new(string name="apb_int_mode_rst");
  extern task body();
endclass:apb_int_mode_rst
  
//****************************Constructor***************************
function apb_int_mode_rst :: new(string name="apb_int_mode_rst");
  super.new(name);
endfunction
  
//***********************apb_int_mode_rst*********************** 
task apb_int_mode_rst::body();
   req=master_trans::type_id::create("req");
	  `uvm_info("called by seq_library  6","called by seq_library  6",UVM_MEDIUM); 
   req.constraint_mode(0);
   event_sb.trigger();
//Resetting
	begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
	`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
//Inabling Interrupt in control register
	begin
	      
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

//Loading the counter wdogload
      begin
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
//Setting the test control register
      begin
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3C0;
					     pwdata==1'b1; //1 => It is in test mode
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
    end
  
//Setting the test output register
      begin
	start_item(req);
	req.intp=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3C1;
					     pwdata==2'b01;   //interrupt is disabled 
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
//If we are in test mode and if we only enabling the reset then the time at
//which we load WDOGITOP will give WDOGRES high.
  
endtask

//==================================================================//
// T.C. 7 : Observing watchdog in integration test mode	and interrupt 
// behaviour				
//==================================================================//
class apb_int_mode_int extends master_sequence;
  `uvm_object_utils(apb_int_mode_int) 
 
   //****************************Methods*******************************    
  extern function new(string name="apb_int_mode_int");
  extern task body();
endclass:apb_int_mode_int
  
//****************************Constructor***************************
function apb_int_mode_int :: new(string name="apb_int_mode_int");
  super.new(name);
endfunction
  
//***********************apb_int_mode_int*********************** 
task apb_int_mode_int::body();
   req=master_trans::type_id::create("req");
   req.constraint_mode(0);
   event_sb.trigger();
//Resetting
	begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
	`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
//Inabling Interrupt in control register
	begin
	      
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

//Loading the counter wdogload
      begin
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
//Setting the test control register
      begin
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3C0;
					     pwdata==1'b1; //1 => It is in test mode
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
    end
  
//Setting the test output register
      begin
	start_item(req);
	req.intp=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3C1;
					     pwdata==2'b10; //reset is disabled 
					     })
            finish_item(req);
      end
  
endtask

//=====================================================================================//
// T.C. 8 :Corrupting the counter value in the mid of transaction using callback method
//=====================================================================================//

class apb_intrpt_rst_cb extends master_sequence;
  `uvm_object_utils(apb_intrpt_rst_cb) 
 
  uvm_event_pool eve_pool;

uvm_event eve;

   //****************************Methods*******************************    
  extern function new(string name="apb_intrpt_rst_cb");
  extern task body();
endclass:apb_intrpt_rst_cb
  
//****************************Constructor***************************
function apb_intrpt_rst_cb :: new(string name="apb_intrpt_rst_cb");
  super.new(name);
  	 eve_pool=new();
	 eve_pool=eve_pool.get_global_pool();
	 eve=eve_pool.get("Interrupt");

endfunction
  
//***********************apb_intrpt_rst_cb*********************** 
task apb_intrpt_rst_cb::body();
   req=master_trans::type_id::create("req");
   req.constraint_mode(0);
   event_sb.trigger();
    //Resetting
	begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Setting control register
	begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Loading the counter wdogload
      begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
     
      //eve.wait_trigger();
        $display($time,"===========TRIGGERED EVENT=========");

//Reading control register
	begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b0;
					     paddr==24'h 2;
					     
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end


//Clearing the interrupt to supress the event
begin
	      //req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b1;
	req.enb_callback=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3;
					     pwdata==32'hFFFFF;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
 
endtask

//=====================================================================================//
// T.C. 9 :Corrupting the PSEL in the mid of transaction using callback method
//=====================================================================================//

class apb_psel_cb extends master_sequence;
  `uvm_object_utils(apb_psel_cb) 
 
  uvm_event_pool eve_pool;

uvm_event eve;

   //****************************Methods*******************************    
  extern function new(string name="apb_psel_cb");
  extern task body();
endclass:apb_psel_cb
  
//****************************Constructor***************************
function apb_psel_cb :: new(string name="apb_psel_cb");
  super.new(name);
  	 eve_pool=new();
	 eve_pool=eve_pool.get_global_pool();
	 eve=eve_pool.get("Interrupt");

endfunction
  
//***********************apb_psel_cb*********************** 
task apb_psel_cb::body();
   req=master_trans::type_id::create("req");
   req.constraint_mode(0);
   event_sb.trigger();
    //Resetting
	begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Setting control register
	begin
	start_item(req);
	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Loading the counter wdogload
      begin
	start_item(req);
	req.presetn=1'b1;
	req.apb_callback=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
endtask

//=====================================================================================//
// T.C. 10 : RAL SEQUENCE WITHOUT ADAPTER .... Setting the desired value into the
// RAL model with set() method along with normal sequence and comparing  
//=====================================================================================//

class reg_sequence extends master_sequence;
	`uvm_object_utils(reg_sequence)
int data = 32'hBBB;

     uvm_status_e               status;
     uvm_reg_data_t             value;
function new(string name= "reg_sequence");
	super.new(name);
endfunction

task body();
     super.body();
     /*	req=master_trans::type_id::create("req");
   	 req.constraint_mode(0);
  	 event_sb.trigger();

	    req.presetn=1'b0;

	  start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b1;
                                  		paddr==32'h0;
						pwdata == 32'hbbb;
				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);*/

     	    //writting the 'BBB' value to the DUT 
 	    apb_rb.ld_reg.write(status,data,.parent(this));
	    
	    //setting the desired value to the RAL model
	    // apb_rb.ld_reg.set(32'hBBB);		//To set the desired value in RAL
	  	//To get the desired value in RAL
	   
	  //apb_rb.ld_reg.write(status,32'hFFF,.parent(this));
	  $display ($time, "TIME : \n"); 
	  apb_rb.ld_reg.read(status,.value(value),.parent(this));//Read() method will read data from DUT and write to the value reg,mirror reg,desired reg 
	  $display ($time, "TIME : \n"); 
	  //RAL registers. So to get the read values from RAL model we will have to use get() method.
	    value=apb_rb.ld_reg.get();	
	  
	
	    if(data!=value)
	    begin
		     $display("THE DESIRED VALUE ISsssssssssssssssssssssssssssssssssssssssssssssssssssss%0H %0H",data,value);
		    `uvm_fatal("SEQUENCE","******************Check failed in sequence********************")
		
	    end
	    else
		    `uvm_info("SEQUENCE","\n*******************Check passed in sequence********************",UVM_LOW)
					    $display("THE DESIRED VALUE IS %0H",data);


endtask
endclass

//=====================================================================================//
// T.C. 11 : RAL SEQUENCE WITH SETTING DESIRED VALUE & COMPARING BACKDOOR
// READ 
//=====================================================================================//

class seq_desire_front_comp extends master_sequence;
	`uvm_object_utils(seq_desire_front_comp)
	
     int data;
     uvm_status_e               status;
     uvm_reg_data_t             value;
function new(string name= "seq_desire_front_comp");
	super.new(name);
endfunction

task body();
     super.body();
     		
		    
	   // apb_rb.ld_reg.set(32'hBBB);		//To set the desired value
	    	   
	  apb_rb.ld_reg.write(status,32'hBBB,.parent(this)); //Physical write to DUT and write to the value reg,mirror reg,desired reg 
	  //RAL registers. So to get the read values from RAL model we will have to use get() method.
	
	  data = apb_rb.ld_reg.get();		//To get the desired value

	  apb_rb.ld_reg.peek(status,value,.parent(this));      //Backdoor read

	  if(data!=value)
	  begin
	
      		  `uvm_error("\nSEQUENCE","******************Check failed in sequence********************")
		  $display("\nTHE DESIRED VALUE IS %0H",data);
		  $display("\nTHE FRONTDOOR VALUE IS %0H",value);

	  end
	    else
	    begin
		    `uvm_info("SEQUENCE","\n*******************Check passed in sequence********************",UVM_LOW)
					    $display("THE DESIRED VALUE IS %0H",value);
	    end
  endtask
  endclass
	    
//=====================================================================================//
// T.C. 12 : RAL SEQUENCE WITH SETTING UPDATE AND MIRROR
//=====================================================================================//

class seq_desire_mirror extends master_sequence;
	`uvm_object_utils(seq_desire_mirror)
	
     int data;
     uvm_status_e               status;
     uvm_reg_data_t             value;
function new(string name= "seq_desire_mirror");
	super.new(name);
endfunction

task body();
     super.body();
     		
		    
	   	    	    
	    apb_rb.ld_reg.predict(32'hCAA,.path(UVM_BACKDOOR));//This method will set 'CAA' value to the RAL mirror reg,value reg,desired reg. 
	     apb_rb.ld_reg.set(32'hCAA);		//To set the desired value

	    data = apb_rb.ld_reg.get();		//To get the desired value
	    $display("The RAL register value is=%0h",data);

	    apb_rb.ld_reg.write(status,32'hCAA,.parent(this)); //writes desired value(which is set by set() method) to DUT
	    //update method will call internally write() method
	    //apb_rb.ld_reg.update(status,(UVM_FRONTDOOR),.parent(this));// comment write method and uncomment the update method. so that you will get error for mirror method
	    //because it will compare internally
	   
	    
	    apb_rb.ld_reg.mirror(status, UVM_CHECK,(UVM_BACKDOOR), .parent(this));//This method first read value from DUT and it will compare with the 
	    //mirror value of RAL model. 
	    //mirror method will show error only if the DUT register value is not equal to the mirror register value of the RAL model.
	    //It won't show any message in the transcript if both values of registers are equal.
  endtask

  endclass

//=====================================================================================//
// T.C. 14 : ARBITRATION and PRIORITY
//=====================================================================================//
typedef class master_sequencer;
class apb_arb extends uvm_sequence#(master_trans);
	`uvm_object_utils(apb_arb)

    `uvm_declare_p_sequencer(master_sequencer)	

	apb_read_default_values seq1;
	apb_wr_rd_values seq2;
	apb_intrpt_rst seq3;

	function new(string name= "apb_arb");
		super.new(name);
	endfunction

	task body();
     		super.body();
		seq1=apb_read_default_values::type_id::create("seq1");

		seq2=apb_wr_rd_values::type_id::create("seq2");
		
		seq3=apb_intrpt_rst::type_id::create("seq3");
	
		//p_sequencer.set_arbitration(SEQ_ARB_FIFO);
		//p_sequencer.set_arbitration(SEQ_ARB_WEIGHTED);
		//p_sequencer.set_arbitration(SEQ_ARB_RANDOM);

		//p_sequencer.set_arbitration(SEQ_ARB_STRICT_RANDOM);
		p_sequencer.set_arbitration(SEQ_ARB_STRICT_FIFO);
		//p_sequencer.set_arbitration(SEQ_ARB_USER); //priority
		fork
			seq1.start(p_sequencer,this,2);
			seq2.start(p_sequencer,this,3);
			seq3.start(p_sequencer,this,1);
		join
     		
	endtask

  endclass

//==================================================================//
// T.C. 16 :phases
//==================================================================//
/*class apb_reset extends master_sequence;
  `uvm_object_utils(apb_reset) 
 
//****************************Methods*******************************    
  extern function new(string name="apb_reset");
  extern task body();
endclass:apb_reset
  
//****************************Constructor***************************
function apb_reset :: new(string name="apb_reset");
	super.new(name);
endfunction
  
//***********************apb_intrpt_rst*********************** 
task apb_reset::body();
   req=master_trans::type_id::create("req");
   req.constraint_mode(0);
   event_sb.trigger();
       begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;    
        finish_item(req);
      end
      begin
	req.constraint_mode(0);
	start_item(req);
	req.presetn=1'b0;    
        finish_item(req);
      end
     
endtask*/
class apb_default extends master_sequence;
  `uvm_object_utils(apb_default) 
//****************************Methods*******************************    
  extern function new(string name="apb_default");
  extern task body();
endclass:apb_default
  
//****************************Constructor***************************
function apb_default :: new(string name="apb_default");
  super.new(name);
endfunction
  
//***********************apb_read_default_values*********************** 
task apb_default::body();
   req=master_trans::type_id::create("req");
      begin
	      for(int j=0;j<10;j++)
	 	begin
	     	start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b0;
                                  		paddr==  q[j];

				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    

	  
            finish_item(req);

	  end

      end

endtask

class apb_reload extends master_sequence;
  `uvm_object_utils(apb_reload) 
 
//****************************Methods*******************************    
  extern function new(string name="apb_reload");
  extern task body();
endclass:apb_reload
  
//****************************Constructor***************************
function apb_reload :: new(string name="apb_reload");
	super.new(name);
endfunction
  
//***********************apb_intrpt_rst*********************** 
task apb_reload::body();
   req=master_trans::type_id::create("req");
   req.constraint_mode(0);
   event_sb.trigger();
       begin
	req.constraint_mode(0);
	start_item(req);
	//req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'hD;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
     
endtask

class apb_phase extends master_sequence;
  `uvm_object_utils(apb_phase) 
 
  uvm_event_pool eve_pool;

uvm_event eve;

   //****************************Methods*******************************    
  extern function new(string name="apb_phase");
  extern task body();
endclass:apb_phase
  
//****************************Constructor***************************
function apb_phase :: new(string name="apb_phase");
  super.new(name);
  	 eve_pool=new();
	 eve_pool=eve_pool.get_global_pool();
	 eve=eve_pool.get("Interrupt");

endfunction
  
//***********************apb_intrpt_rst*********************** 
task apb_phase::body();
   req=master_trans::type_id::create("req");
   req.constraint_mode(0);
   event_sb.trigger();
    //Resetting
	begin
	req.constraint_mode(0);
	start_item(req);
	//req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
       begin
	      for(int j=0;j<10;j++)
	 	begin
	     	start_item(req);
                   assert(req.randomize() with {
			   			psel==1'b1;
                                  		pwrite==1'b0;
                                  		paddr==  q[j];

				  		})
           `uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    

	  
            finish_item(req);

	  end

      end

begin
	req.constraint_mode(0);
	start_item(req);
	//req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'hD;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

      begin
	req.constraint_mode(0);
	start_item(req);
	//req.presetn=1'b0;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 0;
					     pwdata==32'h 0;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Setting control register
	begin
	      //req.constraint_mode(0);
	start_item(req);
	//req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h 2;
					     pwdata==4'h 3;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end

  //Loading the counter wdogload
      begin
	      //req.constraint_mode(0);
	start_item(req);
	//req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==32'b0;
					     pwdata==32'hA;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
     	$display($time,"HELLO THIS IS BEFORE THE INTERRUPT");
     	eve.trigger();
        $display($time,"INTERRUPT TRIGGERED AFTER THE EVENT");

//Clearing the interrupt to supress the event
begin
	      //req.constraint_mode(0);
	start_item(req);
//	req.presetn=1'b1;
		assert(req.randomize() with {psel==1'b1;
					     pwrite==1'b1;
					     paddr==24'h3;
					     pwdata==32'hFFFFF;
					     })
`uvm_info("MASTER SEQUENCE",$sformatf("\nPrinting From Master Sequence",req.sprint()),UVM_LOW)    
            finish_item(req);
      end
endtask

  
