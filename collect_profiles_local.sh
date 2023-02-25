#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

OZONE_DN_PID=`pgrep -f HddsDatanodeService`
OZONE_OM_PID=`pgrep -f OzoneManagerStarter`
OZONE_SCM_PID=`pgrep -f StorageContainerManagerStarter`
OZONE_RECON_PID=`pgrep -f ReconServer `

HDFS_NN_PID=`pgrep -f NameNode`
HDFS_DN_PID=`pgrep -f DataNode`

IMPALAD_PID=`pgrep impalad`

HBASE_REGIONSERVER_PID=`pgrep -f HRegionServer`
YCSB_PID=`pgrep -f site.ycsb.Client`

rm -f /tmp/*_profile.html

if [ ! -z "$OZONE_DN_PID" ]; then
	echo "Ozone DN PID=$OZONE_DN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_dn_profile.html $OZONE_DN_PID
fi
if [ ! -z "$OZONE_OM_PID" ]; then
	echo "Ozone OM PID=$OZONE_OM_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_om_profile.html $OZONE_OM_PID
fi
if [ ! -z "$OZONE_SCM_PID" ]; then
	echo "Ozone SCM PID=$OZONE_SCM_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_scm_profile.html $OZONE_SCM_PID
fi
if [ ! -z "$OZONE_RECON_PID" ]; then
	echo "Ozone Recon PID=$OZONE_RECON_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_recon_profile.html  $OZONE_RECON_PID
fi

if [ ! -z "$HDFS_NN_PID" ]; then
	echo "HDFS NN PID=$HDFS_NN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/hdfs_nn_profile.html  $HDFS_NN_PID
fi
if [ ! -z "$HDFS_DN_PID" ]; then
	echo "HDFS DN PID=$HDFS_DN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/hdfs_dn_profile.html $HDFS_DN_PID
fi

if [ ! -z "$IMPALAD_PID" ]; then
	echo "Impalad PID=$IMPALAD_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/impalad_profile.html $IMPALAD_PID
fi

if [ ! -z "$HBASE_REGIONSERVER_PID" ]; then
	echo "HBase RegionServer PID=$HBASE_REGIONSERVER_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/hbase_rs_profile.html $HBASE_REGIONSERVER_PID
fi

if [ ! -z "$YCSB_PID" ]; then
	echo "YCSB PID=$YCSB_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ycsb_profile.html $YCSB_PID
fi
chown ${PASSWORDLESS_USER} /tmp/*_profile.html
