#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

sudo yum install -y gcc make flex bison byacc git


export PATH=$HOME/apache-maven-3.8.1/bin:$PATH

cd $SCRIPT_ROOT
git clone https://github.com/cloudera/impala-tpcds-kit.git
# The tip of the repo does not run on CDP PvC 7.1
git checkout 300512fd39450dd86727ba62a063eb5377e6146c
cd impala-tpcds-kit/tpcds-gen
make
cd ../..

echo "Done. Next, run build_tpcds_kit.sh to build and install Impala's tpcds-kit"
