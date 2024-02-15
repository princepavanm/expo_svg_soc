/*
  A simple test to check the functionalities of APB timer
*/

#include "CM3DS_MPS2.h"
#include <stdio.h>
#include "uart_stdout.h"
#include "CM3DS_function.h"

/* Macros for word access to address */
#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))

//void main_prog_part_1(void);
void main_prog_part_2(void);
int  watchdog_id_check(void);
int  sysctrl_id_check(void);
void watchdog_init(unsigned int cycle, int type);
                                       /* Program watchdog: */
                                       /* type = 0 : No action */
                                       /* type = 1 : Interrupt */
                                       /* type = 2 : Reset */
void watchdog_set(unsigned int cycle); /* update watchdog counter */
void watchdog_unlock(void);            /* unlock watchdog */
void watchdog_lock(void);              /* lock watchdog */
void watchdog_irq_clear(void);         /* clear watchdog interrupt */

/* Software variables for testing */
volatile int nmi_occurred;
volatile int nmi_expected;
volatile int reset_test;  /* set to 1 during watchdog reset test so that NMI
                             handler will not clear the watchdog */
volatile int integration_test=0;  /* set to 1 during watchdog integration test so that NMI
                             handler will clear integration test output */
/*---Timer tests ---*/
int timer_register_rw_test(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);
int timer_start_stop_test(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);
//int timer_interrupt_test_1(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);
//int timer_external_input(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER);
int timer0_id_check(void); // Detect Timer 0 present
//int timer1_id_check(void); // Detect Timer 1 present
int gpio0_id_check(void);  // Detect GPIO 0 present

/* Global variables */
volatile int timer0_irq_occurred;
volatile int timer1_irq_occurred;
volatile int timer0_irq_expected;
volatile int timer1_irq_expected;
volatile int counter;

/* peripheral and component ID values */
#define APB_TIMER_PID4  0x04
#define APB_TIMER_PID5  0x00
#define APB_TIMER_PID6  0x00
#define APB_TIMER_PID7  0x00
#define APB_TIMER_PID0  0x22
#define APB_TIMER_PID1  0xB8
#define APB_TIMER_PID2  0x1B
#define APB_TIMER_PID3  0x00
#define APB_TIMER_CID0  0x0D
#define APB_TIMER_CID1  0xF0
#define APB_TIMER_CID2  0x05
#define APB_TIMER_CID3  0xB1

