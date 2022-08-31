#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

OZONE_DN_PID=`pgrep -f HddsDatanodeService `
OZONE_OM_PID=`pgrep -f OzoneManagerStarter `
OZONE_SCM_PID=`pgrep -f StorageContainerManagerStarter `

HDFS_NN_PID=`pgrep -f NameNode`
HDFS_DN_PID=`pgrep -f DataNode`

IMPALAD_PID=`pgrep impalad`

if [ ! -z "$OZONE_DN_PID" ]; then
	echo "Ozone DN PID=$OZONE_DN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh start $OZONE_DN_PID
fi
if [ ! -z "$OZONE_OM_PID" ]; then
	echo "Ozone OM PID=$OZONE_OM_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh start $OZONE_OM_PID
fi
if [ ! -z "$OZONE_SCM_PID" ]; then
	echo "Ozone SCM PID=$OZONE_SCM_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh start $OZONE_SCM_PID
fi

if [ ! -z "$HDFS_NN_PID" ]; then
	echo "HDFS NN PID=$HDFS_NN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh start $HDFS_NN_PID
fi
if [ ! -z "$HDFS_DN_PID" ]; then
	echo "HDFS DN PID=$HDFS_DN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh start $HDFS_DN_PID
fi

if [ ! -z "$IMPALAD_PID" ]; then
	echo "Impalad PID=$IMPALAD_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh start $IMPALAD_PID
fi
