#!/bin/bash
source `dirname "$0"`/conf.sh

git clone https://github.com/databricks/tpcds-kit.git
cd tpcds-kit/tools
make OS=LINUX

cd ../..
for i in {1..3}; do rsync -raP -e 'ssh -o StrictHostKeyChecking=no' tpcds-kit systest@$DOMAIN-${i}.$DOMAIN$DOMAIN_BASENAME:/tmp/; done


echo "Done. Next, run gen_data.sh to generate data for TPC-DS"
