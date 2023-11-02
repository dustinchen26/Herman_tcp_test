#!/bin/bash
VERSION="1.0"
CWND="cubic"
SOURCE_IP="127.0.0.1"
SOURCE_PORT=10000
DEST_IP="127.0.0.1"
DEST_PORT=5201
TEST_TIME=10
DATE=$(date +%Y%m%d)
TIMESTAMP=$(date +%s)
TEST_TYPE="test1"
LOOP_TIMES=1
FOLDER=""
TARGET="."

print_var()
{
    echo "CWND=$CWND"
    echo "DATE=$DATE"
    echo "SOURCE_IP=$SOURCE_IP"
    echo "DEST_IP=$DEST_IP"
    echo "DEST_PORT=$DEST_PORT"
    echo "TEST_TIME=$TEST_TIME"
    echo "TIMESTAMP=$TIMESTAMP"
    echo "TEST_ACTION=$TEST_ACTION"
    echo "LOOP_TIMES=$LOOP_TIMES"
    echo "FOLDER=$FOLDER"
}

prepare()
{
    print_var

    FOLDER="result/"$CWND"_"$DATE"_"$TIMESTAMP
    mkdir -p $FOLDER
}

display_picture()
{
    local PICTURE_FILE=$1
    if test -f "$PICTURE_FILE"; then
        display $PICTURE_FILE
    else
        echo "Can't find \"$PICTURE_FILE\""
    fi
}

draw_cwnd()
{
    local CSV_FILE_PATH=$1
    local PICTURE_FILE_PATH=$2
    local CWND=$3
    local CAPTION="$CWND $1"

    gnuplot -e "csv='$CSV_FILE_PATH'" -e "picture='$PICTURE_FILE_PATH'" -e "caption='$CAPTION'" cwnd.plot
}

draw_cwnd_total()
{
    local CAPTION="$CWND $1"
    local PICTURE_FILE_PATH=$FOLDER"/cwnd_"$DATE"_"$TIMESTAMP".png"
    gnuplot -e "times=$LOOP_TIMES" -e "folder='$FOLDER'" -e "picture='$PICTURE_FILE_PATH'" -e "caption='$CAPTION'" cwnd_total.plot
}

draw_throughput_total()
{
    local CAPTION="$CWND $1"
    local PICTURE_FILE_PATH=$FOLDER"/throughput_"$DATE"_"$TIMESTAMP".png"
    gnuplot -e "times=$LOOP_TIMES" -e "folder='$FOLDER'" -e "picture='$PICTURE_FILE_PATH'" -e "caption='$CAPTION'" iperf_total.plot
}

copy_result()
{
    cp -rf $FOLDER $TARGET/.
}

test_1()
{
    local i=$1
    local CSV_FILE_PATH=$FOLDER"/outfile_"$i".csv"
    local JSON_IPERF_PATH=$FOLDER"/iperf_"$i".json"
    local CSV_IPERF_PATH=$FOLDER"/iperf_"$i".csv"
    local PICTURE_FILE_PATH=$FOLDER"/outfile_"$i".png"

    #. motor_control.sh test1 &
    #sudo ./tcpwin.bt > cpwin.csv  &
    ./ss-parse_cwnd.sh $SOURCE_IP $SOURCE_PORT | tee $CSV_FILE_PATH &

    #iperf3 -s -f m -p 5566 -i 0.1 > result.txt &
    iperf3 -c $DEST_IP -p $DEST_PORT -N -V -f m -B $SOURCE_IP --cport $SOURCE_PORT -M 1460 --congestion $CWND -t $TEST_TIME -i 1 -J > $JSON_IPERF_PATH
    sudo killall ss-parse_cwnd.sh
    #sudo killall bpftrace
    # sleep 1
    #cat result.txt | grep sec | sed '1d;$d' | head -150 | tr - " " | awk '{print $4, $8}' > $CSV_IPERF_PATH
    sed -i 1d $JSON_IPERF_PATH
    jq -rf iperf.jq $JSON_IPERF_PATH > $CSV_IPERF_PATH
    # sleep 1
    # sudo killall iperf3
    #gnuplot -e "csv='$CSV_FILE_PATH'" -e "picture='$PICTURE_FILE_PATH'" -e "cwnd='$CWND'" cwnd.plot
    draw_cwnd $CSV_FILE_PATH $PICTURE_FILE_PATH $CWND
}

test_2()
{
    echo "test 2"

    print_var

    return
}


usage()
{
cat <<'EOF'
Sleeping and Wakeup Loop Testing
./test -w -d {device_ip} -w -n 10

Shutdown Testing
./test -s -d {device_ip} -w -n 10

Command Testing
./test -s -d {device_ip} -c -n 10

OPTIONS:
    -T, --type          [test1,test2]
    -C, --congestion    [cubic|reno|westwood|mmwave]
                        - tcp congestion window alog
    -B, --bind          - bind host
        --cport         - client port
    -c, --client        - source ip
    -l, --loops         - loop times
    -p, --port          - server port to listen on/connect to
    -t, --time          - time in seconds to transmit for (default 10 secs)
    -h, --help          - Show Version

EXAMPLE:
    ./test.sh -B 192.168.88.100 -p 5566 -c 192.168.88.101 -C cubic -l 5 -t 10
EOF
}

# check getopt is enhanced or no
getopt -T &>/dev/null;[ $? -ne 4 ] && { echo "not enhanced version";exit 1; }

# 引數解析
parameters=`getopt -o C:B:c:p:t:l:T:hv --long separator:,congestion,bind,cport,client,port,time,loops,type,help,version -n "$0" -- "$@"`
[ $? -ne 0 ] && { echo "Try '$0 --help' for more information."; exit 1; }

eval set -- "$parameters"


while true;
do
    case "$1" in
    -C|--congestion) CWND=$2;
    shift 2 ;;

    -B|--bind) SOURCE_IP=$2;
    shift 2 ;;

    --cport) SOURCE_PORT=$2;
    shift 2 ;;

    -c|--client) DEST_IP=$2;
    shift 2 ;;

    -p|--port) DEST_PORT=$2;
    shift 2 ;;

    -t|--time) TEST_TIME=$2;
    shift 2 ;;

    -l|--loops) LOOP_TIMES=$2;
    shift 2 ;;

    -T|--type) TEST_TYPE=$2;
    shift 2 ;;

    -v|--version) echo "$VERSION";
    exit ;;

    -h|--help) usage;
    exit ;;

    --)
    shift

    break ;;
    *) usage;exit 1;;
    esac
done

PLOT_FILE_NAME="cwnd_"$CWND"_"$TIMESTAMP".png"

if [ $TEST_TYPE == "test1" ];then
    prepare

    for ((i=1; i<=$LOOP_TIMES; i++))
    do
        test_1 $i
    done

    draw_cwnd_total
    draw_throughput_total
    #copy_result
elif [ $TEST_TYPE == "test2" ]; then
    prepare

    for ((i=1; i<=$LOOP_TIMES; i++))
    do
        test_2 $i
    done

    draw_cwnd_total "4 pairs"
    draw_throughput_total "4 pairs"
    #copy_result
fi


echo "Testing END"
