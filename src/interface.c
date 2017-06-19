/* -*- compile-command: "R CMD INSTALL .." -*- */

#include "PeakError.h"
#include <R.h>
#include <R_ext/Rdynload.h>

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
    if(status == ERROR_UNDEFINED_ANNOTATION){
	error("undefined annotation");
    }
    if(status == ERROR_REGIONS_NOT_INCREASING){
	error("regions not increasing");
    }
    if(status == ERROR_PEAKS_NOT_INCREASING){
	error("peaks not increasing");
    }
    if(status == ERROR_OVERLAPPING_PEAKS){
	error("overlapping peaks");
    }
    if(status == ERROR_OVERLAPPING_REGIONS){
	error("overlapping regions");
    }
    if(status != 0){
	error("error code %d", status);
    }
}
	
R_CMethodDef cMethods[] = {
  {"PeakError_interface",
   (DL_FUNC) &PeakError_interface, 12
   //,{REALSXP, REALSXP, INTSXP, INTSXP, REALSXP}
  },
  {NULL, NULL, 0}
};

void R_init_PeakError(DllInfo *info) {
  R_registerRoutines(info, cMethods, NULL, NULL, NULL);
  //R_useDynamicSymbols call says the DLL is not to be searched for
  //entry points specified by character strings so .C etc calls will
  //only find registered symbols.
  R_useDynamicSymbols(info, FALSE);
}
