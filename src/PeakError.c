#include "PeakError.h"

int PeakError(int* peak_start, int* peak_end, int peak_count,
	      int* region_start, int* region_end, int* region_ann, 
	      int region_count,
	      // above=inputs, below=outputs.
	      int* region_tp, int* region_fp,
	      int* region_possible_tp, int* region_possible_fp){
  int peak_i, region_i;
  for(region_i=0; region_i < region_count; region_i++){
    if(region_i > 0){
      if(region_start[region_i] <= region_start[region_i-1]){
	return ERROR_REGIONS_NOT_INCREASING;
      }
      if(region_start[region_i] < region_end[region_i-1]){
	return ERROR_OVERLAPPING_REGIONS;
      }
    }
    region_tp[region_i] = 0; // peak starts or ends in while loop.
    region_possible_fp[region_i] = 0; // actually peak counts in while loop.
  }
  for(peak_i=1; peak_i < peak_count; peak_i++){
    if(peak_start[peak_i] <= peak_start[peak_i-1]){
      return ERROR_PEAKS_NOT_INCREASING;
    }
    if(peak_start[peak_i] < peak_end[peak_i-1]){
      return ERROR_OVERLAPPING_PEAKS;
    }
  }
  region_i = 0;
  peak_i = 0;
  while(region_i < region_count && peak_i < peak_count){
    /* Rprintf("peak [%d,%d) region [%d,%d)\n", */
    /* 	    peak_start[peak_i], peak_end[peak_i], */
    /* 	    region_start[region_i], region_end[region_i]); */
    if(peak_end[peak_i] <= region_start[region_i]){
      // peak is before region, 
      // so move on to the next peak.
      peak_i++;
    }else if(region_end[region_i] <= peak_start[peak_i]){
      // peak is after region, 
      // so we are done with this region.
      region_i++;
    }else{
      // peak is overlapping current region.
      region_possible_fp[region_i]++;
      if(region_start[region_i] <= peak_start[peak_i] &&
	 peak_start[peak_i] < region_end[region_i]){
	// peak starts in region.
	if(region_ann[region_i] == ANNOTATION_peakStart){
	  region_tp[region_i]++;
	}
      }
      if(peak_end[peak_i] <= region_end[region_i]){
	// Rprintf("peak ends in region.");
	if(region_ann[region_i] == ANNOTATION_peakEnd){
	  region_tp[region_i]++;
	}
	// we are done with this peak.
	peak_i++;
      }else if(region_end[region_i] < peak_end[peak_i]){
	// peak extends past region, 
        // so we are done with region.
	region_i++;
      }
    }
  }
  for(region_i=0; region_i < region_count; region_i++){
    /* Rprintf("peaks %d tp %d ann %d\n", */
    /* 	    region_possible_fp[region_i], */
    /* 	    region_tp[region_i], */
    /* 	    region_ann[region_i]); */
    switch(region_ann[region_i]){
    case ANNOTATION_noPeaks:
      if(region_possible_fp[region_i] > 0){
	region_fp[region_i] = 1;
      }else{
	region_fp[region_i] = 0;
      }
      region_possible_tp[region_i] = 0;
      break;
    case ANNOTATION_peakStart:
    case ANNOTATION_peakEnd:
      if(region_tp[region_i] > 1){
	region_fp[region_i] = 1;
	region_tp[region_i] = 1;
      }else{
	region_fp[region_i] = 0;
      }
      region_possible_tp[region_i] = 1;
      break;
    default:
      return ERROR_UNDEFINED_ANNOTATION;
    }
    region_possible_fp[region_i] = 1;
  }
  return 0;
}
