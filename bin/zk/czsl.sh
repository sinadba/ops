#!/bin/bash
#
# @CreationTime
#   2016/2/23 下午3:03:51
# @ModificationDate
#   2016/2/24 下午4:33:58
# @Function
#  清理zookeeper日志
# @Usage
#   $ ./czsl.sh
#
# @author gongice

# default value
#snapshot 文件:snapshot.xxxxx
zkdataDir=/home/hadoop/gsw/zookeeper/zkdata/version-2
#log 文件:log.xxxx
zkdataLogDir=/home/hadoop/gsw/zookeeper/logs/version-2
#最近n个文件
zkcount=20
limitsize=100
PROG=`basename $0`

usage() {
    cat <<EOF
    Clean Zookeeper snapshot and log.
    Usage:
          ${PROG} -c 10 -s 100
          ${PROG} -c 10
          ${PROG} -s 100
    Options:
          -c, --count           file count limit
          -s, --size            file size limit
          -d, --datapath        zk data path
          -l, --logpath         zk log path
          -h, --help            display this help and exit
EOF
    exit $1
}

readonly ARGS=`getopt -n "$PROG" -a -o c:s:d:l:h -l count:,size:,datapath:,logpath:,help -- "$@"`
eval set -- "$ARGS"

while true; do
	case "$1" in
	-c|--count)
		zkcount="$2"
		shift 2
	;;
	-s|--size)
		limitsize="$2"
		shift 2
	;;
  -d|--datapath)
    zkdataDir="$2"
    shift 2
  ;;
  -l|--logpath)
    zkdataLogDir="$2"
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
#echo `date`' zookeeper snapshot size(G):'$zkdataSizeG
#echo `date`' zookeeper log size(G):'$zkdataLogSizeG
if test -d $zkdataDir ; then
zkdataSizeG=`du -b ${zkdataDir} | awk '{print int($1/1024/1024/1024)}'`
else
  echo 'no find '$zkdataDir
  usage 1
fi

if test -d $zkdataLogDir ; then
zkdataLogSizeG=`du -b ${zkdataLogDir} | awk '{print int($1/1024/1024/1024)}'`
else
  echo 'no find '$zkdataLogDir
  usage 1
fi

# 清理zookeeper 日志和快照
zkcount=$[$zkcount+1]
if [ $zkdataSizeG -gt $limitsize ];then
echo 'zookeeper snapshot size over limit'$limitsize'G,current size:'$zkdataSizeG'G'
echo 'Start Cleaning zookeeper snapshot'
ls -t $zkdataDir/snapshot.* | tail -n +$zkcount | xargs rm -f
else
  echo `date`' There is no need to clean up zookeeper snapshot,size(G):'$zkdataSizeG
fi

if [ $zkdataLogSizeG -gt $limitsize ];then
echo 'zookeeper log size over limit'$limitsize'G,current size:'$zkdataLogSizeG'G'
echo 'Start Cleaning zookeeper log'
ls -t $zkdataLogDir/log.* | tail -n +$zkcount | xargs rm -f
else
  echo `date`' There is no need to clean up zookeeper log,size(G):'$zkdataLogSizeG
fi
