typedef class apb_driver;

class driver_callback extends uvm_callback;

function new(string name = "driver_callback");
super.new(name);
endfunction

virtual task inject_err(apb_driver drv, apb_xtn trans);
$display("=========ENTERED CALLBACK===============");

#10;
trans.addr=1;
trans.wdata=20;

endtask
endclass
