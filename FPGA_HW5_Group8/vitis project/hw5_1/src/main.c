#include <stdio.h>
//#include "xil.printf.h"
#include "xil_io.h"
#include "xparameters.h"

u32 get_inst(u32 bram0_raddr, u32 bram1_raddr, u32 bram1_waddr, u32 opmode_Z, u32 alumode) {
    u32 inst = bram0_raddr;
    inst += bram1_raddr << 5;
    inst += bram1_waddr << 10;
    inst += 0b10001     << 15; // inmode
    inst += 0b0101      << 20; // {opmode_Y, opmode_X} = 0b0101 => M
    inst += opmode_Z    << 24; // 0b011: Z => C
    inst += alumode     << 27;
    inst += 1           << 31;
    return inst;
}

// GPIO0: inst
// GPIO1: en
// GPIO2: valid

void exec(u32 inst) {
    Xil_Out32(XPAR_AXI_GPIO_0_BASEADDR, inst);
    Xil_Out32(XPAR_AXI_GPIO_1_BASEADDR, 1); // en
    while(!Xil_In32(XPAR_AXI_GPIO_2_BASEADDR)); // valid
    Xil_Out32(XPAR_AXI_GPIO_1_BASEADDR, 0); // en
}

int main() {
    printf("\r\nHW 5-1 Program en.\r\n");
    printf("\nStep1\n");

    u32 inst = get_inst(0, 2, 3, 0b000, 0b0000);   // BRAM1[3] <= BRAM0[0] * BRAM1[2]
    exec(inst);

    inst = get_inst(11, 3, 7, 0b000, 0b0000);  // BRAM1[7] <= BRAM0[11] * BRAM1[3]
    exec(inst);

    inst = get_inst(31, 7, 10, 0b011, 0b0000); // BRAM1[10] <= BRAM0[31] * BRAM1[7] + C
    exec(inst);
    
    inst = get_inst(1, 6, 13, 0b011, 0b0011);  // BRAM1[13] <= C - BRAM0[1] * BRAM1[6]  // Z - (X + Y + CIN)
    exec(inst);
   
    inst = get_inst(0, 31, 15, 0b011, 0b0001); // BRAM1[15] <= BRAM0[0] * BRAM1[31] - C - 1  // -Z + (X + Y + CIN) - 1
    exec(inst);
    
    for(int i = 0; i < 32; i++) { // read
        s32 bram1_read = Xil_In32(XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR + 4*i);
        printf("BRAM1[%d] = 0x%x\n", i, bram1_read);
    }

    for(int i = 0; i < 32; i++){ // write
        Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*i, (i+1)*(i+1)); // BRAM0[i] <= (i+1)^2
    }

    inst = get_inst(0, 2, 16, 0b000, 0b0000);  // BRAM1[16] <= BRAM0[0] * BRAM1[2]
    exec(inst);
    
    inst = get_inst(11, 3, 17, 0b000, 0b0000); // BRAM1[17] <= BRAM0[11] * BRAM1[3]
    exec(inst);
    
    inst = get_inst(31, 7, 18, 0b011, 0b0000); // BRAM1[18] <= BRAM0[31] * BRAM1[7] + C
    exec(inst);

    inst = get_inst(1, 6, 19, 0b011, 0b0011);  // BRAM1[19] <= C - BRAM0[1] * BRAM1[6]  // Z - (X + Y + CIN)
    exec(inst);

    inst = get_inst(0, 31, 20, 0b011, 0b0001); // BRAM1[20] <= BRAM0[0] * BRAM1[31] - C - 1  // -Z + (X + Y + CIN) - 1
    exec(inst);

    printf("\nStep2\n");
    for(int i = 0; i < 32; i++){ // read
        s32 bram1_read = Xil_In32(XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR + 4*i);
        printf("BRAM1[%d] = 0x%x\n", i, bram1_read);
    }
    printf("\r\nHW 5-1 Program Done.\r\n");
    return 0;
}