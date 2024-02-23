interface reset_if(input bit pclk);

	/////------Declaring apb interface signals------/////
	logic PRESETn;

	/////------Declaring clocking block for reset driver------/////
	clocking reset_driver_cb@(posedge pclk);
		output PRESETn;
	endclocking

	/////------Declaring modport for apb driver------/////
 	modport RESET_DRIVER(clocking reset_driver_cb);
    
endinterface
