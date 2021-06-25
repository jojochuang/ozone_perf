#!/bin/bash
source `dirname "$0"`/../conf.sh

HOSTS=()
while IFS= read -r line; do
  HOSTS+=("$line")
done < $SCRIPT_ROOT/../$HOST_FILE

cd `dirname "$0"`
if [ ! -f "tpcds-kit" ]; then
    git clone https://github.com/databricks/tpcds-kit.git
    cd tpcds-kit/tools
    make OS=LINUX
    cd ../..
fi

for host in "${HOSTS[@]}"; do
    rsync -raP -e 'ssh -o StrictHostKeyChecking=no' tpcds-kit systest@$host:/tmp/
done


echo "Done. Next, run gen_data.sh to generate data for TPC-DS"
