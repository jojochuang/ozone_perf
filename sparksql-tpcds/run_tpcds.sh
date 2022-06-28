#!/bin/bash
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh

for s in "${scale[@]}"
do
    NUM_EXECUTORS=$(( $s / 10 ))
    if [ "$FILE_SYSTEM" == "ozone" ]; then
        DATABASE_NAME="o3_${SPARK_SQL_FILE_FORMAT}_${s}gb"
    elif [ "$FILE_SYSTEM" == "hdfs" ]; then
        DATABASE_NAME="hdfs_${SPARK_SQL_FILE_FORMAT}_${s}gb"
    fi
    spark-shell \
--conf "spark.yarn.dist.archives=hdfs:///tmp/${ASYNC_PROFILER_TARBALL}#async-profiler2" \
--conf "spark.executor.extraJavaOptions=-agentpath:./async-profiler2/async-profiler-2.8.1-linux-x64/build/libasyncProfiler.so=start,svg=samples,event=cpu,file=./app_flamegraph.html" \
--conf spark.executor.instances=${NUM_EXECUTORS} \
--conf spark.executor.cores=3 \
--conf spark.executor.memory=4g \
--conf spark.executor.memoryOverhead=2g \
--conf spark.driver.memory=4g \
--jars $CURRENT_DIR/spark-sql-perf/target/scala-2.11/spark-sql-perf-assembly-0.5.0-SNAPSHOT.jar <<EOF
import com.databricks.spark.sql.perf.tpcds.TPCDS

val sqlContext = new org.apache.spark.sql.SQLContext(sc)

val tpcds = new TPCDS (sqlContext = sqlContext)
// Set:
val databaseName = "${DATABASE_NAME}" // name of database with TPCDS data.
val resultLocation = "/tmp/spark_tpcds/" // place to write results
val iterations = 1 // how many iterations of queries to run.
sql(s"use " + databaseName)
val queries = tpcds.tpcds2_4Queries // queries to run.
val timeout = 24*60*60 // timeout, in seconds.
// Run:
val experiment = tpcds.runExperiment(
  queries, 
  iterations = iterations,
  resultLocation = resultLocation,
  forkThread = true)
experiment.waitForFinish(timeout)

EOF

done
