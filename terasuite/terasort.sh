#!/bin/bash
source `dirname "$0"`/../conf.sh

export EXAMPLES_PATH=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/
mapper=36
row=1000000000
#row=100000000
if [ "$FILE_SYSTEM" == "ozone" ]; then
    export TERAPATH="o3fs://teram${mapper}r${row}.tera.ozone1/data"
    export OUTPATH="o3fs://teram${mapper}r${row}.tera.ozone1/out"
elif [ "$FILE_SYSTEM" == "hdfs" ]; then
    export TERAPATH="/tmp/tera/tera_${mapper}_${row}/data"
    export OUTPATH="/tmp/tera/tera_${mapper}_${row}/out"
fi
hdfs dfs -rm -r -f -skipTrash $OUTPATH
yarn jar ${EXAMPLES_PATH}/hadoop-mapreduce-examples.jar terasort \
-Dmapreduce.job.maps=$mapper \
-Dmapreduce.reduce.memory.mb=4096 \
$TERAPATH $OUTPATH

