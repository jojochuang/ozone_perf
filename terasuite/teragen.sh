#!/bin/bash
source `dirname "$0"`/../conf.sh

export EXAMPLES_PATH=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/
mapper=36
row=1000000000
#row=100000000
if [ "$FILE_SYSTEM" == "ozone" ]; then
    export TERAPATH="o3fs://teram${mapper}r${row}.tera.ozone1/data"
elif [ "$FILE_SYSTEM" == "hdfs" ]; then
    export TERAPATH="/tmp/tera/tera_${mapper}_${row}/data"
fi
hdfs dfs -rm -r -f -skipTrash $TERAPATH
yarn jar ${EXAMPLES_PATH}/hadoop-mapreduce-examples.jar teragen -Dmapreduce.job.maps=$mapper $row $TERAPATH
