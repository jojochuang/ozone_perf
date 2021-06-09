#!/bin/bash

DOMAIN=ozworker
CLUSTER_SIZE=10
DOMAIN_BASENAME="hpecdp.com"

OZONE_SERVICE_ID="ozone1"

JAVA_HOME_FINDER="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.292.b10-1.el7_9.x86_64/"
JAVA_HOME=`echo $JAVA_HOME_FINDER`
export PATH=$PATH:$JAVA_HOME/bin/

export HADOOP_CONF_DIR=/etc/hadoop/conf
