#include <stdio.h>
#include "xil_printf.h"
#include "axi4_add.h"
#include "xgpio.h"
#include "xbasic_types.h"
#include "xparameters.h"
#include "xil_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xil_types.h"
#include "xgpio.h"
#include "xstatus.h"
#include <stdio.h>
#include "xil_printf.h"
//Constantes para gerar numero aleatório
#define MATRICULA 160031621
#define ANO 2019
#define SECULO 21
#define MAX 65535
union
{
    Xuint8 u8[4];
    Xuint32 u32;
    Xfloat32 f32;
}unT;

XGpio GpioOutput;
XGpio GpioInput;

int main()
{

	int status;
    u32 DataRead;
 	u32 OldData;
    float res = 0.0;
    int Whole = 0;
    int Thousands = 0;
    unT.f32 = 42.25;

    status = XGpio_Initialize(&GpioOutput,XPAR_GPIO_0_DEVICE_ID);
  		if (status != XST_SUCCESS)
    return XST_FAILURE;
	XGpio_SetDataDirection(&GpioOutput, 1, 0x0);

	 status = XGpio_Initialize(&GpioInput,XPAR_GPIO_0_DEVICE_ID);
  	if (status != XST_SUCCESS)
   		 return XST_FAILURE;
   // Set the direction for all signals to be inputs
    XGpio_SetDataDirection(&GpioInput, 2, 0x1);

	OldData = 0xFFFFFFFF;
	while(1){
	DataRead = XGpio_DiscreteRead(&GpioInput, 2);
	if(DataRead != OldData)
      xil_printf("Valor na switche: %d\r\n", DataRead);
      if(DataRead <= 2000)
      	unT.f32 = (MATRICULA/MAX) * DataRead;
      else if (DataRead <= 4000)
      	unT.f32 = (ANO/MAX) * DataRead;
      else
      	unT.f32 = (MAX/100*SECULO) * DataRead/10;
      IPAXIFPMUL_mWriteReg(XPAR_IPAXIFPMUL_0_S00_AXI_BASEADDR, 0, unT.u32);
	  if(DataRead >= 2000)
      	unT.f32 = (MATRICULA/MAX) * DataRead;
      else if (DataRead >= 4000)
      	unT.f32 = (ANO/MAX) * DataRead;
      else
      	unT.f32 = (MAX/100*SECULO) * DataRead/10;
      IPAXIFPMUL_mWriteReg(XPAR_IPAXIFPMUL_0_S00_AXI_BASEADDR, 4, unT.u32);
	unT.u32=IPAXIFPMUL_mReadReg (XPAR_IPAXIFPMUL_0_S00_AXI_BASEADDR, 8);
	res = unT.f32;
	Whole = res;
	Thousands = (res - Whole)*10000;
	if(Whole < 0)
		Thousands *= -1;
	xil_printf("results = %d.%03d\n\r",Whole,Thousands);
    return 0;}
}
