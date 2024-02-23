//************************************************************************************
//			Author name  : Meghana B N
//			project name : APB_UART
//			file name    : adapter
//			Start date   : 9-9-2019
//			Finish date  : 9-9-2019
//************************************************************************************
class reg_adapter extends uvm_reg_adapter;
	`uvm_object_utils(reg_adapter)

	function new(string name = "reg_adapter");
		super.new(name);

		supports_byte_enable =0;
		provides_responses = 0;
	endfunction

virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
	apb_xtn trans = apb_xtn::type_id::create("trans");
	
	if(rw.kind == UVM_WRITE) begin
	trans.trans_type = (rw.kind == UVM_WRITE) ? UVM_WRITE: UVM_READ;
	trans.addr = rw.addr;
	trans.wdata = rw.data;
	trans.enable=1'b1;
	//trans.presetn=1'b1;
	trans.sel=1'b1;	
	`uvm_info("REG2BUS_W",$sformatf("adapter reg2bus write access addr=%0h, data=%0h \n %s", rw.addr, rw.data,trans.sprint()),UVM_LOW)

end
else if(rw.kind == UVM_READ) begin

	trans.trans_type=1'b0;
	trans.addr=rw.addr;
	trans.enable=1'b1;
	//trans.presetn=1'b1;
	trans.sel=1'b1;
	trans.rdata=rw.data;
		`uvm_info("REG2BUS_R",$sformatf("adapter reg2bus read access addr=%0h, data=%0h \n %s", rw.addr, rw.data, trans.sprint()),UVM_LOW)


end

return trans;
endfunction



virtual function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
	apb_xtn trans;

if(!$cast(trans,bus_item)) begin 
	`uvm_fatal("APB_ADAPTER", "cast failed in the adapter" );
	return;
end

rw.kind = trans.trans_type ? UVM_WRITE :UVM_READ;

if(rw.kind == UVM_WRITE ) begin
	rw.addr = trans.addr;
	rw.data = trans.wdata;
		`uvm_info("BUS2REG_W",$sformatf("adapter bus2reg write access addr=%0h, data=%0h \n %s", rw.addr, rw.data, trans.sprint()),UVM_LOW)


end
else if(rw.kind == UVM_READ ) begin 
	rw.addr = trans.addr;
	rw.data = trans.rdata;
	`uvm_info("BUS2REG_R",$sformatf("adapter bus2reg read access addr=%0h, data=%0h \n %s", rw.addr, rw.data, trans.sprint()),UVM_LOW)

	$display("##########################rdata=%0h",trans.rdata);

end
rw.status = UVM_IS_OK;

endfunction
endclass

