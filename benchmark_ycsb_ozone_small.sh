#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/conf.sh

OLD_DIR=`pwd`

if [ "$KERBEROS" = true ]; then
    klist
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "No kerberos ticket or expired. Abort"
        exit $retval
    fi
fi

cd $CURRENT_DIR

#./hbase-ycsb/load_data.sh

./start_profiles.sh
./hbase-ycsb/run_ycsb_small.sh
#sleep 60
#./hbase-ycsb/run_ycsb_small.sh
#sleep 60
#./hbase-ycsb/run_ycsb_small.sh
./collect_profiles.sh
#./impala-tpcds/collect_impala_queries.sh > impala_ozone_10gb.csv

cd $OLD_DIR