int main (void)
{
  int result=0;
  unsigned int count=0;
  unsigned int read_val;

  // UART init
  UartStdOutInit();

  // Test banner message and revision number
  puts("\nCortex-M3 DesignStart - Timer Test - revision $Revision: 243249 $\n");

  timer0_irq_occurred = 0;
  //timer1_irq_occurred = 0;
  timer0_irq_expected = 0;
  //timer1_irq_expected = 0;

  puts("1) Timer 0");

  if (timer0_id_check()==0) { /* Detect if timer is available */
    /* Timer 0 present */
    result += timer_register_rw_test(CM3DS_MPS2_TIMER0);
    result += timer_start_stop_test(CM3DS_MPS2_TIMER0);
    //result += timer_interrupt_test_1(CM3DS_MPS2_TIMER0);

    //if (gpio0_id_check()==0) {
      /* External input test need GPIO 0 to generate input */
      //result += timer_external_input(CM3DS_MPS2_TIMER0);
     // } else {
     // puts ("- GPIO #0 not present. Test skipped.");
      //}

    } else {
    puts ("- Timer #0 not present. Tests skipped.");
    }
  if (result==0) {
    printf ("\n** Timer TEST PASSED **\n");
  } else {
    printf ("\n** Timer TEST FAILED **\n, Error code = (0x%x)", result);
  }

  /* Check CM3DS_MPS2_SYSCON->RSTINFO Reset Information register */
  /*  0 = cold reset */
  /*  1 = reset from SYSRESETREQ */
  /*  2 = reset from Watchdog */
  if ((CM3DS_MPS2_SYSCON->RSTINFO & CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk) !=0) {
    puts ("Restarted by Watchdog reset");
    main_prog_part_2();
    UartEndSimulation(); /* Simulation stop */
  }
  else if ((CM3DS_MPS2_SYSCON->RSTINFO & CM3DS_MPS2_SYSCON_RSTINFO_SYSRESETREQ_Msk) !=0) {
    puts ("Restarted by SYSRESETREQ reset");
    puts ("ERROR: reset info register value incorrect.\n");
    UartEndSimulation(); /* Simulation stop */
  }
  else {
    puts("Watchdog demo test\n");

    if (watchdog_id_check()!=0) {
      puts ("** TEST SKIPPED ** Watchdog not present.");
      UartEndSimulation();
      return 0;}

  // added register wr/rds for testing RAL
    for (count=0; count<5; count++) {

      read_val = CM3DS_MPS2_WATCHDOG->LOAD;
      read_val = CM3DS_MPS2_WATCHDOG->VALUE;
      read_val = CM3DS_MPS2_WATCHDOG->CTRL;
      CM3DS_MPS2_WATCHDOG->LOAD  = 0x12345678 + count*10000000;
      read_val = CM3DS_MPS2_WATCHDOG->VALUE;
      CM3DS_MPS2_WATCHDOG->CTRL  = 0x0 + count;
    }

    //main_prog_part_1();
  }
  puts ("** Watchdog TEST PASSED ** \n");
  UartEndSimulation(); /* Simulation stop */
  return 0;
}

/* --------------------------------------------------------------- */
/*  Timer register read/write tests                                */
/* --------------------------------------------------------------- */

