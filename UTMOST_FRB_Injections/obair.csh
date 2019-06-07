#!/bin/csh

# Get detected FRBs using VG's rules, which are the following:
# Injected S/N>=9 
# Heimdall S/N>=9
# |DM_injected - DM_heimdall| < 0.25*DM_heimdall     // perhaps this is cm03 eqns 12-14 for UTMOST numbers and extremes for width and delta S/N values from their simulated range with some number of buffer sigmas?
# 
# Also filter out "false injections", i.e. injected FRBs that were scheduled (they scheduled them in advance) but observations were actually not happening at the time of the injection. These have all zeros in their heimdall values. Not correct to classify as "missed by heimdall" if observations weren't happening!

# Using "injected" and "heimdall S/N"
#

# There are several distributions to consider
# 1. All
awk 'NR>1{if ($8>=9) print $8,$9,$10,$12,$13,$14,$12/$8,$(NF-3)}' Injection_results_March_final.txt > all
# 2. Missed according to VG
awk 'NR>1{snr_in=$8;dm_in=$9;w_in=$10;snr_out=$12;dm_out=$13;w_out=$14; dmdiff=dm_out-dm_in; if (dmdiff < 0) dmdiff=dmdiff*-1.0; if (snr_in >=9 && snr_out>=9 && dmdiff<0.25*dm_out) print snr_in,dm_in,w_in,snr_out,dm_out,w_out,snr_out/snr_in,$(NF-3)}' Injection_results_March_final.txt > detected_VG
cat all detected_VG | sort | uniq -u > missed_VG
# 3. Missed according to VG minus false injections
awk 'NR>1{if ($8>=9 && $12!=0) print $8,$9,$10,$12,$13,$14,$12/$8,$(NF-3)}' Injection_results_March_final.txt > all_minusfalse
cat all_minusfalse detected_VG | sort | uniq -u > missed_VG_minusfalse
# 4. Missed according to VG minus false injections minus missed due to DM cut
awk 'NR>1{snr_in=$8;dm_in=$9;w_in=$10;snr_out=$12;dm_out=$13;w_out=$14; dmdiff=dm_out-dm_in; if (dmdiff < 0) dmdiff=dmdiff*-1.0; if (snr_in >=9 && snr_out>=9) print snr_in,dm_in,w_in,snr_out,dm_out,w_out,snr_out/snr_in,$(NF-3)}' Injection_results_March_final.txt > detected_minusDMcut
cat all_minusfalse detected_minusDMcut | sort | uniq -u > missed_VG_minusfalse_minusDMcut
# 5. Missed according to VG minus false injections minus missed due to DM cut minus missed due to visible RFI
# THIS IS COMPILED BY EYE. IT IS BASICALLY missed_VG_minusfalse_minusDMcut WITH EVENTS THAT WERE CLEARLY MISSED DUE TO RFI REMOVED. THIS ASSESSMENT IS DONE BY EYE-BALLING THE SIGNALS USING VG'S NICE check_furby.py SCRIPT
# 6. Missed according to theory
# THIS IS SIMPLY PLOTTED AS A FUNCTION --> NO EXTRA FILES NEEEDED

# Make histograms
awk '{printf "%d\n",$1}' all | sort -g > a
awk '{printf "%d\n",$1}' all_minusfalse | sort -g > a_minusfalse
awk '{printf "%d\n",$1}' missed_VG | sort -g > miss_VG
awk '{printf "%d\n",$1}' missed_VG_minusfalse | sort -g > miss_VG_minusfalse
awk '{printf "%d\n",$1}' missed_VG_minusfalse_minusDMcut | sort -g > miss_VG_minusfalse_minusDMcut
# Plot histograms
gnuplot -persist plot.gp
ps2pdf Keane_fig1a.ps
ps2pdf Keane_fig1b.ps
ps2pdf Keane_fig1.ps




