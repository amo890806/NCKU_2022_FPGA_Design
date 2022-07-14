#include <stdio.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "arithmetic.h"
#include "sorting.h"
#include "pg.h"


int main()
{
    int mode;
	printf("Program Start.\n\r");
    while(1){
        printf("Please input a mode (1. arithmetic, 2.sorting, 3.parity generator, 4. Exit): ");
        scanf("%d", &mode);
        printf("%d\n\r", mode);
        switch (mode){
            case 1:{
                u32 op;
                u32 A, B;
                s8 out;
                char operator;
                printf("Input A:");
                scanf("%d", &A);
                printf("%d\n\r", A);
                printf("Input B:");
                scanf("%d", &B);
                printf("%d\n\r", B);
                printf("Input Operator:");
                scanf(" %c", &operator);
                printf("%c\n\r", operator);
                if(operator == '+') op = 0;
                else if(operator == '-') op = 1;
                else if(operator == '*') op = 2;
                else op = 3;
                int of;
                out = arith(XPAR_MYIP_0_S00_AXI_BASEADDR, A, B, op, &of);
                printf("Result = %d\n\r", out);
                printf("Overflow = %d\n\r", of);
                break;
            }
            case 2:{
                u32 arr = 0, in;
                printf("Please input 8 elements array (Enter one element in a row):\n\r");
                for(int i = 0; i < 8; i++){
                    scanf("%d", &in);
                    printf("%d\n\r", in);
                    arr += in << (4*i);
                }
                u32 aftersort = sort(XPAR_MYIP_0_S00_AXI_BASEADDR, arr);

                for(int i = 0; i < 8; i++){
                    printf("%d ", (aftersort >> (4*i) & 0b1111));
                }
                printf("\n");
                break;
            }
            case 3:{
                u32 din, parity;
                u64 base=1;
                printf("Input data:");
                scanf("%d", &din);
                printf("%d\n\r", din);
                parity = pg(XPAR_MYIP_0_S00_AXI_BASEADDR, din);
                printf("Parity bit = %d\n\r", parity);
                break;
            }
            default:
                break;
        }
    }
	printf("Program End.\n\r");
    return 0;
}
