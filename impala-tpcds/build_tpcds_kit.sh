#!/bin/bash
source `dirname "$0"`/../conf.sh

HOSTS=()
while IFS= read -r line; do
  HOSTS+=("$line")
done < $SCRIPT_ROOT/../$HOST_FILE

cd `dirname "$0"`
git clone https://github.com/gregrahn/tpcds-kit.git
cd tpcds-kit/tools
make OS=LINUX

cd ../..
for host in "${HOSTS[@]}"; do
    rsync -raP -e 'ssh -o StrictHostKeyChecking=no' tpcds-kit root@$host:/tmp/
done


echo "Done. Next, run gen_query.sh to generate queries for TPC-DS"
