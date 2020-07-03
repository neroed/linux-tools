#!/bin/bash
###############批量文件分发脚本v1.0#######################
list="/root/shell/host.list"

if [ $# -ne 2 ]
then
  echo "请输入本地文件路径和远程主机路径:eg ./root/shell/adm-file.sh local remote"
  exit 1
fi

if [ ! -e $1 ]
then
        echo "文件$1不存在，请重新操作" 
        sleep 2
fi

cat -n $list
echo "----------------------"
read -p "请输入要执行的主机编号或分组名称，输入ALL发送到所有主机：" num

######获取ip列表#############
ip=""
if [ "$num" = "ALL" ]
then
    ip=`cat $list | grep "^[0-9]"`
elif [ !"num"="ALL" ] && [[ $num =~ ^[a-Z] ]]
then
        res=`grep "\<$num\>" $list | wc -l`
        if [ $res -eq 0 ]
        then
                echo "分组不存在"
                exit 1
        else
                ip=`sed -n '/'$num'/,/^[[]/{p}' $list | grep "^[0-9]"`
  fi
else
    for i in `echo $num`
    do
          ip="$ip `cat -n $list | awk 'NR=='$i'&& $NF ~/^[0-9]/{print $NF}'`"
    done
fi
#echo $ip
##########按ip列表实际循环操作######################
for n in `echo $ip`
do
   echo -e "######正在连接\033[1;31m  $n \033[0m ########"
   scp -r $1 $n:$2
done
