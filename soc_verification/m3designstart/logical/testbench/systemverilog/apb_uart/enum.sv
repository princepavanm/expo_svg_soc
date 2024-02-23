 /**********************************************************
 Author:     	Kalmeshwar S Chougala
 Module:     	--------
 Filename:   	enum.sv
 Start Date: 	28/10/2017
 Finish Date:
**********************************************************/


//PWRITE= 0 or 1 is replaced by Read and write
typedef enum{read,write}state;


//Buaddiv value with respect to buadrate inidication
typedef enum{b9600=32'h4E,b19200=32'h27,b38400=32'h13}buarddiv;
