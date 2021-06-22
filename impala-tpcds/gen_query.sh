#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh

for s in "${scale[@]}"
do
	cd $CURRENT_DIR/tpcds-kit/tools
	mkdir /tmp/impala_tpcds_query_${s}gb
	./dsqgen -DIRECTORY ../../impala-tpcds-kit/query-templates/ -INPUT ../../impala-tpcds-kit/query-templates/templates.lst -VERBOSE Y -QUALIFY Y -SCALE $s -DIALECT impala -OUTPUT_DIR /tmp/impala_tpcds_query_${s}gb

	rsync -raP -e 'ssh -o StrictHostKeyChecking=no'  /tmp/impala_tpcds_query_${s}gb root@$CM_HOST:/tmp/
done

echo "Done. Next, run gen_data.sh to generate queries for TPC-DS"
