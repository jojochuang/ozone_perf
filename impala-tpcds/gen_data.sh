#!/bin/bash
source `dirname "$0"`/conf.sh


for s in "${SCALES[@]}"
do
	cd impala-tpcds-kit/tpcds-gen
	yarn jar target/tpcds-gen-1.0-SNAPSHOT.jar -d o3fs://bucket1.vol1.$OZONE_SERVICE_ID/tpcds${s}gb -p 500 -s ${s}
	cd ../..
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.$OZONE_SERVICE_ID\/tpcds${s}gb/g" impala-tpcds-kit/scripts/impala-external.sql  > impala-external-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.$OZONE_SERVICE_ID\/tpcds${s}gb/g" impala-tpcds-kit/scripts/impala-parquet.sql  > impala-parquet-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.$OZONE_SERVICE_ID\/tpcds${s}gb/g" impala-tpcds-kit/scripts/impala-insert.sql  > impala-insert-o3-${s}gb.sql

        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-external-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-parquet-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-insert-o3-${s}gb.sql

	impala-shell -f impala-external-o3-${s}gb.sql -i ozworker1
	impala-shell -f impala-parquet-o3-${s}gb.sql -i ozworker1
	impala-shell -f impala-insert-o3-${s}gb.sql -i ozworker1
done


echo "Done. Next, run run_tpcds.sh to generate queries for TPC-DS"
