#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/conf.sh

OLD_DIR=`pwd`

cd $CURRENT_DIR
cp conf.sh conf.sh.bak
sed -i 's/scale=.*/scale=\( 3000  \)/g' conf.sh

./impala-tpcds/gen_query.sh

HAS_3TB_DATA="has_3tb_impala.data"
if [ ! -f "$HAS_3TB_DATA" ]; then
    ./impala-tpcds/gen_data.sh
    if [ $? = 0 ]; then
        touch $HAS_3TB_DATA
    fi
fi

./start_profiles.sh
./impala-tpcds/run_tpcds.sh
sleep 60
./impala-tpcds/run_tpcds.sh
sleep 60
./impala-tpcds/run_tpcds.sh
./collect_profiles.sh
./impala-tpcds/collect_impala_queries.sh > impala_ozone_3tb.csv

mv conf.sh.bak conf.sh
cd $OLD_DIR
