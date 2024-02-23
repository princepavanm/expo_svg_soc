class reg_adapter extends uvm_reg_adapter;
	`uvm_object_utils(reg_adapter)

	function new(string name = "reg_adapter");
		super.new(name);

		supports_byte_enable =0;
		provides_responses = 0;
	endfunction

virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
	master_trans trans = master_trans::type_id::create("trans");
	
	if(rw.kind == UVM_WRITE) begin
	trans.pwrite = (rw.kind == UVM_WRITE) ? UVM_WRITE: UVM_READ;
	trans.paddr = rw.addr;
	trans.pwdata = rw.data;
	trans.penable=1'b1;
	trans.presetn=1'b0;
	trans.psel=1'b1;
	`uvm_info("REG2BUS_W",$sformatf("adapter reg2bus write access addr=%0h, data=%0h \n %s", rw.addr, rw.data,trans.sprint()),UVM_LOW)

end
else if(rw.kind == UVM_READ) begin

	trans.pwrite=1'b0;
	trans.paddr=rw.addr;
	trans.penable=1'b1;
	trans.presetn=1'b0;
	trans.psel=1'b1;
	trans.prdata=rw.data;
	`uvm_info("REG2BUS_R",$sformatf("adapter reg2bus read access addr=%0h, data=%0h \n %s", rw.addr, rw.data, trans.sprint()),UVM_LOW)

end

return trans;
endfunction



virtual function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
master_trans trans;

if(!$cast(trans,bus_item)) begin 
	`uvm_fatal("APB_ADAPTER", "cast failed in the adapter" );
	return;
end

rw.kind = trans.pwrite ? UVM_WRITE :UVM_READ;

if(rw.kind == UVM_WRITE && (trans.paddr == 0 || trans.paddr == 2)) begin
	rw.addr = trans.paddr;
	rw.data = trans.pwdata;
	`uvm_info("BUS2REG_W",$sformatf("adapter bus2reg write access addr=%0h, data=%0h \n %s", rw.addr, rw.data, trans.sprint()),UVM_LOW)

end
//else if(rw.kind == UVM_READ && trans.pwdata==32'hBBB) begin 
  else if(rw.kind == UVM_READ && (trans.paddr == 0 || trans.paddr == 2)) begin 
	rw.addr = trans.paddr;
	rw.data = trans.prdata;
	`uvm_info("BUS2REG_R",$sformatf("adapter bus2reg read access addr=%0h, data=%0h \n %s", rw.addr, rw.data, trans.sprint()),UVM_LOW)

end
rw.status = UVM_IS_OK;

endfunction
endclass

