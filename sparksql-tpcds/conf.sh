#!/bin/bash

DOMAIN=weichiu-ozone
CLUSTER_SIZE=3
DOMAIN_BASENAME=".root.hwx.site"

OZONE_SERVICE_ID="ozone1"

JAVA_HOME_FINDER="/usr/java/jdk1.8*"
JAVA_HOME=`echo $JAVA_HOME_FINDER`
export PATH=$PATH:$JAVA_HOME/bin/

export HADOOP_CONF_DIR=/etc/hadoop/conf
