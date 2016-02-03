#!/bin/bash
#
# @CreationTime
#   2016/2/2 下午4:21:43
# @ModificationDate
#   2016/2/3 上午8:57:09
# @Function
#  在建立互信的主机上执行脚本
# @Usage
#   $ ./run-remote.sh script.sh hostname
#
# @author gongice

readonly cur_username="$USER"
readonly tmp_script="tmp_script.sh"
PROG=`basename $0`

usage() {
    cat <<EOF
    In building trust on a host of executing scripts, if there is no mutual trust need password.
    Usage: ${PROG}
    Example:
          ${PROG} -s script.sh -r remotehost
          ${PROG} -s script.sh -r remotehost -a "arg1  arg2 argN"
    Options:
          -s, --script          script path
          -r, --remotehost      remote hostname
          -a, --args            script args
          -h, --help            display this help and exit
EOF
    exit $1
}
#-o或--options选项后面接可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面接可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项后接选项解析错误时提示的脚本名字
#ARGS=`getopt -o ab:c:: --long along,blong:,clong:: -n 'example.sh' -- "$@"`

#如果没有参数传入，退出
[ -z "$1" ] && { echo No find script pattern! ; usage 1; }

script=$1
remotehost=$2
args=$3
readonly ARGS=`getopt -n "$PROG" -a -o s:r:a::h -l script:,remotehost:,args::,help -- "$@"`
test $? -ne 0  && usage 1
#echo "before set:"$1
eval set -- "$ARGS"
#echo "after set:"$1
while true; do
	case "$1" in
	-s|--script)
		#echo "-s:"$2
		script="$2"
		shift 2
	;;
	-r|--remotehost)
		#echo "-r:"$2
		remotehost="$2"
		shift 2
	;;
	-h|--help)
		usage
	;;
	-a|--args)
		case "$2" in
		"")
			args=""
			#echo "null -a:"$args
			shift 2;
		;;
		*)
			args=$2
			#echo "any -a:"$args
			shift 2;
		;;
		esac
	;;
	--)
		shift
		break
	;;
	esac
done

if test -f $script ; then
	# 如果脚本存在
	echo "[INFO]--Script exists:"$script
	echo "[INFO]--Copy the script["$script"]  === >  "$cur_username@$remotehost:/tmp/$tmp_script
	echo "[INFO]--If there is no trust, please enter the password..."
	scp $script $remotehost:/tmp/$tmp_script
else
	echo '[INFO]--No such file or directory:'$script
fi
echo "[INFO]--Execute the script on the remote host,If there is no trust, please enter the password..."
ssh $cur_username@$remotehost "bash /tmp/$tmp_script $args && rm /tmp/$tmp_script"
