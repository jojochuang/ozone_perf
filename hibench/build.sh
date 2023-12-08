#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

git clone https://github.com/Intel-bigdata/HiBench.git
# TODO: check out a specific release

cd HiBench/
mvn -Phadoopbench -Dspark=2.4 -Dscala=2.11 clean package
