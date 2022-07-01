#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

sudo yum install -y gcc make flex bison byacc git


export PATH=$HOME/apache-maven-${MVN_VERSION}/bin:$PATH

cd $SCRIPT_ROOT
git clone https://github.com/cloudera/impala-tpcds-kit.git
cd impala-tpcds-kit
# The tip of the repo does not run on CDP PvC 7.1
git checkout 300512fd39450dd86727ba62a063eb5377e6146c
cd tpcds-gen
make
cd ../..

echo "Done. Next, run build_tpcds_kit.sh to build and install Impala's tpcds-kit"
