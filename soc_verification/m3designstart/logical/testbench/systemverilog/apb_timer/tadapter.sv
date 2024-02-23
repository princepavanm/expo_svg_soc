////////////////////////////////////////////////////////////
//Filename     : adapter.sv
//start date   : 31/07/2019 
////////////////////////////////////////////////////////////

class apb_adapter extends uvm_reg_adapter;
	`uvm_object_utils(apb_adapter)
	
	function new(string name="apb_adapter");
		super.new(name);
		supports_byte_enable=0;
		provides_responses=0;
	endfunction


//This function accepts a register item of type "uvm_reg_bus_op" and assigns address,data and other required fields to the bus protocol sequence_item
	virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
      		
		apb_txn txn = apb_txn::type_id::create ("txn");
     		
		if(rw.kind == UVM_WRITE)
		begin
			txn.psel    = 1'b1;
                        txn.penable = 1'b1;
			txn.pwrite  = rw.kind;
	      		txn.paddr   = rw.addr;
	      		txn.pwdata  = rw.data;
      			`uvm_info ("REG2BUS_W", $sformatf ("reg2bus write paddr=0x%0h pwdata=0x%0h pwrite(kind)=%s", txn.paddr, txn.pwdata, rw.kind.name), UVM_DEBUG) 
		end
		else if(rw.kind == UVM_READ)
		begin
			txn.psel    = 1'b1;
                        txn.penable = 1'b1;
			txn.pwrite  = rw.kind;
	      		txn.paddr   = rw.addr;
	      	//	txn.pwdata  = rw.data;
      			`uvm_info ("REG2BUS_R", $sformatf ("reg2bus read paddr=0x%0h pwdata=0x%0h pwrite(kind)=%s", txn.paddr, txn.pwdata, rw.kind.name), UVM_DEBUG) 
		end
      		return txn; 
	   	
	endfunction


//This function accepts a bus sequence_item and assigns address/data fields to the register item
	virtual function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
	apb_txn txn;

	if(!$cast(txn,bus_item))
       	begin 
		`uvm_fatal("APB_ADAPTER", "cast failed in the adapter");
	return;
	end

	rw.kind = txn.pwrite ? UVM_WRITE:UVM_READ;

	if(rw.kind == UVM_WRITE)
       	begin
		rw.addr = txn.paddr;
		rw.data = txn.pwdata;
		`uvm_info("BUS2REG_W",$sformatf("bus2reg write >>> paddr=0x%0h pwdata=0x%0h pwrite(kind)=%s",txn.paddr,txn.pwdata,rw.kind.name),UVM_LOW)
	end
	else if(rw.kind == UVM_READ)// && txn.pwdata==32'hBBB)
	begin 
		rw.addr = txn.paddr;
		rw.data = txn.prdata;
		`uvm_info("BUS2REG_R",$sformatf("bus2reg read >>> paddr=0x%0h pwdata=0x%0h pwrite(kind)=%s",txn.paddr,txn.pwdata,rw.kind.name),UVM_LOW)

	end
	rw.status = UVM_IS_OK;

endfunction

endclass
