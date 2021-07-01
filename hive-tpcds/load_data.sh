#!/bin/bash

SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

# default data format is orc

cd $SCRIPT_ROOT/hive-testbench

for s in "${scale[@]}"; do
    ./tpcds-setup.sh $s
done

