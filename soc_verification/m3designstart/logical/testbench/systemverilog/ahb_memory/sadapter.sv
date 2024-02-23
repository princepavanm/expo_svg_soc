class reg_adapter extends uvm_reg_adapter;
	`uvm_object_utils(reg_adapter)

	function new(string name = "reg_adapter");
		super.new(name);

		supports_byte_enable =1;
		provides_responses = 0;
	endfunction

virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
	master_AHB_xtn trans = master_AHB_xtn::type_id::create("trans");
	
	if(rw.kind == UVM_WRITE) begin
	trans.hwrite = (rw.kind == UVM_WRITE) ? UVM_WRITE: UVM_READ;
	trans.haddr = rw.addr;
	trans.hwdata = rw.data;
	trans.htrans=2'b10;
	//trans.hresetn=1'b0;
	trans.hsel=1'b1;
	if (rw.n_bits == 8) 
	  trans.hsize=0;
        else if (rw.n_bits == 16) 
	  trans.hsize=1;
        else if (rw.n_bits == 32) 
	  trans.hsize=2;
	trans.hready=1'b1;
	`uvm_info("MEM_REG2BUS_W",$sformatf("adapter  write access addr=%0h, wdata=%0h, \n %s", 	trans.haddr,trans.hwdata,trans.sprint()),UVM_LOW)

end
else if(rw.kind == UVM_READ) begin

	trans.hwrite=1'b0;
	trans.haddr=rw.addr;
	trans.htrans=2'b10;
	//trans.hresetn=1'b0;
	trans.hsel=1'b1;
	if (rw.n_bits == 8) 
	  trans.hsize=0;
        else if (rw.n_bits == 16) 
	  trans.hsize=1;
        else if (rw.n_bits == 32) 
	  trans.hsize=2;

	trans.hrdata=rw.data;
	trans.hready=1'b1;
	`uvm_info("MEM_REG2BUS_R",$sformatf("adapter read access addr=%0h, rdata=%0h\n %s", trans.haddr,trans.hrdata, trans.sprint()),UVM_LOW)

end

return trans;
endfunction



virtual function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
master_AHB_xtn trans;

if(!$cast(trans,bus_item)) begin 
	`uvm_fatal("APB_ADAPTER", "cast failed in the adapter" );
	return;
end

rw.kind = trans.hwrite ? UVM_WRITE :UVM_READ;

if(rw.kind == UVM_WRITE) begin
	rw.addr = trans.haddr;
	rw.data = trans.hwdata;
	`uvm_info("MEM_BUS2REG_W",$sformatf("adapter bus2reg write access addr=%0h, wdata=%0h\n %s", rw.addr,rw.data, trans.sprint()),UVM_LOW)


end
else if(rw.kind == UVM_READ) begin 
	rw.addr = trans.haddr;
	rw.data = trans.hrdata;
	`uvm_info("MEM_BUS2REG_R",$sformatf("adapter bus2reg read access addr=%0h, rdata=%0h\n %s", rw.addr,trans.hrdata,trans.sprint()),UVM_LOW)

end
rw.status = UVM_IS_OK;

endfunction
endclass
