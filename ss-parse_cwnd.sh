#!/bin/bash

# dst=$1
# dstport=$2

src=$1
srcport=$2
start_time="$(date -u +%s.%N)"

while [ 1 ]; do
  timestamp="$(date -u +%s.%N)"
  cur_time="$(date -u +%s.%N)"
  elapsed="$(bc <<<"$cur_time-$start_time")"
  #ts=$(date +%s.%N)
  #line=$(ss -eipn dst "$dst:$dstport" | grep "bbr")
	line=$(ss -oai state established src "$src:$srcport")
	ssthresh=$(echo $line | grep -oP '\bssthresh:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')

	rto=$(echo $line | grep -oP '\brto:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	rttvals=$(echo $line | grep -oP '\brtt:.*?(\s|$)' |  awk -F '[:/]' '{print $2","$3}' | tr -d ' ')
	#mss=$(echo $line | grep -oP '\bmss:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#pmtu=$(echo $line | grep -oP '\bpmtu:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#rcvmss=$(echo $line | grep -oP '\brcvmss:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#advmss=$(echo $line | grep -oP '\badvmss:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	cwnd=$(echo $line | grep -oP '\bcwnd:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#bytes_acked=$(echo $line | grep -oP '\bbytes_acked:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#segs_out=$(echo $line | grep -oP '\bsegs_out:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#segs_in=$(echo $line | grep -oP '\bsegs_in:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#data_segs_out=$(echo $line | grep -oP '\bdata_segs_out:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#send=$(echo $line | grep -oP "(?<=send )[^ ]+" )
	#lastrcv=$(echo $line | grep -oP '\blastrcv:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#pacing_rate=$(echo $line | grep -oP "(?<=pacing_rate )[^ ]+" )
	#delivery_rate=$(echo $line | grep -oP "(?<=delivery_rate )[^ ]+" )
	#busy=$(echo $line | grep -oP '\bbusy:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | awk -F '[ms]' '{print $1}' | tr -d ' ')
	#rwnd_limited=$(echo $line | grep -oP '\brwnd_limited:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | awk -F '[ms]' '{print $1}' | tr -d ' ')
	#unacked=$(echo $line | grep -oP '\bunacked:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#retrans_total=$(echo $line | grep -oP '\bretrans:.*?(\s|$)' |  awk -F '[:/]' '{print $3}' | tr -d ' ')

	lost=$(echo $line | grep -oP '\blost:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#lost=${lost:-0}
	# if [ "$lost" == "" ]; then
	# 	lost=0
	# fi
	#sacked=$(echo $line | grep -oP '\bsacked:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#reordering=$(echo $line | grep -oP '\breordering:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#rcv_space=$(echo $line | grep -oP '\brcv_space:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#rcv_ssthresh=$(echo $line | grep -oP '\brcv_ssthresh:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#notsent=$(echo $line | grep -oP '\bnotsent:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')
	#minrtt=$(echo $line | grep -oP '\bminrtt:.*?(\s|$)' |  awk -F '[:,]' '{print $2}' | tr -d ' ')

	#bbrvals=$(echo $line | grep -oP '\bbbr:.*?(\s|$)' |  awk -F '[:,]' '{print $3","$5","$7","$9}' | tr -d ")" | tr -d ' ')
	#output="$ts,$rto,$rttvals,$mss,$pmtu,$rcvmss,$advmss,$cwnd,$bytes_acked,$segs_out,$segs_in,$data_segs_out,$send,$lastrcv,$pacing_rate,$delivery_rate,$busy,$rwnd_limited,$unacked,$retrans_total,$lost,$sacked,$reordering,$rcv_space,$rcv_ssthresh,$notsent,$minrtt,$bbrvals"
	output="$elapsed,$cwnd,$lost,$ssthresh,$rto,$rttvals"
	echo $output
  test $? -gt 128 && break;

done