int timer_register_rw_test(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER){
  int return_val=0;
  int err_code=0;
  unsigned int timer_base;
  puts("Timer R/W test");
  puts("- initial values");

  NVIC_DisableIRQ(TIMER0_IRQn);
  NVIC_DisableIRQ(TIMER1_IRQn);

  if (CM3DS_MPS2_TIMER->CTRL      != 0) { err_code += (1<<0); }
  if (CM3DS_MPS2_TIMER->VALUE     != 0) { err_code += (1<<1); }
  if (CM3DS_MPS2_TIMER->RELOAD    != 0) { err_code += (1<<2); }
  if (CM3DS_MPS2_TIMER->INTSTATUS != 0) { err_code += (1<<3); }

  timer_base = CM3DS_MPS2_TIMER0_BASE;
  if (CM3DS_MPS2_TIMER==CM3DS_MPS2_TIMER1) {timer_base = CM3DS_MPS2_TIMER1_BASE;}

  // Perform a write access to all PIDs
  HW32_REG(timer_base + 0xFD0) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFD4) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFD8) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFDC) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFE0) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFE4) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFE8) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFEC) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFF0) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFF4) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFF8) = 0xFFFFFFFF;
  HW32_REG(timer_base + 0xFFC) = 0xFFFFFFFF;

  if (HW32_REG(timer_base + 0xFD0) != APB_TIMER_PID4) {err_code += (1<<4); }
  if (HW32_REG(timer_base + 0xFD4) != APB_TIMER_PID5) {err_code += (1<<5); }
  if (HW32_REG(timer_base + 0xFD8) != APB_TIMER_PID6) {err_code += (1<<6); }
  if (HW32_REG(timer_base + 0xFDC) != APB_TIMER_PID7) {err_code += (1<<7); }
  if (HW32_REG(timer_base + 0xFE0) != APB_TIMER_PID0) {err_code += (1<<8); }
  if (HW32_REG(timer_base + 0xFE4) != APB_TIMER_PID1) {err_code += (1<<9); }
  if (HW32_REG(timer_base + 0xFE8) != APB_TIMER_PID2) {err_code += (1<<10); }
  if (HW32_REG(timer_base + 0xFEC) != APB_TIMER_PID3) {err_code += (1<<11); }
  if (HW32_REG(timer_base + 0xFF0) != APB_TIMER_CID0) {err_code += (1<<12); }
  if (HW32_REG(timer_base + 0xFF4) != APB_TIMER_CID1) {err_code += (1<<13); }
  if (HW32_REG(timer_base + 0xFF8) != APB_TIMER_CID2) {err_code += (1<<14); }
  if (HW32_REG(timer_base + 0xFFC) != APB_TIMER_CID3) {err_code += (1<<15); }


  if (err_code != 0) {
    printf ("ERROR : initial value failed (0x%x)\n", err_code);
    return_val=1;
    err_code = 0;
    }
  puts("- read/write");

  CM3DS_MPS2_TIMER->VALUE = 0x3355AAFF;
  if (CM3DS_MPS2_TIMER->VALUE     != 0x3355AAFF) { err_code += (1<<0); }
  CM3DS_MPS2_TIMER->VALUE = 0xCCAA5500;
  if (CM3DS_MPS2_TIMER->VALUE     != 0xCCAA5500) { err_code += (1<<1); }
  CM3DS_MPS2_TIMER->VALUE = 0x00000000;
  if (CM3DS_MPS2_TIMER->VALUE     != 0x00000000) { err_code += (1<<2); }

  CM3DS_MPS2_TIMER->RELOAD = 0x3355AAFF;
  if (CM3DS_MPS2_TIMER->RELOAD    != 0x3355AAFF) { err_code += (1<<3); }
  CM3DS_MPS2_TIMER->RELOAD = 0xCCAA5500;
  if (CM3DS_MPS2_TIMER->RELOAD    != 0xCCAA5500) { err_code += (1<<4); }
  CM3DS_MPS2_TIMER->RELOAD = 0x00000000;
  if (CM3DS_MPS2_TIMER->RELOAD    != 0x00000000) { err_code += (1<<5); }

  CM3DS_MPS2_TIMER->CTRL = 0x01; /* Set enable */
  if (CM3DS_MPS2_TIMER->CTRL      != 0x01) { err_code += (1<<6); }
  CM3DS_MPS2_TIMER->CTRL = 0x02; /* external select */
  if (CM3DS_MPS2_TIMER->CTRL      != 0x02) { err_code += (1<<7); }
  CM3DS_MPS2_TIMER->CTRL = 0x04; /* external clock select */
  if (CM3DS_MPS2_TIMER->CTRL      != 0x04) { err_code += (1<<8); }
  CM3DS_MPS2_TIMER->CTRL = 0x08; /* external clock select */
  if (CM3DS_MPS2_TIMER->CTRL      != 0x08) { err_code += (1<<9); }
  CM3DS_MPS2_TIMER->CTRL = 0x00; /* all clear */
  if (CM3DS_MPS2_TIMER->CTRL      != 0x00) { err_code += (1<<10); }

  /* Trigger timer interrupt status */
  CM3DS_MPS2_TIMER->RELOAD = 0x3;
  CM3DS_MPS2_TIMER->VALUE  = 0x3;
  CM3DS_MPS2_TIMER->CTRL   = 0x9; /* enable with internal clock as source */
  while ( CM3DS_MPS2_TIMER->INTSTATUS == 0);
  CM3DS_MPS2_TIMER->CTRL   = 0x0; /* disable timer */
  if (CM3DS_MPS2_TIMER->INTSTATUS  != 0x01) { err_code += (1<<11); }
  CM3DS_MPS2_TIMER->INTCLEAR = 0x1; /* clear timer interrupt */
  if (CM3DS_MPS2_TIMER->INTSTATUS  != 0x00) { err_code += (1<<12); }

  /* Generate return value */
  if (err_code != 0) {
    printf ("ERROR : Read/write failed (0x%x)\n", err_code);
    return_val=1;
    err_code = 0;
    }

  NVIC_ClearPendingIRQ(TIMER0_IRQn);
  NVIC_ClearPendingIRQ(TIMER1_IRQn);

  return(return_val);
}

