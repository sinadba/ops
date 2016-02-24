#!/bin/bash
#
# @CreationTime
#   2016/2/24 下午4:33:43
# @ModificationDate
#   2016/2/24 下午4:33:49
# @Function
#  Clean kafka log.
# @Usage
#   $ ./ckl.sh
#
# @author gongice

# default value
kafkaServerLogDir=/data2/kafka/server-logs
#最近n个文件
kafkacount=8
limitsize=100
PROG=`basename $0`

usage() {
    cat <<EOF
    Clean kafka log.
    Usage:
          ${PROG} -c 10 -s 100
          ${PROG} -c 10
          ${PROG} -s 100
    Options:
          -c, --count           file count limit
          -s, --size            file size limit
          -l, --logpath         kafka log path
          -h, --help            display this help and exit
EOF
    exit $1
}

readonly ARGS=`getopt -n "$PROG" -a -o c:s:l:h -l count:,size:,logpath:,help -- "$@"`
eval set -- "$ARGS"

while true; do
	case "$1" in
	-c|--count)
		kafkacount="$2"
		shift 2
	;;
	-s|--size)
		limitsize="$2"
		shift 2
	;;
  -l|--logpath)
    kafkaServerLogDir="$2"
    shift 2
  ;;
  -h|--help)
    usage 1
  ;;
--)
  shift
  break
;;
esac
done

if test -d $kafkaServerLogDir ; then
kafkaSizeG=`du -b ${kafkaServerLogDir} | awk '{print int($1/1024/1024/1024)}'`
else
  echo 'no find '$zkdataDir
  usage 1
fi

kafkacount=$[$kafkacount+1]
if [ $kafkaSizeG -gt $limitsize ];then
echo 'kafka log size over limit'$limitsize'G,current size:'$kafkaSizeG'G'
echo 'Start Cleaning kafka log'
ls -t $kafkaServerLogDir/server.* | tail -n +$kafkacount | xargs rm -f
ls -t $kafkaServerLogDir/controller.* | tail -n +$kafkacount | xargs rm -f
ls -t $kafkaServerLogDir/state-change.* | tail -n +$kafkacount | xargs rm -f
else
  echo `date`' There is no need to clean up kafka log,size(G):'$kafkaSizeG
fi
