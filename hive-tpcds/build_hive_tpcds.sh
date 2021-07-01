#!/bin/bash

SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

cd $SCRIPT_ROOT
git clone https://github.com/hortonworks/hive-testbench.git
cd hive-testbench

./tpcds-build.sh
