#include "PeakError.h"

int PeakError(int* peak_start, int* peak_end, int peak_count,
	      int* region_start, int* region_end, int* region_ann, 
	      int region_count,
	      int* region_tp, int* region_fp,
	      int* region_possible_tp, int* region_possible_fp){
  int peak_i, region_i;
  for(region_i=0; region_i < region_count; region_i++){
    switch(region_ann[region_i]){
    case ANNOTATION_noPeaks:
      region_possible_tp[region_i] = 0;
      break;
    case ANNOTATION_peakStart:
    case ANNOTATION_peakEnd:
      region_possible_tp[region_i] = 1;
      break;
    default:
      return ERROR_UNDEFINED_ANNOTATION;
    }
    region_possible_fp[region_i] = 1;
  }
  return 0;
}
