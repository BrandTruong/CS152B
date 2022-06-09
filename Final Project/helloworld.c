
#include "PmodKYPD.h"
#include "sleep.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "xgpio.h"

#include "PmodAMP2.h"
#include "xil_printf.h"

#ifdef __MICROBLAZE__
   #include "xintc.h"

   #define INTC                  XIntc
   #define INTC_HANDLER          XIntc_InterruptHandler
   #define INTC_DEVICE_ID        XPAR_INTC_0_DEVICE_ID
   #define INTC_TMR_INTERRUPT_ID XPAR_INTC_0_PMODAMP2_0_VEC_ID
#else
   #include "xscugic.h"
   #include "xil_exception.h"

   #define INTC                  XScuGic
   #define INTC_HANDLER          Xil_InterruptHandler
   #define INTC_DEVICE_ID        XPAR_PS7_SCUGIC_0_DEVICE_ID
   #define INTC_TMR_INTERRUPT_ID XPAR_FABRIC_PMODAMP2_0_TIMER_INTERRUPT_INTR
#endif

#define PWM_BASEADDR   XPAR_PMODAMP2_0_AXI_LITE_PWM_BASEADDR
#define GPIO_BASEADDR  XPAR_PMODAMP2_0_AXI_LITE_GPIO_BASEADDR
#define TIMER_BASEADDR XPAR_PMODAMP2_0_AXI_LITE_TIMER_BASEADDR

int  DemoIntcInitialize(PmodAMP2 *InstancePtr, INTC *IntcInstancePtr,
      u16 IntcDeviceId, u32 InterruptId, void *Handler);
void DemoInterruptHandler(PmodAMP2 *InstancePtr);
void DemoInitialize2();
void DemoSetFrequency(u32 freq_hz);
//end of AMP2
void DemoInitialize();
void DemoRun();
void DemoCleanup();
void DisableCaches();
void EnableCaches();
void DemoSleep(u32 millis);

PmodKYPD myDevice;
XGpio Gpio;
INTC intc;
PmodAMP2 amp;
u32 delta = 0;
u32 duty  = 0;
u8 rise   = 0;

int main(void) {
   DemoInitialize();
   DemoInitialize2();
   DemoRun();
   DemoCleanup();
   return 0;
}

// keytable is determined as follows (indices shown in Keypad position below)
// 12 13 14 15
// 8  9  10 11
// 4  5  6  7
// 0  1  2  3
#define DEFAULT_KEYTABLE "0FED789C456B123A"

void DemoInitialize() {
   EnableCaches();
   KYPD_begin(&myDevice, XPAR_PMODKYPD_0_AXI_LITE_GPIO_BASEADDR);
   KYPD_loadKeyTable(&myDevice, (u8*) DEFAULT_KEYTABLE);
}

void DemoRun() {
	int Status;

	/* Initialize the GPIO driver */
	Status = XGpio_Initialize(&Gpio, XPAR_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return;
	}
	AMP2_start(&amp);
	u16 keystate;
	XStatus status, last_status = KYPD_NO_KEY;
	u8 key, last_key = 'x';
	// Initial value of last_key cannot be contained in loaded KEYTABLE string

	Xil_Out32(myDevice.GPIO_addr, 0xF);

	xil_printf("Pmod KYPD demo started. Press any key on the Keypad.\r\n");
	u16 state = 0;
	int counter = 0;
	xil_printf("started PmodAMP2 Demo\n\r");

	while (1) {
	  // Capture state of each key
	  keystate = KYPD_getKeyStates(&myDevice);
	  // Determine which single key is pressed, if any
	  status = KYPD_getKeyPressed(&myDevice, keystate, &key);

	  u8 key_int;
	  // Print key detect if a new key is pressed or if status has changed
	  if (status == KYPD_SINGLE_KEY
			) {
		 xil_printf("Key Pressed: %c\r\n", (char) key);
		 last_key = key;
		 counter = 0;
		 if (key == '0') key_int = 13;
		 else if(key >= 'A') {
			 key_int = (key - 'A' + 1) * 4;
		 } else {
			 key_int = (key - '0') + (key - '0' - 1) / 3;
		 }
		 state |= 1 << key_int;

	  } else if (status == KYPD_MULTI_KEY && status != last_status)
		 xil_printf("Error: Multiple keys pressed\r\n");
	  XGpio_DiscreteWrite(&Gpio,1,state);
	  last_status = status;

	 xil_printf("Key_int is equal to : %d\r\n", key_int);
	  int freq;
	        switch(key_int)
	        {
	  		  case 1:
	  			  freq = 293;
	  			  break;
	  		  case 2:
	  			  freq = 311;
	  			  break;
	  		  case 3:
	  			  freq = 330;
	  			  break;
	  		  case 4:
	  			  freq = 349;
	  			  break;
	  		  case 5:
	  			  freq = 370;
	  			  break;
	  		  case 6:
	  			  freq = 392;
	  			  break;
	  		  case 7:
	  			  freq = 415;
	  			  break;
	  		  case 8:
	  			  freq = 440;
	  			  break;
	  		  case 9:
	  		  	  freq = 466;
	  		  	  break;
	  		  case 10:
	  			  freq = 494;
	  			  break;
	  		  case 11:
	  			  freq = 523;
	  			  break;
	  		  case 12:
				  freq = 554;
				  break;
			  case 13:
				  freq = 587;
				  break;
	  		  default:
	  			  freq = 0;
	  			  break;
	        }
	if(status == KYPD_NO_KEY && counter > 10) {
		freq = 0;
		counter = 0;
		key_int = 0;
	}
	DemoSetFrequency(freq);
	  counter++;
	  usleep(100);
	  state = 0;
	}
	AMP2_stop(&amp);
}

