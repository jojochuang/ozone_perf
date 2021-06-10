#!/bin/bash
source `dirname "$0"`/conf.sh

sudo yum install gcc make flex bison byacc git


wget https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz
tar zxvf apache-maven-3.8.1-bin.tar.gz -C ~/
export PATH=$HOME/apache-maven-3.8.1/bin:$PATH

git clone https://github.com/cloudera/impala-tpcds-kit.git
# Impala of CDP PvC 7.1.x is not compatible with the tip of branch. Use this specific commit instead.
git checkout 300512fd39450dd86727ba62a063eb5377e6146c
cd impala-tpcds-kit/tpcds-gen
make
cd ../..

echo "Done. Next, run build_tpcds_kit.sh to build and install Impala's tpcds-kit"
