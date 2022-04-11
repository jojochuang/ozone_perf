#!/bin/bash

# configure these
DOMAIN=weichiu
CM_HOST=${DOMAIN}-1.${DOMAIN}.root.hwx.site
# choose between http or https
export CM_HTTP=http
export OZONE_SERVICE_ID="ozone1"

# FILE_SYSTEM is ozone or hdfs
export FILE_SYSTEM="ozone" 
#export FILE_SYSTEM="hdfs" 

if [ "$FILE_SYSTEM" == "ozone" ]; then
    # choose between o3fs and ofs
    export FILE_SYSTEM_PREFIX="ofs://$OZONE_SERVICE_ID/vol1/bucket"
    #FILE_SYSTEM_PREFIX="o3fs://$OZONE_SERVICE_ID.vol1.ozone1"
elif [ "$FILE_SYSTEM" == "hdfs" ]; then
    export FILE_SYSTEM_PREFIX=""
fi
KERBEROS=true

JAVA_HOME_FINDER="/usr/java/jdk1.8.0_*"
scale=( 100  )

# don't touch the following
SCRIPT_ROOT=`dirname "$0"`
HOST_FILE="cluster_hosts.txt"
IMPALAD_HOST_FILE="cluster_hosts_impalad.txt"
REGIONSERVER_HOST_FILE="cluster_hosts_regionserver.txt"
JAVA_HOME=`echo $JAVA_HOME_FINDER`
export PATH=$PATH:$JAVA_HOME/bin/
export HADOOP_CONF_DIR=/etc/hadoop/conf
