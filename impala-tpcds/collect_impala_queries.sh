#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh

OLD_DIR=`pwd`

cd $CURRENT_DIR
python3 collect_impala_queries.py $CM_HOST

cd $OLD_DIR
