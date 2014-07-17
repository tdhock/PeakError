#include "PeakError.h"
#include <R.h>

void PeakError_interface
(int* peak_start, int* peak_end, int* peak_count,
 int* region_start, int* region_end, int* region_ann, 
 int* region_count,
 int* region_tp, int* region_fp,
 int* region_possible_tp, int* region_possible_fp){
    int status;
    status = PeakError(peak_start, peak_end, *peak_count,
		       region_start, region_end, region_ann,
		       *region_count,
		       region_tp, region_fp,
		       region_possible_tp, region_possible_fp);
    if(status != 0){
	error("error code %d", status);
    }
}
	
