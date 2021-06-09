#!/bin/bash
source `dirname "$0"`/conf.sh

cd impala-tpcds-kit/tpcds-gen
yarn jar target/tpcds-gen-1.0-SNAPSHOT.jar -d o3fs://bucket1.vol1.$OZONE_SERVICE_ID/tpcds1000gb -p 500 -s 1000
cd ../..

scale=( 100 1000 3000 )
for s in "${scale[@]}"
do
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.$OZONE_SERVICE_ID\/o3_${s}/g" impala-tpcds-kit/scripts/impala-external.sql  > impala-external-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.$OZONE_SERVICE_ID\/o3_${s}/g" impala-tpcds-kit/scripts/impala-parquet.sql  > impala-parquet-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.$OZONE_SERVICE_ID\/o3_${s}/g" impala-tpcds-kit/scripts/impala-insert.sql  > impala-insert-o3-${s}gb.sql

        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-external-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-parquet-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-insert-o3-${s}gb.sql
done

impala-shell -f impala-external-o3-1000gb.sql
impala-shell -f impala-parquet-o3-1000gb.sql
impala-shell -f impala-insert-o3-1000gb.sql


echo "Done. Next, run run_tpcds.sh to generate queries for TPC-DS"
