 /**********************************************************
 Author:     	Kalmeshwar S Chougala
 Class:     	define values
 Filename:   	define.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

//********************************************************
`define DATA_MASK 16'h ff
//register adress

`define CLOCK12 41.6ns
`define DATA_REG 10'h0 
`define STATUS_REG_PADD 10'h1
`define CONTROL_REG_PADD 10'h2
`define INTSTATUS_INTCLEAR 10'h3
`define BAUDDIV_REG_PADD 10'h4
`define PID_REG_READ 10'h3F4


`define BUADCOUNT 864
// data to the particular register

`define DATA 8'b10101010
`define DATA2 8'b11001100
`define BAUDDIVE 16'h4E // (127-1200x)(138-2400x)(9C-4800)(4E-9600)(27-19200)(13-38400)(D-57600x)(6-115200) x-indidcate the will not work (bauddiv - Baudrate)
`define CONTROL 7'h15 
`define STATUS  4'h1
`define INTERRUPT 4'h2
`define CONTROL_RX 7'h2A        
//**********************************************************

//**********************************************************
//Defult value

//Registers
`define DATA_R 1'b0
`define STATE_R 1'b0
`define CTRL_R 1'b0
`define INT_R 1'b0
`define BAUDDIV_R 1'b0

//PID registers
`define PID4_R 4'h4
`define PID5_R 1'b0
`define PID6_R 1'b0
`define PID7_R 1'b0
`define PID0_R 8'h21
`define PID1_R 8'hb8
`define PID2_R 8'h1b
`define PID3_R 8'h00


//CID registers
`define CID0_R 8'h0d
`define CID1_R 8'hf0
`define CID2_R 8'h05
`define CID3_R 8'hb1

//Extra register

`define EXT 1'b0







