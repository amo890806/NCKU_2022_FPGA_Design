#include <stdio.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"

int main(){
	uint32_t rWord, wWord;


	printf("Hw4 Initial Contents Test Start.\n");
		printf("offset = 0, Data = %x\n", Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 0));
		printf("offset = 4, Data = %x\n", Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4));
		printf("offset = 28, Data = %x\n", Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 28));
		printf("offset = 64, Data = %x\n", Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 64));

	printf("Hw4 Initial Contents Test End.\n");
	printf("Hw4 Write Test Start.\n");
	for(int i=0; i<68; i=i+4){
		wWord = i;
		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + i, wWord);
	}
	for(int i=0; i<68; i=i+4){
		 rWord = Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + i);
		printf("offset = %d, Data = %x\n", i, rWord);
	}
	printf("Hw4 Write Test End.\n");
}
