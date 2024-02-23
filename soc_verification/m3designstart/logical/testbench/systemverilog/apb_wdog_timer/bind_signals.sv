
module bind_signals;

bind cmsdk_apb_watchdog apb_assertions ASSERTIONS(.clk(PCLK),.resetn(PRESETn),.enable(PENABLE),.sel(PSEL),.addr(PADDR),.write(PWRITE), .wdata(PWDATA), .dogclk(WDOGCLK), 
				    .dogclken(WDOGCLKEN), .dogresn(WDOGRESn),.ecr(ECOREVNUM), .rdata(PRDATA),.dogint(WDOGINT),.dogres(WDOGRES));
endmodule
