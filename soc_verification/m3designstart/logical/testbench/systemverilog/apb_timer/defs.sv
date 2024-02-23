//////----TIMEOUT for PREADY signal----///////
`define TIMEOUT 5

//////----REGISTER ADDRESS VALUES----/////////////////
`define CTRL_ADDR 10'h000
`define VALUE_ADDR 10'h001
`define RELOAD_ADDR 10'h002
`define INTSTATUS_ADDR 10'h003

`define RESET_1 10'h004
`define RESET_2 10'h008
`define RESET_3 10'h00C
`define RESET_4 10'h000
//////----PID & CID ADDRESESS----/////////
`define PID4 10'h3f4  
`define PID5 10'h3f5
`define PID6 10'h3f6
`define PID7 10'h3f7
`define PID0 10'h3f8
`define PID1 10'h3f9
`define PID2 10'h3fa
`define PID3 10'h3fb
`define CID0 10'h3fc
`define CID1 10'h3fd
`define CID2 10'h3fe
`define CID3 10'h3ff
/////----PID&CID DEFAULT DATA----//////
`define PID4_DATA 32'h004  
`define PID5_DATA 32'h000
`define PID6_DATA 32'h000
`define PID7_DATA 32'h000
`define PID0_DATA 32'h022
`define PID1_DATA 32'h0b8
`define PID2_DATA 32'h01b
`define PID3_DATA 32'h000
`define CID0_DATA 32'h00d
`define CID1_DATA 32'h0f0
`define CID2_DATA 32'h005
`define CID3_DATA 32'h0b1

//////----REGISTER DATA VALUES----/////////////////
`define CTRL_DATA 32'hb
`define VALUE_DATA 32'h100
`define RELOAD_DATA 32'hff
`define INTSTATUS_DATA 32'h001
`define INTSTATUS_DATA_1 32'h000
`define CTRL_DATA_EXTIN_AS_CLK 32'hd