void DemoCleanup() {
   DisableCaches();
}

void EnableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheEnable();
#endif
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheEnable();
#endif
#endif
}

void DisableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheDisable();
#endif
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheDisable();
#endif
#endif
}


//AMP2
void DemoInitialize2() {
   XStatus status;
   xil_printf("initializing\n\r");
   AMP2_begin(&amp, PWM_BASEADDR, GPIO_BASEADDR, TIMER_BASEADDR);
   xil_printf("initializing\n\r");
   status = DemoIntcInitialize (
      &amp,
      &intc,
      INTC_DEVICE_ID,
      INTC_TMR_INTERRUPT_ID,
      (Xil_ExceptionHandler) DemoInterruptHandler
   );

   if (status != XST_SUCCESS) {
      xil_printf("intc setup failed\n\r");
   }
}

void DemoInterruptHandler(PmodAMP2 *InstancePtr) {
   if (XTmrCtr_IsExpired(&InstancePtr->timer, 0)) {
      XTmrCtr_Stop(&InstancePtr->timer, 0);

      // Draw a triangle wave
      if (rise == 0) {
         if (duty + delta <= AMP2_PWM_PERIOD) {
            duty = duty + delta;
         } else {
            duty = (AMP2_PWM_PERIOD << 1) - duty - delta;
            rise = 1;
         }
      } else {
         if (duty >= delta) {
            duty = duty - delta;
         } else {
            duty = delta - duty;
            rise = 0;
         }
      }

      PWM_Disable(InstancePtr->PWM_BaseAddress);
      PWM_Set_Duty(InstancePtr->PWM_BaseAddress, duty, 0);
      PWM_Enable(InstancePtr->PWM_BaseAddress);
      XTmrCtr_Reset(&InstancePtr->timer, 0);
      XTmrCtr_Start(&InstancePtr->timer, 0);
   }
}

int DemoIntcInitialize(PmodAMP2 *InstancePtr, INTC *IntcInstancePtr,
      u16 IntcDeviceId, u32 InterruptId, void *Handler) {
   int status;
#ifdef __MICROBLAZE__
   /*
    * Initialize the interrupt controller driver so that it's ready to use.
    * specify the device ID that was generated in xparameters.h
    */
   status = XIntc_Initialize(IntcInstancePtr, InterruptId);
   if (status != XST_SUCCESS)
      return status;

   /* Hook up interrupt service routine */
   XIntc_Connect (
      IntcInstancePtr,
      InterruptId,
      (Xil_ExceptionHandler) Handler,
      InstancePtr
   );

   /* Enable the interrupt vector at the interrupt controller */
   XIntc_Enable(IntcInstancePtr, InterruptId);

   /*
    * Start the interrupt controller such that interrupts are recognized
    * and handled by the processor
    */
   status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
   if (status != XST_SUCCESS)
      return status;

   /*
    * Initialize the exception table and register the interrupt
    * controller handler with the exception table
    */
   Xil_ExceptionInit();

   Xil_ExceptionRegisterHandler (
      XIL_EXCEPTION_ID_INT,
      (Xil_ExceptionHandler) INTC_HANDLER,
      IntcInstancePtr
   );

   /* Enable non-critical exceptions */
   Xil_ExceptionEnable();
#else
   XScuGic_Config *IntcCfgPtr;

   XTmrCtr_SetHandler (
      &InstancePtr->timer,
      (XTmrCtr_Handler) Handler,
      &InstancePtr
   );

   Xil_ExceptionRegisterHandler (
      XIL_EXCEPTION_ID_INT,
      (Xil_ExceptionHandler) XScuGic_InterruptHandler,
      IntcInstancePtr
   );
   Xil_ExceptionEnable();

   // Interrupt controller initialization
   IntcCfgPtr = XScuGic_LookupConfig(IntcDeviceId);
   status = XScuGic_CfgInitialize (
      IntcInstancePtr,
      IntcCfgPtr,
      IntcCfgPtr->CpuBaseAddress
   );

   if(status != XST_SUCCESS)
      return status;

   // Connect timer interrupt to handler
   status = XScuGic_Connect (
      IntcInstancePtr,
      InterruptId,
      Handler,
      InstancePtr
   );

   if(status != XST_SUCCESS)
      return status;

   // Enable Interrupts
   XScuGic_Enable (
      IntcInstancePtr,
      InterruptId
   );
#endif

   return XST_SUCCESS;

}

void DemoSetFrequency(u32 freq_hz) {
   delta = (freq_hz * (2.0 * AMP2_PWM_PERIOD * AMP2_PWM_PERIOD / 100000000));
}
