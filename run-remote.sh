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

readonly this="${BASH_SOURCE-$0}"
readonly cur_script_dir=$(cd -P -- "$(dirname -- "$this")" && pwd -P)
readonly cur_username="$USER"
readonly tmp_script="tmp_script.sh"
PROG=`basename $0`

usage() {
    cat <<EOF
    In building trust on a host of executing scripts, if there is no mutual trust need password.
    Usage: ${PROG}
    Example:
           ${PROG} script.sh hostname
           ${PROG} script.sh hostname "arg1  arg2 argN"
EOF
    exit $1
}

#如果没有参数传入，退出
if [ $# -lt 2 ] ; then
        usage;
fi

if [ -f $1 ]; then
  # 如果脚本存在
  echo "[INFO]--Script exists:"$1
  echo "[INFO]--Copy the script["$1"]  ===>  "$cur_username@$2:/tmp/$tmp_script
  echo "[INFO]--If there is no trust, please enter the password..."
  scp $1 $2:/tmp/$tmp_script
#else
#  if [ -f ${cur_script_dir}/$1 ]; then
#      echo "[INFO]-- Script exists:"${cur_script_dir}/$1
#      echo "[INFO]-- Copy the script["${cur_script_dir}/$1"]  ===> # "$cur_username@$2:/tmp/$tmp_script
#      echo "[INFO]--If there is no trust, please enter the password..."
#      scp ${cur_script_dir}/$1 $2:/tmp/$tmp_script
  else
    echo '[INFO]--No such file or directory:'$1
#fi
fi
echo "[INFO]--Execute the script on the remote host,If there is no trust, please enter the password..."
ssh $cur_username@$2 "bash /tmp/$tmp_script $3 && rm /tmp/$tmp_script"
#echo `ssh $cur_username@$2 "bash /tmp/$tmp_script $3 && rm /tmp/$tmp_script"`
