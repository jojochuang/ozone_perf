#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

OZONE_DN_PID=`pgrep -f HddsDatanodeService `
STATUS_CODE=$?
if [ $STATUS_CODE -eq 0 ]; then
	echo "Ozone DN PID=$OZONE_DN_PID"
	/opt/async-profiler-2.8.1-linux-x64/profiler.sh stop -f /tmp/ozone_dn_profile.html $OZONE_DN_PID
else
	echo "Skip. No Ozone DataNode"
fi

