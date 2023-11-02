#!/usr/bin/gnuplot -rv

if (!exists("csv")) csv='outfile.csv'
if (!exists("picture")) picture='cwnd.png'
if (!exists("caption")) caption='none'

set terminal png
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
set y2tics 0, 50
set y2range [0:500]
set grid

set style line 1 lt 2 lw 2 lc rgb '#0072bd' # blue
set style line 2 lt 1 lc rgb '#d95319' # orange
set style line 3 lt 1 lc rgb '#edb120' # yellow
set style line 4 lt 1 lc rgb '#7e2f8e' # purple
set style line 5 lt 1 lc rgb '#77ac30' # green
set style line 6 lt 1 lc rgb '#4dbeee' # light-blue
set style line 7 lt 1 lw 2 lc rgb '#ff0000' # red

plot csv using 1:4 title 'ssthresh' with lines ls 5 axis x1y1, \
     csv using 1:3 title 'lost' with impulses ls 7 axis x1y2, \
     csv using 1:2 title 'cwnd' with lines ls 1 axis x1y1


# set terminal x11
# set output
# replot