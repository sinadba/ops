#!/bin/bash
#
# @CreationTime
#   2016/2/3 上午9:19:17
# @ModificationDate
#   2016/2/4 下午1:33:10
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
 ${PROG} test-cases/replace.txt 2222       (remove "2222" in test-cases/replace.txt)
 ${PROG} test-cases/replace.txt 2222 0000  (replace "2222" with "0000" in test-cases/replace.txt)
 ${PROG} test-cases/ 2222                  (all file in test-cases/ will be removed "2222")
 ${PROG} test-cases/ 2222 0000             (all file in test-cases/ will be replace "2222" with "0000")
 ${PROG} -r test-cases/ 2222               (all file in test-cases/ will be removed "2222" by recursion)
 ${PROG} -r test-cases/ 2222 0000          (all file in test-cases/ will be replace "2222" with "0000" by recursion)
EOF
  exit $1
}

replace(){
	file=$1
	oldChar=$2
	newChar=$3
  echo "replace $oldChar whith $newChar in [FILE] ==> $file"
	sed -i "s/$oldChar/$newChar/g" `grep $oldChar -rl $file`
}

replaceDir(){
  for file in `ls $1`
	do
  local path=$1"/"$file
   if [ -d $path ]
    then
     echo "will not recursion replace in [DIR] ==> $path ,if want recursion use option -r"
   else
     replace $path $2 $3
   fi
	done
}

recursionReplace(){
	#echo "path:"$1
	#echo "oldChar:"$2
	#echo "newChar:"$3
	if [ -f $1 ];then
    replace $1 $2 $3
    exit 0
  else
    echo "[DIR] ==> $1"
  fi

	for file in `ls $1`
	do
  local path=$1"/"$file
   if [ -d $path ]
    then
     #echo "[DIR] ==> $path"
     recursionReplace $path $2 $3
   else
     replace $path $2 $3
   fi
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
        #echo "recursionReplace"
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
#[ -z "$1" ] && { echo No find file pattern! ; usage 1; }
# echo "replace"
if [ $# -lt 2 ] ; then
echo "No find file pattern!"
usage 1
else
  if [ -d $path ]
   then
    replaceDir $1 $2 $3
  else
    replace $1 $2 $3
  fi
fi
