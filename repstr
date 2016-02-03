#!/bin/bash
#
# @CreationTime
#   2016/2/3 上午9:19:17
# @ModificationDate
#   2016/2/3 上午9:19:17
# @Function
#  替换字符串
# @Usage
#   $ ./repstr.sh
#
# @author gongice

PROG=`basename $0`

usage() {
cat <<EOF
This script returns a new file resulting from replacing all occurrences of oldChar in this string with newChar.
Usage: ${PROG} oldChar newChar
Example:
 ${PROG} test-cases/replace.txt 2222
 ${PROG} test-cases/replace.txt 2222 0000
EOF
  exit $1
}

#如果没有参数传入，退出
if [ $# -lt 2 ] ; then
        usage;
fi

readonly file=$1
readonly oldChar=$2
readonly newChar=$3

sed -i "s/$oldChar/$newChar/g" `grep $oldChar -rl $file`
