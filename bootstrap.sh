#!/bin/bash

if [ -z $ZK_ID ] || [ -z $ZK_IPS ]; then
  echo ZK_IPS and ZK_ID needs to be set as environment addresses to be able to run.
  exit;
fi

arr=$(echo $ZK_IPS | tr "," "\n")
ZKS=""
I=0;
ID_FOUND=false
for x in $arr
do
    let "I++";
    if [[ $I = $ZK_ID ]]; then
      ID_FOUND=true
      ZKS+=$'\nserver.'$I'='$HOSTNAME':2888:3888'    
    else
      ZKS+=$'\nserver.'$I'='$x':2888:3888'
    fi
done

if [[ $ID_FOUND = false ]]; then
  echo ZK_ID should be a number matching a position of one of the given addresses.
  exit;
fi

cat /usr/local/zookeeper/conf/zoo.cfg.template > /usr/local/zookeeper/conf/zoo.cfg

echo $ZK_ID > /mnt/zookeeper/myid

echo "$ZKS" >> /usr/local/zookeeper/conf/zoo.cfg

echo ZKS=$ZKS

eval $*