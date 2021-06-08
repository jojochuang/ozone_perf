#!/bin/bash
source `dirname "$0"`/conf.sh

yarn jar target/tpcds-gen-1.0-SNAPSHOT.jar -d o3fs://bucket1.vol1.ozone/tpcds1000gb -p 500 -s 1000

scale=( 100 1000 3000 )
for s in "${scale[@]}"
do
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.ozone\/o3_${s}/g" impala-external.sql  > impala-external-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.ozone\/o3_${s}/g" impala-parquet.sql  > impala-parquet-o3-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/o3fs:\/\/bucket1.vol1.ozone\/o3_${s}/g" impala-insert.sql  > impala-insert-o3-${s}gb.sql

        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-external-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-parquet-o3-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_o3_${s}/g" impala-insert-o3-${s}gb.sql
done

impala-shell -f impala-external-o3-1000gb.sql
impala-shell -f impala-parquet-o3-1000gb.sql
impala-shell -f impala-insert-o3-1000gb.sql

