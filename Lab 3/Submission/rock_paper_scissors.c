/*
 * rock_paper_scissors.c
 *
 *  Created on: Apr 29, 2022
 *      Author: Student
 */
#include <stdio.h>
#include "platform.h"
#include "xuartlite_i.h"
#include "stdlib.h"
#include "string.h"
#include "xparameters.h"
#include "PmodKYPD.h"
#include "sleep.h"
#include "xil_cache.h"

PmodKYPD myDevice;
#define DEFAULT_KEYTABLE "0FED789C456B123A"


//Setup
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

//Keypad init
void DemoInitialize() {
   EnableCaches();
   KYPD_begin(&myDevice, XPAR_PMODKYPD_0_AXI_LITE_GPIO_BASEADDR);
   KYPD_loadKeyTable(&myDevice, (u8*) DEFAULT_KEYTABLE);
}

/* Plays the game of Rock, Paper, Scissors
Checks for input from the keyboard and keypad with mapping of
1. Rock
2. Paper
3. Scissors
Logic is handled sequentially, starting with input from keyboard and then keypad
*/
void DemoRun() {
   u16 keystate;
   XStatus status, last_status = KYPD_NO_KEY;
   u8 key, last_key = 'x';
   // Initial value of last_key cannot be contained in loaded KEYTABLE string
   Xil_Out32(myDevice.GPIO_addr, 0xF);

   char* pcChoice;
   char* fpgaChoice;
   xil_printf("Press 1 for Rock, 2 for Paper, 3 for Scissors.\r\n");
   while (1) {
	   //Keyboard Logic
	  int keyboardInputNotValid = 1;
	  int keyboardChoice;

	  xil_printf("Keyboard turn\r\n");
	  while(keyboardInputNotValid) {
		  char buf[2];
		  scanf("%s", buf);
		  keyboardChoice = atoi(buf);
        //Valid input checker
		  if(keyboardChoice < 1 || keyboardChoice > 3) xil_printf("Error: Invalid input\r\nKeyboard turn\r\n");
		  else {
				switch(keyboardChoice) {
					  case 1: pcChoice = "Rock"; break;
					  case 2: pcChoice = "Paper"; break;
					  case 3: pcChoice = "Scissors"; break;
				}
			  xil_printf("Key Pressed: %d (as %s)\r\n", keyboardChoice, pcChoice);
			  keyboardInputNotValid = 0;
		  }
	  }


  	  //Keypad logic
      // Capture state of each key
      int keypadNotPressed = 1;
      int keypadChoice;
      xil_printf("Keypad turn\r\n");
      while(keypadNotPressed) {

          keystate = KYPD_getKeyStates(&myDevice);
          // Determine which single key is pressed, if any
          status = KYPD_getKeyPressed(&myDevice, keystate, &key);
          // Print key detect if a new key is pressed or if status has changed
          if (status == KYPD_SINGLE_KEY && (status != last_status || key != last_key)) {
            keypadChoice = key - '0';
            if(keypadChoice < 1 || keypadChoice > 3) xil_printf("Error: Invalid input\r\nKeypad Turn\r\n");
            else {
               switch(keypadChoice) {
                  case 1: fpgaChoice = "Rock"; break;
                  case 2: fpgaChoice = "Paper"; break;
                  case 3: fpgaChoice = "Scissors"; break;
               }
               xil_printf("Key Pressed: %d (as %s)\r\n", keypadChoice, fpgaChoice);
                  keypadNotPressed = 0;
            }
            last_key = key;
         //Too many keys pressed, re-check for input
          } else if (status == KYPD_MULTI_KEY && status != last_status) {
              xil_printf("Error: Multiple keys pressed\r\n");
              usleep(10000);
          }
          last_status = status;
          usleep(10000);
      }

      //RPS logic, check for tie first, then check for all possible combinations in which the PC player wins, and if those checks fail, FPGA must be the winner
      if(keyboardChoice==keypadChoice) xil_printf("Tie\r\n");
      else if ((keyboardChoice == 1 && keypadChoice == 3) || (keyboardChoice == 3 && keypadChoice == 2) || (keyboardChoice == 2 && keypadChoice == 1))
    	  xil_printf("PC wins! %s > %s\r\n", pcChoice, fpgaChoice);
	  else xil_printf("FPGA wins! %s > %s\r\n", fpgaChoice, pcChoice);
      xil_printf("\r\n");
      usleep(1000);
   }
}

void DemoCleanup() {
   DisableCaches();
}


int main() {
	DemoInitialize();
	DemoRun();
	DemoCleanup();
    return 0;
}


