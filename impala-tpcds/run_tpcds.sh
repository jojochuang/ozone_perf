#!/bin/bash
source `dirname "$0"`/conf.sh


sudo -u hive impala-shell -d tpcds_1000_parquet < /tmp/impala_tpcds_query_1tb/query_0.sql
