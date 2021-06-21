#!/bin/bash

DOMAIN=weichiu-ozone
CLUSTER_SIZE=3
CM_HOST=${DOMAIN}-1.${DOMAIN}.root.hwx.site

HOST_FILE="/tmp/cluster_hosts.txt"

OZONE_SERVICE_ID="ozone1"

JAVA_HOME_FINDER="/usr/java/jdk1.8.0_232-clouderae"
JAVA_HOME=`echo $JAVA_HOME_FINDER`
scale=( 100  )
export PATH=$PATH:$JAVA_HOME/bin/

export HADOOP_CONF_DIR=/etc/hadoop/conf
