#
#
#
#

set term postscript enhanced color solid
#set term x11

set xlabel "Injected Gaussian S/N"
set ylabel "N Events"
set x2label "Recoverable Top Hat S/N"
set xrange[8:50]
set x2range[8*0.868:50*0.868]

set xtics out nomirror
set x2tics out nomirror
set mxtics 5
set mx2tics 5

# Figure 1a
set output "Keane_fig1a.ps"
plot "< cat a | sort -g | uniq -c" u 2:1 wi imp lw 12 lt 1 title "Full sample","< cat miss_VG | sort -g | uniq -c" u 2:1 wi imp lw 12 lt 3 title "Missed (Farah+2019)"

# Figure 1b
set output "Keane_fig1b.ps"
plot "< cat a_minusfalse | sort -g | uniq -c" u 2:1 wi imp lw 12 lt 2 title "Injected sample", "< cat miss_VG_minusfalse | sort -g | uniq -c" u 2:1 wi imp lw 12 lt 4 title "Missed (Farah+2019) - false injections", "< cat miss_VG_minusfalse_minusDMcut | sort -g | uniq -c" u 2:1 wi imp lw 12 lt 5 title "Missed (Farah+2019) - false injections - DM cuts", "< cat a_minusfalse | sort -g | uniq -c" u 2:($1*(1-0.5*(1+erf(($2-9.0/0.868)/sqrt(2))))) wi imp lw 5 lt 6 title "Ave. missed, theory"

# Plot everything
set output "Keane_fig1.ps"
plot "< cat a | sort -g | uniq -c" u 2:1 wi imp lw 12 title "Full sample", "< cat a_minusfalse | sort -g | uniq -c" u 2:1 wi imp lw 12 title "Injected sample", "< cat miss_VG | sort -g | uniq -c" u 2:1 wi imp lw 12 title "Missed (Farah+2019)", "< cat miss_VG_minusfalse | sort -g | uniq -c" u 2:1 wi imp lw 12 title "Missed (Farah+2019) - false injections", "< cat miss_VG_minusfalse_minusDMcut | sort -g | uniq -c" u 2:1 wi imp lw 12 title "Missed (Farah+2019) - false injections - DM cuts", "< cat a_minusfalse | sort -g | uniq -c" u 2:($1*(1-0.5*(1+erf(($2-9.0/0.868)/sqrt(2))))) wi imp lw 5 title "Ave. missed, theory"
