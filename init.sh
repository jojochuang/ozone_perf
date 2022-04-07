#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

pip install cm_client

# ask CM for list of hosts.
python get_hosts.py $CM_HOST all > $HOST_FILE
# ask CM for list of ImpalaD hosts.
python get_hosts.py $CM_HOST IMPALAD > $IMPALAD_HOST_FILE
# ask CM for list of HBase RegionServer hosts.
python get_hosts.py $CM_HOST REGIONSERVER > $REGIONSERVER_HOST_FILE

if [ "$KERBEROS" = "true" ]; then
    ssh systest@${CM_HOST} sudo -u hdfs kinit -kt /cdep/keytabs/hdfs.keytab hdfs
fi

if [ "$FILE_SYSTEM" == "ozone" ]; then
    ssh systest@${CM_HOST} sudo -u hdfs ozone shell volume create o3://$OZONE_SERVICE_ID/vol1
    ssh systest@${CM_HOST} sudo -u hdfs ozone shell bucket create o3://$OZONE_SERVICE_ID/vol1/bucket1

    ssh systest@${CM_HOST} sudo -u hdfs hdfs dfs -mkdir -p $FILE_SYSTEM_PREFIX/managed/hive
    ssh systest@${CM_HOST} sudo -u hdfs hdfs dfs -mkdir -p $FILE_SYSTEM_PREFIX/external/hive
fi
# TODO: check to make sure the directories are created properly

python ./reconf_cluster.py ${CM_HOST}

./sync.sh
./install.sh

if [ "$KERBEROS" = "true" ]; then
    ssh systest@${CM_HOST} kinit -kt /cdep/keytabs/systest.keytab systest
fi
ssh systest@${CM_HOST} /tmp/ozone_perf/impala-tpcds/build_impala_tpcds.sh
ssh systest@${CM_HOST} /tmp/ozone_perf/impala-tpcds/build_tpcds_kit.sh
ssh systest@${CM_HOST} /tmp/ozone_perf/impala-tpcds/gen_query.sh

ssh systest@${CM_HOST} /tmp/ozone_perf/sparksql-tpcds/build_sparksql.sh
ssh systest@${CM_HOST} /tmp/ozone_perf/sparksql-tpcds/build_tpcds_kit.sh
ssh systest@${CM_HOST} /tmp/ozone_perf/sparksql-tpcds/create_ozone_dir.sh

ssh systest@${CM_HOST} /tmp/ozone_perf/hbase-ycsb/install_ycsb.sh
if [ "$KERBEROS" = "true" ]; then
    ssh systest@${CM_HOST} kinit -kt /cdep/keytabs/hbase.keytab hbase
fi
ssh systest@${CM_HOST} /tmp/ozone_perf/hbase-ycsb/create_table.sh

echo "Next, go to $CM_HOST, to run Impala TPC-DS, first generate data by running /tmp/ozone_perf/impala-tpcds/gen_data.sh"
echo " and then run queries: /tmp/ozone_perf/impala-tpcds/run_tpcds.sh"
echo " analyze the result: python /tmp/ozone_perf/impala-tpcds/collect_impala_queries.py"

echo "for SparkSQL TPC-DS, first generate data by running /tmp/ozone_perf/sparksql-tpcds/gen_data.sh"
echo " and then run queries: /tmp/ozone_perf/sparksql-tpcds/run_tpcds.sh"
