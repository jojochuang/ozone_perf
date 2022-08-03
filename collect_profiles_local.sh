#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

OZONE_DN_PID=`pgrep -f HddsDatanodeService `
OZONE_OM_PID=`pgrep -f OzoneManagerStarter `
OZONE_SCM_PID=`pgrep -f StorageContainerManagerStarter `
if [ ! -z "$OZONE_DN_PID" ]; then
	echo "Ozone DN PID=$OZONE_DN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_dn_profile.html $OZONE_DN_PID
fi
if [ ! -z "$OZONE_OM_PID" ]; then
	echo "Ozone OM PID=$OZONE_OM_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_om_profile.html $OZONE_OM_PID
if [ ! -z "$OZONE_SCM_PID" ]; then
	echo "Ozone SCM PID=$OZONE_SCM_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_scm_profile.html $OZONE_SCM_PID
fi
