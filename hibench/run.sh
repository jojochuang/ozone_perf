#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

 bin/workloads/micro/wordcount/prepare/prepare.sh
 bin/workloads/micro/wordcount/spark/run.sh
