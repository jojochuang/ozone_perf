#!/bin/bash
source `dirname "$0"`/conf.sh


cd tpcds-kit/tools

for s in "${SCALES[@]}"
do
	mkdir /tmp/impala_tpcds_query_${s}gb
	./dsqgen -DIRECTORY ../../impala-tpcds-kit/query-templates/ -INPUT ../../impala-tpcds-kit/query-templates/templates.lst -VERBOSE Y -QUALIFY Y -SCALE 1000 -DIALECT impala -OUTPUT_DIR /tmp/impala_tpcds_query_${s}gb

	rsync -raP -e 'ssh -o StrictHostKeyChecking=no'  /tmp/impala_tpcds_query_${s}gb root@ozmaster1.hpecdp.com:/tmp/
done

echo "Done. Next, run gen_data.sh to generate queries for TPC-DS"
