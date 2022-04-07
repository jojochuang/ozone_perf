#!/bin/bash
source `dirname "$0"`/../conf.sh

ozone sh volume create o3://$OZONE_SERVICE_ID/sparksqldata

ozone sh bucket create o3://$OZONE_SERVICE_ID/sparksqldata/tpcds100gb
ozone sh bucket create o3://$OZONE_SERVICE_ID/sparksqldata/tpcds1000gb
ozone sh bucket create o3://$OZONE_SERVICE_ID/sparksqldata/tpcds3000gb
ozone sh bucket create o3://$OZONE_SERVICE_ID/sparksqldata/tpcds10000gb

hdfs dfs -mkdir /tmp/sparksqldata

hdfs dfs -mkdir /tmp/sparksqldata/tpcds100gb
hdfs dfs -mkdir /tmp/sparksqldata/tpcds1000gb
hdfs dfs -mkdir /tmp/sparksqldata/tpcds3000gb
hdfs dfs -mkdir /tmp/sparksqldata/tpcds10000gb
