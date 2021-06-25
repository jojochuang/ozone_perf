#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

cd $SCRIPT_ROOT
if [ ! -f "ycsb-0.17.0" ]; then
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
    tar xfvz ycsb-0.17.0.tar.gz
fi
cd ycsb-0.17.0
