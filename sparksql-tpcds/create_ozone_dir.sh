#!/bin/bash
source `dirname "$0"`/../conf.sh

ozone sh volume create o3://$OZONE_SERVICE_ID/sparksqldata
hdfs dfs -mkdir /tmp/sparksqldata

data_scale=( 100 1000 3000 10000  )
file_formats=("orc" "parquet")

for ds in "${data_scale[@]}"; do
    for ff in "${file_formats[@]}"; do
        ozone sh bucket create o3://$OZONE_SERVICE_ID/sparksqldata/tpcds${ds}gb${ff}
        hdfs dfs -mkdir /tmp/sparksqldata/tpcds${ds}gb_${ff}
    done
done


