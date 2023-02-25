#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

cd $SCRIPT_ROOT/ycsb-0.17.0

bin/ycsb run hbase20 -P workloads/workloada -P small.dat -cp /etc/hbase/conf -p table=usertable -p columnfamily=family -target 100000 -threads 16 -s
