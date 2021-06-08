#!/bin/bash
source `dirname "$0"`/conf.sh


cd /home/weichiu/tpcds-kit/tools
mkdir /tmp/impala_tpcds_query_1tb
./dsqgen -DIRECTORY ../../impala-tpcds-kit/query-templates/ -INPUT ../../impala-tpcds-kit/query-templates/templates.lst -VERBOSE Y -QUALIFY Y -SCALE 1000 -DIALECT impala -OUTPUT_DIR /tmp/impala_tpcds_query_1tb

rsync -raP -e 'ssh -o StrictHostKeyChecking=no'  /tmp/impala_tpcds_query_1tb root@rhel01.ozone.cisco.local:/tmp/

echo "Done. Next, run gen_query.sh to generate queries for TPC-DS"
