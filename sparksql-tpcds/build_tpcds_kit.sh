#!/bin/bash

git clone https://github.com/databricks/tpcds-kit.git
cd tpcds-kit/tools
make OS=LINUX

for i in {1..3}; do rsync -raP -e 'ssh -o StrictHostKeyChecking=no' ~/tpcds-kit systest@weichiu-${i}.weichiu.root.hwx.site:/tmp/; done


echo "Done. Next, run gen_data.sh to generate data for TPC-DS"
