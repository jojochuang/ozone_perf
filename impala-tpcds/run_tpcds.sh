#!/bin/bash
source `dirname "$0"`/../conf.sh


for s in "${scale[@]}"
do
	sudo -u hive impala-shell -d tpcds_${s}_parquet < /tmp/impala_tpcds_query_${s}/query_0.sql
done
