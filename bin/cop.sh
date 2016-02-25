#!/bin/bash
#
# @CreationTime
#   2016/2/25 上午10:23:19
# @ModificationDate
#   2016/2/25 上午10:23:25
# @Function
#  Check the open port.
# @Usage
#   $ ./cop.sh
#
# @author gongice

PROG=`basename $0`
ipversion=''
sudomode=''

usage() {
    cat <<EOF
    Clean kafka log.
    Usage:
          ${PROG} -v 6
    Options:
          -v, --version         IPv4/IPv6
          -s, --sudo            run in sudo
          -h, --help            display this help and exit
EOF
    exit $1
}

readonly ARGS=`getopt -n "$PROG" -a -o v:sh -l version:,sudo,help -- "$@"`
eval set -- "$ARGS"

while true; do
	case "$1" in
	-v|--version)
		ipversion="$2"
		shift 2
	;;
  -s|--sudo)
    sudomode="sudo"
    shift 1
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

echo 'COMMAND   PID   USER   FD   TYPE   DEVICE   SIZE   NODE   NAME'
${sudomode} lsof -Pni${ipversion} | grep LISTEN
