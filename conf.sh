#!/bin/bash

# configure these
DOMAIN=weichiu
CM_HOST=${DOMAIN}-1.${DOMAIN}.root.hwx.site
PASSWORDLESS_USER="systest"
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

# select between 'sequencefile', 'rcfile', 'orc', 'parquet', 'textfile' and 'avro'.
SPARK_SQL_FILE_FORMAT="parquet"
#SPARK_SQL_FILE_FORMAT="orc"

KERBEROS=true

JAVA_HOME_FINDER="/usr/java/jdk1.8.0_*"
scale=( 100  )

# don't touch the following
SCRIPT_ROOT=`dirname "$0"`
HOST_FILE="cluster_hosts.txt"
IMPALAD_HOST_FILE="cluster_hosts_impalad.txt"
REGIONSERVER_HOST_FILE="cluster_hosts_regionserver.txt"
ASYNC_PROFILER_TARBALL="async-profiler-2.8.1-linux-x64.tar.gz"
ASYNC_PROFILER_DOWNLOAD_PATH="https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8.1/$ASYNC_PROFILER_TARBALL"
JAVA_HOME=`echo $JAVA_HOME_FINDER`
MVN_VERSION="3.8.6"
export PATH=$PATH:$JAVA_HOME/bin/
export HADOOP_CONF_DIR=/etc/hadoop/conf
