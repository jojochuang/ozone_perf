#!/bin/bash
source `dirname "$0"`/conf.sh

if [ -f "$HOST_FILE" ]; then
    echo "$HOST_FILE exists."
else
    # ask CM for list of hosts.
    python get_hosts.py $CM_HOST > $HOST_FILE
fi

ssh systest@${CM_HOST} sudo -u hdfs ozone shell volume create o3://ozone1/vol1
ssh systest@${CM_HOST} sudo -u hdfs ozone shell bucket create o3://ozone1/vol1/bucket1

ssh systest@${CM_HOST} sudo -u hdfs hdfs dfs -mkdir -p o3fs://bucket1.vol1.ozone1/managed/hive
ssh systest@${CM_HOST} sudo -u hdfs hdfs dfs -mkdir -p o3fs://bucket1.vol1.ozone1/external/hive

python ./reconf_cluster.py ${CM_HOST}

install.sh
