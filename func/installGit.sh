#!/bin/bash

workdir=$1

curdate=$(cat ${workdir}/ini/global.ini | grep "curdate" | awk -F = '{print $2}')
release=$(cat ${workdir}/ini/global.ini | grep "release" | awk -F = '{print $2}')

export info="$0: $PWD"
bash ${workdir}/comm/echoInfo.sh $workdir

git --version &> /dev/null

if [ $? -eq 0 ];then
  echo "宿主机Git环境已安装，不需要重新安装"
else
  if [ "$release" == "centos" ];then
    yum -y install git
  else
    apt -y install git
  fi
fi

export info="$0: git version"
bash ${workdir}/comm/echoInfo.sh $workdir
git --version

# 修改提交缓存大小
git config --global https.postBuffer 524288000
git config --global http.postBuffer 524288000

# 只有十分钟（600秒）传输速率都低于1KB/s的话才会timeout
git config --global http.lowSpeedLimit 1000
git config --global http.lowSpeedTime 600
