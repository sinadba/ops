#!/bin/bash
#
# @CreationTime
#   2016/2/3 上午9:19:17
# @ModificationDate
#   2016/2/3 下午3:55:43
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
Usage: ${PROG} -r file oldChar newChar
Example:
 ${PROG} -r test-cases/replace.txt 2222
 ${PROG} -r test-cases/replace.txt 2222 0000
EOF
  exit $1
}

replace(){
 file=$1
 oldChar=$2
 newChar=$3
sed -i "s/$oldChar/$newChar/g" `grep $oldChar -rl $file`
}

recursionReplace(){
  echo "path:"$1
  echo "oldChar:"$2
  echo "newChar:"$3
  for filename in `ls $1`
  do
    echo $1/$filename
  replace $1/$filename $2 $3
  done
  exit 0
}

ARGS=`getopt -a -o rh -l recursion,help -- "$@"`
[ $? -ne 0 ] && usage 1
eval set -- "${ARGS}"

while true; do
    case "$1" in
    -r|--recursion)
        shift 2
        echo "recursionReplace"
        recursionReplace $1 $2 $3
        ;;
    -h|--help)
        usage
        ;;
    --)
        shift
        break
        ;;
    esac
done
[ -z "$1" ] && { echo No find file pattern! ; usage 1; }

echo "replace"
replace $1 $2 $3
