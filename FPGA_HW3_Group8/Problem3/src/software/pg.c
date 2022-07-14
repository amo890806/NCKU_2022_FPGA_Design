/***************************** Include Files *******************************/
#include "pg.h"

/************************** Function Definitions ***************************/


u32 pg(UINTPTR baseAddr, u32 A) {
	PG_mWriteReg(baseAddr, 0, A);
	return PG_mReadReg (baseAddr, 12) & 1;
}