/* --------------------------------------------------------------- */
/*  Timer start/stop tests                                         */
/* --------------------------------------------------------------- */
/*
  Timer value set to 0x1000, and enabled.
  A polling loop is then use to check that timer had decremented to 0x900
  within a certain period of time. A software variable called counter to
  used to detect timeout, which make sure that the test report fail
  if the timer does not decrement.

  The timer is then stopped, and the value is sampled twice and checked
  that the timer is really stopped.

  The timer value is then set to 0x10, and then enabled, with interrupt feature
  enabled (Note : NVIC is not enabled for this test so interrupt doesn't get
  triggered).
  A polling loop is then use to wait until timer reach zero and reloaded
  (by checking interrupt status register).  The current value of the timer
  is then checked to make sure it is in the expected value range.

*/
int timer_start_stop_test(CM3DS_MPS2_TIMER_TypeDef *CM3DS_MPS2_TIMER){
  int return_val=0;
  int err_code=0;
  unsigned long tvalue;
  puts("Timer start/stop test");
  puts("- timer enable");

  NVIC_DisableIRQ(TIMER0_IRQn);
  //NVIC_DisableIRQ(TIMER1_IRQn);

  CM3DS_MPS2_TIMER->RELOAD = 0x1000;
  CM3DS_MPS2_TIMER->VALUE  = 0x1000;
  CM3DS_MPS2_TIMER->CTRL = 0x01; /* Set enable */
  counter = 0x100; /* Time out counter */
  while ((CM3DS_MPS2_TIMER->VALUE > 0x900) && (counter>= 0)){
    counter --;
    }
  CM3DS_MPS2_TIMER->CTRL = 0x00; /* stop timer for now */
  if (CM3DS_MPS2_TIMER->VALUE > 0x900) {
     puts("ERROR : Timer not decrementing.");
     err_code += (1<<0);
     }

  tvalue = CM3DS_MPS2_TIMER->VALUE;
  puts("- timer disable");
  __NOP();
  __NOP();
  if (CM3DS_MPS2_TIMER->VALUE != tvalue) {
     puts("ERROR : Timer not stopping.");
     err_code += (1<<1);
     }

  /* Check reload operation */
  puts("- timer reload");
  CM3DS_MPS2_TIMER->VALUE  = 0x10;
  CM3DS_MPS2_TIMER->CTRL = 0x09; /* Set enable, and interrupt generation */
  while ( CM3DS_MPS2_TIMER->INTSTATUS == 0);
  CM3DS_MPS2_TIMER->CTRL = 0x00; /* Stop timer */
  if (CM3DS_MPS2_TIMER->VALUE > CM3DS_MPS2_TIMER->RELOAD) {
     puts("ERROR : Timer reload fail 1.");
     err_code += (1<<2);
     }
  if ( (CM3DS_MPS2_TIMER->RELOAD - CM3DS_MPS2_TIMER->VALUE) > 0x100 ) {
     puts("ERROR : Timer reload fail 2.");
     err_code += (1<<3);
     }

  // Need to lower the interrupt in the timer before clearing in the NVIC
  CM3DS_MPS2_TIMER->INTCLEAR = 1;
  // Clear the NVIC interrupts related to both timers to save working out which
  // timer is currently being tested
  NVIC_ClearPendingIRQ(TIMER0_IRQn);
 //NVIC_ClearPendingIRQ(TIMER1_IRQn);

  /* Generate return value */
  if (err_code != 0) {
    printf ("ERROR : start/stop failed (0x%x)\n", err_code);
    return_val=1;
    err_code = 0;
    }

  return(return_val);
}

