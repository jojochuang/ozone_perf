#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

# HBase recommends n_splits (10 * number of regionservers)
NUM_RS=`wc -l < $SCRIPT_ROOT/../$REGIONSERVER_HOST_FILE`

N_SPLITS=$(( 10 * $NUM_RS ))

echo $N_SPLITS

hbase shell <<EOF
n_splits = $N_SPLITS
create 'usertable', 'family', {SPLITS => (1..n_splits).map {|i| "user#{1000+i*(9999-1000)/n_splits}"}}

EOF

# TODO: PREFETCH_BLOCKS_ON_OPEN => 'true'
