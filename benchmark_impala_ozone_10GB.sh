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
cp conf.sh conf.sh.bak
sed -i 's/scale=.*/scale=\( 10  \)/g' conf.sh

./impala-tpcds/gen_query.sh

HAS_10GB_DATA="has_10gb_impala.data"
if [ ! -f "$HAS_10GB_DATA" ]; then
    ./impala-tpcds/gen_data.sh
    if [ $? = 0 ]; then
        touch $HAS_10GB_DATA
    fi
fi

./start_profiles.sh
./impala-tpcds/run_tpcds.sh
sleep 60
./impala-tpcds/run_tpcds.sh
sleep 60
./impala-tpcds/run_tpcds.sh
./collect_profiles.sh
./impala-tpcds/collect_impala_queries.sh > impala_ozone_10gb.csv

mv conf.sh.bak conf.sh
cd $OLD_DIR
