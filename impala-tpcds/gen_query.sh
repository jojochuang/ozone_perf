#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh

OLD_DIR=`pwd`

for s in "${scale[@]}"
do
	cd $CURRENT_DIR/tpcds-kit/tools
        QUERY_OUTPUT_DIR="/tmp/impala_tpcds_query_${s}gb"
	mkdir $QUERY_OUTPUT_DIR
	./dsqgen -DIRECTORY ../../impala-tpcds-kit/query-templates/ -INPUT ../../impala-tpcds-kit/query-templates/templates.lst -VERBOSE Y -QUALIFY Y -SCALE $s -DIALECT impala -OUTPUT_DIR $QUERY_OUTPUT_DIR

        echo "set REPLICA_PREFERENCE=$REPLICA_PREFERENCE;" | cat - $QUERY_OUTPUT_DIR/query_0.sql > .temp && mv .temp $QUERY_OUTPUT_DIR/query_0.sql

	#rsync -raP -e 'ssh -o StrictHostKeyChecking=no'  $QUERY_OUTPUT_DIR ${PASSWORDLESS_USER}@$CM_HOST:/tmp/
	cd ../../
done

cd $OLD_DIR

echo "Done. Next, run gen_data.sh to generate queries for TPC-DS"
