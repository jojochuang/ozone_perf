#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

cd $SCRIPT_ROOT/ycsb-0.17.0

# create 1B records, run for 10M times
cat > large.dat <<EOF
recordcount=1000000000
operationcount=1000000
EOF

# create 1M records, run for 100K times
cat > small.dat <<EOF
recordcount=1000000
operationcount=100000
EOF

#bin/ycsb load hbase20 -P workloads/workloada -cp /etc/hbase/conf -p table=usertable -p columnfamily=family -target 100000 -threads 16 -s -P large.dat
bin/ycsb load hbase20 -P workloads/workloada -cp /etc/hbase/conf -p table=usertable -p columnfamily=family -target 100000 -threads 16 -s -P small.dat

