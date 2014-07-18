int PeakError(int* peak_start, int* peak_end, int peak_count,
	      int* region_start, int* region_end, int* region_ann, 
	      int region_count,
	      int* region_tp, int* region_fp,
	      int* region_possible_tp, int* region_possible_fp);

#define ERROR_PEAKS_NOT_INCREASING 1
#define ERROR_REGIONS_NOT_INCREASING 2
#define ERROR_UNDEFINED_ANNOTATION 3
#define ERROR_OVERLAPPING_PEAKS 4
#define ERROR_OVERLAPPING_REGIONS 5
#define ANNOTATION_noPeaks 0
#define ANNOTATION_peakStart 1
#define ANNOTATION_peakEnd 2
#define ANNOTATION_peaks 3
