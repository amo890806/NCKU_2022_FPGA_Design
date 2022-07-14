/***************************** Include Files *******************************/
#include "arithmetic.h"

/************************** Function Definitions ***************************/


s8 arith(UINTPTR baseAddr, u32 A, u32 B, u32 op, int *of) {
	A = A&0b11111111;
	B = B&0b11111111;
	u32 data = A + (B << 8) + (op << 16);
	ARITH_mWriteReg(baseAddr, 0, data);
	*of = (ARITH_mReadReg (baseAddr, 4) >> 8) & 1; // overflow
	int sign = (ARITH_mReadReg (baseAddr, 4) >> 7) & 1; // sign
	int value = (ARITH_mReadReg (baseAddr, 4)) & 0b01111111;
	int result = (ARITH_mReadReg (baseAddr, 4)) & 0b011111111;
	result = (sign) ? (value == 0) ? result : result+1 : result;
	return result;
}
