#!/bin/bash

# configure these
DOMAIN=weichiu-ozone
CM_HOST=${DOMAIN}-1.${DOMAIN}.root.hwx.site
OZONE_SERVICE_ID="ozone1"

JAVA_HOME_FINDER="/usr/java/jdk1.8.0_*"
scale=( 100  )

# don't touch the following
export PATH=$PATH:$JAVA_HOME/bin/
export HADOOP_CONF_DIR=/etc/hadoop/conf
SCRIPT_ROOT=`dirname "$0"`
HOST_FILE="cluster_hosts.txt"
IMPALAD_HOST_FILE="cluster_hosts_impalad.txt"
JAVA_HOME=`echo $JAVA_HOME_FINDER`
