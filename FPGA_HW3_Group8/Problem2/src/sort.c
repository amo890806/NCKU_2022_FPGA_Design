#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"
#include <stdio.h>

#define SW_DEVICE_ID  XPAR_GPIO_0_DEVICE_ID
#define UART_ADDR 0x40600000

XGpio LED_Gpio, SW_Gpio;

void bubble_sort(int*, int, u32);
int max = 20;

int main() {

	int SW_Status;
	u32 sw_data;
	int num[max];

	/* Initialize the GPIO driver */
	SW_Status = XGpio_Initialize(&SW_Gpio, SW_DEVICE_ID);
	if (SW_Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}
	/* Set the direction for all signals as inputs except the LED output */
	XGpio_SetDataDirection(&SW_Gpio, 1, 0x0f);

	sw_data = XGpio_DiscreteRead(&SW_Gpio, 1);
	xil_printf("switches data = %d\r\n", sw_data);

	printf("Please enter 20 non-negative integers:\n");

	for (int i=0; i<max; i++) {
		scanf("%d", &num[i]);
		printf("%d\n", num[i]);
	}

	bubble_sort(num, max, sw_data);

	printf("After Sorting:\n");

	for (int i=0; i<max; i++) {
		printf("%d ", num[i]);
	}
	printf("\n");

	xil_printf("Successfully ran Gpio Example\r\n");
	return XST_SUCCESS;
}

void bubble_sort(int*arr, int n, u32 sw){
	for(int i=0; i<n-1; i++){
		for(int j=0; j<n-i-1; j++){
			if(sw){
				if(arr[j] < arr[j+1]){
					int temp = arr[j];
					arr[j] = arr[j+1];
					arr[j+1] = temp;
				}
			}
			else{
				if(arr[j] > arr[j+1]){
					int temp = arr[j];
					arr[j] = arr[j+1];
					arr[j+1] = temp;
				}
			}
		}
	}
}
