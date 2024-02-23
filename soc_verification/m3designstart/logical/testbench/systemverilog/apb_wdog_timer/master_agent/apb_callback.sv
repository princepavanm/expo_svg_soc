typedef class master_driver;
class driver_callback extends uvm_callback;

function new (string name = "driver_callback");
	super.new(name);
endfunction

//static string type_name= "driver_callback";

virtual task inject_err(master_driver driver_h, master_trans trans);
$display("====================ENTERED CALLBACK===========================");
#90;
trans.paddr=24'h0;
trans.pwdata=32'h20;
endtask

virtual task inject_apb_err(master_driver driver_h, master_trans trans);
$display("====================ENTERED CALLBACK===========================");
trans.psel='b0;
endtask

endclass


