/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xuartlite_i.h"
#include "stdlib.h"
#include "string.h"
#include "xparameters.h"
#include "xgpio.h"
#include "limits.h"

#define LED_1  0x01
#define LED_CHANNEL 1
#define false 0
#define true 1

//Continuously checks for inputs in the format "{int}/{int}", and outputs the resulting integer to the serial when enter is pressed
//If the value is over 100, then the led will light up
//Currently only supports integers (atoi does not handle larger than expected numbers and overflows, can use strtol instead)
int doesOverflow(int x, int y)
{
	if((y > 0 && (x > INT_MAX / y)) || (y < 0 && (x > INT_MIN / y))) return true;
	return false;
}

int main()
{
	init_platform();
	XGpio gpio;
	XGpio_Initialize(&gpio, XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&gpio, LED_CHANNEL, 0x00);
	while(1) {
		print("\r\n----\r\n");
		//Input taken
		char buf[100];
		scanf("%s", buf);
		print(buf);
		print("\r\n");
		//String-Checking by finding delimiter '/'
		char* delimiter = strchr(buf, '/');
		int pos = delimiter - buf;
		char* str1 = (char*) malloc(pos + 1);
		char* str2 = (char*) malloc(strlen(buf) - pos);
		memcpy(str1, buf, pos);
		memcpy(str2, delimiter+1, strlen(buf) - pos);
		/* Replacement code if we want to handle numbers larger than expected
		char* ptr;
		long x = strtol(str1, &ptr, 10);
		long y = strtol(str2, &ptr, 10);
		*/
		int x = atoi(str1);
		int y = atoi(str2);
		//checks for overflow, and if found, will not do multiplication, otherwise output the result and turn led on or off depending on value
		if(!doesOverflow(x, y)) {
			int result = x*y;
			xil_printf("x is %d\r\n", x);
			xil_printf("y is %d\r\n", y);
			xil_printf("result is %d\r\n", result);
			//LED handling
			if(result > 100) {
				XGpio_DiscreteWrite(&gpio, LED_CHANNEL, 0x01);
			} else {
				XGpio_DiscreteWrite(&gpio, LED_CHANNEL, 0x00);
			}
		} else
			xil_printf("Overflow detected\r\n");
		free(str1);
		free(str2);
	}
	cleanup_platform();
}
