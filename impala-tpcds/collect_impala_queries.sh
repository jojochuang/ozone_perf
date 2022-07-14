#!/bin/bash
source `dirname "$0"`/../conf.sh

python collect_impala_queries.py $CM_HOST
