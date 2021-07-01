#!/bin/bash

SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

cd $SCRIPT_ROOT/hive-testbench/sample-queries-tpcds
for s in "${scale[@]}"; do
    for q in *.sql; do
        hive -i testbench.settings <<EOF
use tpcds_bin_partitioned_orc_{$s};
source ${q};
EOF
    done
done
