/**********************************************************
 Author:     	Kalmeshwar S Chougala
 Module:     	Included all files
 Filename:   	test_pkg.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/

//package test;

`include "uvm_macros.svh"

`include "apb_reset_seq_test.sv"
`include "apb_write_read_check_test.sv"
`include "TX_test.sv"
`include "RX_test.sv"
`include "Multi_Tx_test.sv"
`include "Multi_Rx_test.sv"
`include "Tx_Rx_test.sv"
`include "Over_Rx_test.sv"
`include "Over_Tx_test.sv"
`include "TX_test_cb.sv"
`include "reg_seq_test.sv"
//endpackage
