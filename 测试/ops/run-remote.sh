#!/bin/bash
#
# @Function
# 在建立互信的主机上执行脚本
#
# @Usage
#   $ ./run-remote.sh
#
# @author gongice

readonly this="${BASH_SOURCE-$0}"
readonly common_bin=$(cd -P -- "$(dirname -- "$this")" && pwd -P)
readonly cur_username="$USER"
readonly tmp_script="tmp_script.sh"

PROG=`basename $0`

usage() {
    cat <<EOF
    在建立互信的主机上执行脚本,如果没有互信需要输入密码。
    Usage: ${PROG}
    Example:
           ${PROG} script.sh hostname
           ${PROG} script.sh hostname "arg1  arg2 argN"
EOF
    exit $1
}

#如果没有参数传入，退出
if [ $# -lt 1 ] ; then
        usage;
fi

if [ -f $1 ]; then
  # 如果脚本存在
  echo "[INFO]--脚本存在:"$1
  echo "[INFO]--拷贝脚本["$1"]  ===>  "$cur_username@$2:/tmp/$tmp_script
  echo "[INFO]--如果没有互信，请输入密码..."
  scp $1 $2:/tmp/$tmp_script
else
  if [ -f ${common_bin}/$1 ]; then
      echo "[INFO]--脚本存在:"${common_bin}/$1
      echo "[INFO]--拷贝脚本["${common_bin}/$1"]  ===>  "$cur_username@$2:/tmp/$tmp_script
      echo "[INFO]--如果没有互信，请输入密码..."
      scp ${common_bin}/$1 $2:/tmp/$tmp_script
  else
    echo '[INFO]--No such file or directory:'$1
fi
fi
echo "[INFO]--在远程主机上执行脚本，如果没有互信，请输入密码..."
ssh $cur_username@$2 "bash /tmp/$tmp_script $3 && rm /tmp/$tmp_script"
#echo `ssh $cur_username@$2 "bash /tmp/$tmp_script $3 && rm /tmp/$tmp_script"`
