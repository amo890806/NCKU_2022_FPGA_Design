#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"

#define LED_DEVICE_ID  XPAR_GPIO_0_DEVICE_ID

#define LED_DELAY     2560000

XGpio LED_Gpio;

int main() {
	int LED_Status;
	//u32 color[4] = {0b001, 0b011, 0b010, 0b100};
	//u32 led_data = 0x00;

	/* Initialize the GPIO driver */
	LED_Status = XGpio_Initialize(&LED_Gpio, LED_DEVICE_ID);
	if (LED_Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}
	/* Set the direction for all signals as inputs except the LED output */
	XGpio_SetDataDirection(&LED_Gpio, 1, 0x00);

	while (1) {

		/* Set the LED to High */
		XGpio_DiscreteWrite(&LED_Gpio, 1, 0x00);

		/* Wait a small amount of time so the LED is visible */
		for (int i=0; i<6; i++){
			for (int Delay = 0; Delay < (LED_DELAY/256); Delay++){
				for(int counter = 0; counter < 256; counter++){
					switch(i){
						case 0:
							XGpio_DiscreteWrite(&LED_Gpio, 1, 0b001);
							break;
						case 1:
							if(counter <= 97)	XGpio_DiscreteWrite(&LED_Gpio, 1, 0b011);
							else	XGpio_DiscreteWrite(&LED_Gpio, 1, 0b001);
							break;
						case 2:
							XGpio_DiscreteWrite(&LED_Gpio, 1, 0b011);
							break;
						case 3:
							XGpio_DiscreteWrite(&LED_Gpio, 1, 0b010);
							break;
						case 4:
							XGpio_DiscreteWrite(&LED_Gpio, 1, 0b100);
							break;
						case 5:
							if(counter <= 31)	XGpio_DiscreteWrite(&LED_Gpio, 1, 0b111);
							else if(counter <= 127)	XGpio_DiscreteWrite(&LED_Gpio, 1, 0b101);
							else	XGpio_DiscreteWrite(&LED_Gpio, 1, 0b100);
							break;
					}
				}
			}
		}

		/* Clear the LED bit */
		XGpio_DiscreteClear(&LED_Gpio, 1, 0x00);

	}

	xil_printf("Successfully ran Gpio Example\r\n");
	return XST_SUCCESS;
}
