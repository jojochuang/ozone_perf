#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh

IMPALAD_HOSTS=()
while IFS= read -r line; do
  IMPALAD_HOSTS+=("$line")
done < $CURRENT_DIR/../$IMPALAD_HOST_FILE

for s in "${scale[@]}"
do
	sudo -u hive impala-shell -d tpcds_${FILE_SYSTEM}_${s}_parquet -i ${IMPALAD_HOSTS[0]} $IMPALA_SSL < /tmp/impala_tpcds_query_${s}gb/query_0.sql
done
