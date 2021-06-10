#!/bin/bash
source `dirname "$0"`/conf.sh


scale=3000
sudo -u hive impala-shell -d tpcds_o3_${scale}_parquet  -i ozworker1 < /tmp/impala_tpcds_query_${scale}gb/query_0.sql
