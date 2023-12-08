#!/bin/bash
source `dirname "$0"`/../conf.sh

ozone sh volume create o3://$OZONE_SERVICE_ID/tera
hdfs dfs -mkdir /tmp/tera

mappers=( 36  )
rows=(1000000000 100000000)

for mapper in "${mappers[@]}"; do
    for row in "${rows[@]}"; do
        ozone sh bucket create o3://$OZONE_SERVICE_ID/tera/teram${mapper}r${row}
        hdfs dfs -mkdir /tmp/tera/tera_${mapper}_${row}
    done
done



