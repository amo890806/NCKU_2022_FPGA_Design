/***************************** Include Files *******************************/
#include "sorting.h"

/************************** Function Definitions ***************************/


u32 sort(UINTPTR baseAddr, u32 in) {
	SORT_mWriteReg(baseAddr, 0, in);
	return SORT_mReadReg(baseAddr, 8);
}