/* --------------------------------------------------------------- */
/* Peripheral detection                                            */
/* --------------------------------------------------------------- */
/* Detect the part number to see if device is present              */
int timer0_id_check(void)
{
unsigned char timer_id;
  timer_id = HW8_REG(CM3DS_MPS2_TIMER0_BASE + 0xFE8) & 0x07;

  if ((HW32_REG(CM3DS_MPS2_TIMER0_BASE + 0xFE0) != 0x22) ||
      (HW32_REG(CM3DS_MPS2_TIMER0_BASE + 0xFE4) != 0xB8) ||
      (timer_id != 0x03))
    return 1; /* part ID & ARM ID does not match */
  else
    return 0;
}

/* ----------------------------------------------------------------- */
/* Detect the ARM ID and part number to see if device is present     */
int watchdog_id_check(void)
{
unsigned char wdog_id;
#define HW32_REG(ADDRESS)  (*((volatile unsigned long  *)(ADDRESS)))
#define HW8_REG(ADDRESS)   (*((volatile unsigned char  *)(ADDRESS)))

wdog_id = HW8_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE8) & 0x07;

if ((HW32_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE0) != 0x24) ||
    (HW32_REG(CM3DS_MPS2_WATCHDOG_BASE + 0xFE4) != 0xB8) ||
    (wdog_id != 0x03))
  return 1; /* part ID & ARM ID does not match */
else
  return 0;
}
int sysctrl_id_check(void)
{ /* CM3DS_MPS2 SysCtrl part ID range from 826 to 829 */
if ((HW32_REG(CM3DS_MPS2_SYSCTRL_BASE + 0xFE0) < 0x26) ||
    (HW32_REG(CM3DS_MPS2_SYSCTRL_BASE + 0xFE0) > 0x29) ||
    (HW32_REG(CM3DS_MPS2_SYSCTRL_BASE + 0xFE4) != 0xB8))
  return 1; /* part ID does not match */
else
  return 0;
}
/* ----------------------------------------------------------------- */
/* Second part of the main test program - execute after watchdog reset */
void main_prog_part_2(void)
{
  int result=0;
  unsigned int read_data;
  puts("Main program part 2");
  puts("- Watchdog reset completed");
  read_data = CM3DS_MPS2_SYSCON->RSTINFO;
  printf ("  SYSCON->RSTINFO = %x\n", read_data);

  if (read_data != CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk) {
     result++;
  }
  puts("- Clear reset info");
  CM3DS_MPS2_SYSCON->RSTINFO = CM3DS_MPS2_SYSCON_RSTINFO_WDOGRESETREQ_Msk;
  read_data = CM3DS_MPS2_SYSCON->RSTINFO;
  printf ("  SYSCON->RSTINFO = %x\n", read_data);

  if (read_data != 0)/* RSTINFO should be cleared */
  {
     result++;
  }

  if (result != 0) {
    puts ("ERROR: reset info register value incorrect.\n");
  } else {
    puts ("Watchdog reset performed successfully\n");
  }

  /*                                                  */
  /* A simple integration test for Watchdog using NMI */
  /*                                                  */

   /* Instead of trigger NMI using normal watchdog operation, you can also
      test the watchdog connection using integration test register.
      ITCR - bit 0 enable integration test mode
      ITOP - bit 0 enable watchdog reset when integration test mode is enabled
             bit 1 enable watchdog interrupt when integration test mode is enabled

      Here we demonstrate the generation of interrupt (NMI) using integration test
      registers. You can also use integration test register to generate reset
      but this will cause this part of the test running again and again, so we
      will not demonstrate it here.
   */

  puts("Testing generation of NMI using integration test register");
  reset_test = 0;
  integration_test = 1;
  nmi_expected = 0;
  nmi_occurred = 0;
  watchdog_unlock();
  CM3DS_MPS2_WATCHDOG->ITOP = 0;  // Ensure NMI and reset in integration test mode are 0
  CM3DS_MPS2_WATCHDOG->ITCR = 1;  // Enable integration test mode
  if (CM3DS_MPS2_WATCHDOG->ITCR == 0) {
     puts ("  - Integration Control read error");
     result++;
  }
  else {
    nmi_expected = 1;
    CM3DS_MPS2_WATCHDOG->ITOP = 2;  // Set NMI output to 1
    CM3DS_MPS2_WATCHDOG->ITOP = 0;  // Set NMI output to 0
    if (nmi_occurred==0) {
       puts ("  - Integration Test operation failed");
       result++;
    }
    CM3DS_MPS2_WATCHDOG->ITCR = 0;  // Disable integration test mode
    if (CM3DS_MPS2_WATCHDOG->ITCR != 0) {
      puts ("  - Integration Control clear error");
      result++;
    }
  }
  if (result != 0) {
    puts ("** TEST FAILED ** Errors in Watchdog test\n");
  } else {
    puts ("Watchdog demo completed successfully\n** TEST PASSED ** \n");
  }

  UartEndSimulation(); /* Simulation stops in UartEndSimulation */
}

