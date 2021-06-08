#!/bin/bash
source `dirname "$0"`/conf.sh

sudo yum install gcc make flex bison byacc git

git clone https://github.com/cloudera/impala-tpcds-kit.git

echo "Done. Next, run build_tpcds_kit.sh to build and install Impala's tpcds-kit"
