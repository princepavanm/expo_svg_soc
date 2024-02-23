class reg_sequence extends uvm_reg_sequence;
	`uvm_object_utils(reg_sequence)


apb_reg_block apb_rb;

bit a=0,b=1,c=1,d=1;
bit w=1,x=1,y=1,z=1;
  


uvm_status_e status;
uvm_reg_data_t value;

	function new(string name= "reg_sequene");
		super.new(name);
		  //create a new pool with given name

	endfunction

	virtual task body ();


	$cast(apb_rb,model);

	//back-door writes
//	 poke_reg(apb_rb.ld_reg,status,{a,b,c,d});

	 //back-door reads
//	 peek_reg(apb_rb.ld_reg,status,value);
$display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>BACKDOOR READ=%0d>>>>>>>>>>>>>>>>>>>",value);
	 //front door
	apb_rb.ld_reg.write(status,32'hFFFFF,.parent(this));

	 //read(apb_rb.ld_reg,status,value);

 endtask
 endclass
