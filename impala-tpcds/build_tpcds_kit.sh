#!/bin/bash
source `dirname "$0"`/conf.sh

git clone https://github.com/gregrahn/tpcds-kit.git
cd tpcds-kit/tools
make OS=LINUX

cd ../..
for i in {1..$CLUSTER_SIZE} do rsync -raP -e 'ssh -o StrictHostKeyChecking=no' tpcds-kit root@$DOMAIN-${i}.$DOMAIN_BASENAME:/tmp/; done


echo "Done. Next, run gen_query.sh to generate queries for TPC-DS"
