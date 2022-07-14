#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh


IMPALAD_HOSTS=()
while IFS= read -r line; do
  IMPALAD_HOSTS+=("$line")
done < $CURRENT_DIR/../$IMPALAD_HOST_FILE

if [ "$CDP_TLS" = "true" ]; then
    IMPALA_SSL="--ssl"
else
    IMPALA_SSL=""
fi

for s in "${scale[@]}"
do
	cd $CURRENT_DIR/impala-tpcds-kit/tpcds-gen
	yarn jar target/tpcds-gen-1.0-SNAPSHOT.jar -d $FILE_SYSTEM_PREFIX/impala_${FILE_SYSTEM}_${s} -p 25 -s ${s}
	cd ../..

        expanded_prefx=$( echo $FILE_SYSTEM_PREFIX | sed 's/\//\\\//g' )
        echo $expanded_prefx
        sed "s/\/tmp\/tpc-ds\/sf10000/${expanded_prefx}\/impala_${FILE_SYSTEM}_${s}/g" impala-tpcds-kit/scripts/impala-external.sql  > impala-external-${FILE_SYSTEM}-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/${expanded_prefx}\/impala_${FILE_SYSTEM}_${s}/g" impala-tpcds-kit/scripts/impala-parquet.sql  > impala-parquet-${FILE_SYSTEM}-${s}gb.sql
        sed "s/\/tmp\/tpc-ds\/sf10000/${expanded_prefx}\/impala_${FILE_SYSTEM}_${s}/g" impala-tpcds-kit/scripts/impala-insert.sql  > impala-insert-${FILE_SYSTEM}-${s}gb.sql

        sed -i "s/tpcds_10000/tpcds_${FILE_SYSTEM}_${s}/g" impala-external-${FILE_SYSTEM}-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_${FILE_SYSTEM}_${s}/g" impala-parquet-${FILE_SYSTEM}-${s}gb.sql
        sed -i "s/tpcds_10000/tpcds_${FILE_SYSTEM}_${s}/g" impala-insert-${FILE_SYSTEM}-${s}gb.sql

	impala-shell -f impala-external-${FILE_SYSTEM}-${s}gb.sql -i ${IMPALAD_HOSTS[0]} $IMPALA_SSL
	impala-shell -f impala-parquet-${FILE_SYSTEM}-${s}gb.sql -i ${IMPALAD_HOSTS[0]} $IMPALA_SSL
	impala-shell -f impala-insert-${FILE_SYSTEM}-${s}gb.sql -i ${IMPALAD_HOSTS[0]} $IMPALA_SSL
done

echo "Done. Next, run run_tpcds.sh to generate queries for TPC-DS"
