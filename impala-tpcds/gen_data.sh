#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh


IMPALAD_HOSTS=()
while IFS= read -r line; do
  IMPALAD_HOSTS+=("$line")
done < $CURRENT_DIR/../$IMPALAD_HOST_FILE

for s in "${scale[@]}"
do
	cd $CURRENT_DIR/impala-tpcds-kit/tpcds-gen
	yarn jar target/tpcds-gen-1.0-SNAPSHOT.jar -d $FILE_SYSTEM_PREFIX/o3_${s} -p 100 -s ${s}
	cd ../..

        expanded_prefx=$( echo $FILE_SYSTEM_PREFIX | sed 's/\//\\\//g' )
        echo $expanded_prefx
        sed "s/\/tmp\/tpc-ds\/sf10000/${expanded_prefx}\/o3_${s}/g" impala-tpcds-kit/scripts/impala-external.sql  > impala-external-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/${expanded_prefx}\/o3_${s}/g" impala-tpcds-kit/scripts/impala-parquet.sql  > impala-parquet-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/${expanded_prefx}\/o3_${s}/g" impala-tpcds-kit/scripts/impala-insert.sql  > impala-insert-o3-${s}gb.sql

        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-external-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-parquet-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-insert-o3-${s}gb.sql

	impala-shell -f impala-external-o3-${s}gb.sql -i ${IMPALAD_HOSTS[0]}
	impala-shell -f impala-parquet-o3-${s}gb.sql -i ${IMPALAD_HOSTS[0]}
	impala-shell -f impala-insert-o3-${s}gb.sql -i ${IMPALAD_HOSTS[0]}
done

echo "Done. Next, run run_tpcds.sh to generate queries for TPC-DS"
