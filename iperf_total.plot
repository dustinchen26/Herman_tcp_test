#!/usr/bin/gnuplot -rv

if (!exists("csv")) csv='iperf.csv'
if (!exists("folder")) folder='result'
if (!exists("picture")) picture='iperf.png'
if (!exists("cwnd")) cwnd='none'
if (!exists("times")) times=1

set terminal png size 1440,1024
set key outside
set output picture
set title cwnd
set xlabel 'Time(Secs)'

set datafile separator ','
set xdata time
set timefmt "%S"
set format x "%.6f"

set ylabel 'Throughput(Mbits/s)'
set ytics 0,5
set yrange [0:50]
set ytics nomirror

set style line 1 lt 1 lc rgb '#0072bd' # blue
set style line 2 lt 1 lc rgb '#d95319' # orange
set style line 3 lt 1 lc rgb '#edb120' # yellow
set style line 4 lt 1 lc rgb '#7e2f8e' # purple
set style line 5 lt 1 lc rgb '#77ac30' # green
set style line 6 lt 1 lc rgb '#4dbeee' # light-blue
set style line 7 lt 1 lw 1 lc rgb '#ff0000' # red
set style line 8 lt 1 lw 1 lc rgb '#77ac30' # green
set style line 10 lc rgb '#ff0000' pt 1   # triangle


plot for [i=1:times] folder.'/iperf_'.i.'.csv' using 1:($2+i) title 'Test '.i with lines ls i axis x1y1
