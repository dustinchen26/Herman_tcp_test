#!/usr/bin/gnuplot -rv

if (!exists("csv")) csv='outfile.csv'
if (!exists("folder")) folder='result'
if (!exists("picture")) picture='cwnd.png'
if (!exists("caption")) caption='none'
if (!exists("times")) times=1

set terminal png size 800,600
set key outside
set output picture
set title caption
set xlabel 'Time(Secs)'

set datafile separator ','
set xdata time
set timefmt "%S"
set format x "%.9f"

set ylabel 'Cwnd'
set ytics 0,200
set yrange [0:1500]
set ytics nomirror

set y2label 'Lost'
set y2tics 0, 55
set y2range [0:500]
set grid

set style line 1 lt 1 lc rgb '#0072bd' # blue
set style line 2 lt 1 lc rgb '#d95319' # orange
set style line 3 lt 1 lc rgb '#edb120' # yellow
set style line 4 lt 1 lc rgb '#7e2f8e' # purple
set style line 5 lt 1 lc rgb '#77ac30' # green
set style line 6 lt 1 lc rgb '#4dbeee' # light-blue
set style line 7 lt 1 lw 1 lc rgb '#ff0000' # red
set style line 8 lt 1 lw 1 lc rgb '#77ac30' # green
set style line 10 lc rgb '#ff0000' pt 1   # triangle


plot for [i=1:times] folder.'/outfile_'.i.'.csv' using 1:($2+i) title 'CWND '.i with lines ls i axis x1y1, \
     for [i=1:times] folder.'/outfile_'.i.'.csv' using 1:($3+i) title 'lost '.i with impulses ls 10 axis x1y2