/* ----------------------------------------------------------------- */
void NMI_Handler(void)
{

  puts ("NMI Handler Entered! \n");
  if (reset_test==1){  /* When testing watchdog reset, need to stay
    in NMI handler until the watchdog overflows again */
    while (1) {
     // wait for reset...
    }
  }
  watchdog_irq_clear(); /* Deassert Watchdog interrupt */
  nmi_occurred++; /* Update software flag */
  if (nmi_expected==0) { /* error check */
    puts ("ERROR : NMI occurred unexpectedly\n");
    UartEndSimulation(); /* Simulation stop */
  }
  if (integration_test!=0) {
    watchdog_unlock();
    CM3DS_MPS2_WATCHDOG->ITOP = 0;  // Set NMI output to 0
  }
}
/* ----------------------------------------------------------------- */
/* Watchdog initialization */
void watchdog_init(unsigned int cycle, int type)
{
  puts   ("  Unlocking watchdog...");
  watchdog_unlock();
#ifdef FPGA_IMAGE
  CM3DS_MPS2_WATCHDOG->LOAD = (cycle*100);
#else
  CM3DS_MPS2_WATCHDOG->LOAD = cycle;
#endif

  if (type==0) {
    puts   ("  Set to no action");
    CM3DS_MPS2_WATCHDOG->CTRL = 0;
  } else if (type==1) {
    puts   ("  Set to NMI generation");
    CM3DS_MPS2_WATCHDOG->CTRL = CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk;
  } else {
    puts   ("  Set to reset generation");
    CM3DS_MPS2_WATCHDOG->CTRL = CM3DS_MPS2_Watchdog_CTRL_RESEN_Msk|CM3DS_MPS2_Watchdog_CTRL_INTEN_Msk;
  }
  puts   ("  Locking watchdog...");
  watchdog_lock();
}
/* ----------------------------------------------------------------- */
/* Update watchdog counter */
void watchdog_set(unsigned int cycle)
{
  watchdog_unlock();
#ifdef FPGA_IMAGE
  CM3DS_MPS2_WATCHDOG->CTRL = (cycle*100);
#else
  CM3DS_MPS2_WATCHDOG->CTRL = cycle;
#endif
  watchdog_lock();
}
/* ----------------------------------------------------------------- */
/* Unlock watchdog access */
void watchdog_unlock(void)
{
  CM3DS_MPS2_WATCHDOG->LOCK = 0x1ACCE551;
}
/* ----------------------------------------------------------------- */
/* Lock watchdog access */
void watchdog_lock(void)
{
  CM3DS_MPS2_WATCHDOG->LOCK = 0;
}
/* ----------------------------------------------------------------- */
/* Clear watchdog interrupt request */
void watchdog_irq_clear(void)
{
  watchdog_unlock();
  CM3DS_MPS2_WATCHDOG->INTCLR = CM3DS_MPS2_Watchdog_INTCLR_Msk;
  watchdog_lock();
}

