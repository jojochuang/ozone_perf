#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/../conf.sh

cp conf/hadoop.conf.template conf/hadoop.conf

cat <<EOF >> conf/hadoop.conf 
hibench.hadoop.executable     /usr/bin/hadoop
hibench.hadoop.configure.dir  /etc/hadoop/conf
hibench.hdfs.master       ofs://ozone1/vol1/bucket1/
EOF

cat <<EOF >> conf/hibench.conf 
hibench.hadoop.examples.jar              /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples-3.1.1.7.1.8.0-801.jar
hibench.hadoop.examples.test.jar              /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-client-jobclient-tests.jar
EOF

cp conf/spark.conf.template conf/spark.conf

cat <<EOF >> conf/spark.conf 
hibench.spark.home      /usr/
hibench.streambench.spark.checkpointPath ofs://ozone1/vol1/bucket1/
EOF
