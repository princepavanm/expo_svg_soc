//#######################################################################
//		Author name = Meghana B N
//		File name   = Watchdog_test
//		Date        = 19-sept-2019
//#######################################################################

#include "CM3DS_MPS2.h"   // to include watchdog registers
#include <stdio.h>        // std lib file
#include "uart_stdout.h"  // to print messages
/* Macros for word access to address */
//#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))


void wdog_load_reg_check(void);
int wdog_int_check(void);
void wdog_rst_check(void);


volatile unsigned int int_occured = 0;

//  start of main code
int main(void)
{
 
  // UART init
  UartStdOutInit();
 
  puts("WDOG LOAD REG TEST");
  wdog_load_reg_check();
 // wdog_int_check();
//  wdog_rst_check();
  /*if(int_occured == 1){
	  wdog_rst_check();
	  puts("INTERRUPT OCCURED");
  }
  else {
	  puts("INTERRUPT CLEARED");
  }*/

/*  if(wdog_int_check() == 1){
	  puts("INTERRUPT OCCURED");
  }
//  else 
//	  puts("NO INTERRUPT");
 else {
	  wdog_rst_check();
 }
*/

  UartEndSimulation(); 
  /* Simulation stops in UartEndSimulation */
}


void wdog_load_reg_check(void)
{
	unsigned int i;
	unsigned int read_val;
	unsigned int read_current;
	for (i=0;i<6;i++) {
	CM3DS_MPS2_WATCHDOG->LOAD = 0x10+i;
	read_val=CM3DS_MPS2_WATCHDOG->LOAD;
	read_current=CM3DS_MPS2_WATCHDOG->VALUE;
	printf("read_current=%d\n",CM3DS_MPS2_WATCHDOG->VALUE);
	puts("END OF WDOG LOAD TEST");
	}
}

/*int wdog_int_check(void)
{
	//int_occured = 0;
	CM3DS_MPS2_WATCHDOG->CTRL = 0x01;
	//CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk;
	int_occured = 1;
	//CM3DS_MPS2_WATCHDOG->CTRL =  0x11;
  //UartEndSimulation(); 
//	return 1;
}


void wdog_rst_check(void)
{
//	if(int_occured ==1){
	CM3DS_MPS2_WATCHDOG->INTCLR =  0x50;
//	}
	UartEndSimulation;
	//CM3DS_MPS2_Watchdog_CTRL_RESEN_Msk|CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk;
}*/
	
	


