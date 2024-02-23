interface reset_if(input bit pclk,input bit wdogclk);

	/////------Declaring apb interface signals------/////
	logic presetn;
	logic wdogresn;

	/////------Declaring clocking block for reset driver------/////
	clocking reset_driver_cb@(posedge pclk,posedge wdogclk);
		output presetn;
		output wdogresn;
	endclocking

	/////------Declaring modport for apb driver------/////
 	modport RESET_DRIVER(clocking reset_driver_cb);
    
endinterface
