#!/bin/bash
source ~/.bashrc
CURRENT_DIR=`dirname "$0"`
source $CURRENT_DIR/../conf.sh

$CURRENT_DIR/create_ozone_dir.sh

for s in "${scale[@]}"
do
    NUM_EXECUTORS=$(( $s / 10 ))
    spark-shell     --conf spark.executor.instances=${NUM_EXECUTORS}     --conf spark.executor.cores=3     --conf spark.executor.memory=4g     --conf spark.executor.memoryOverhead=2g --conf spark.driver.memory=4g     --jars $CURRENT_DIR/spark-sql-perf/target/scala-2.11/spark-sql-perf-assembly-0.5.0-SNAPSHOT.jar <<EOF



val sqlContext = new org.apache.spark.sql.SQLContext(sc)

import com.databricks.spark.sql.perf.tpcds.TPCDSTables

// Set:
val rootDir = "o3fs://tpcds${s}gb.sparksqldata.ozone1/"

val databaseName = "o3_${s}gb" // name of database to create.

val scaleFactor = "${s}" // scaleFactor defines the size of the dataset to generate (in GB).
val format = "parquet" // valid spark format like parquet "parquet".
// Run:
val tables = new TPCDSTables(sqlContext,
    dsdgenDir = "/tmp/tpcds-kit/tools", // location of dsdgen
    scaleFactor = scaleFactor,
    useDoubleForDecimal = false, // true to replace DecimalType with DoubleType
    useStringForDate = false) // true to replace DateType with StringType

tables.genData(
    location = rootDir,
    format = format,
    overwrite = true, // overwrite the data that is already there
    partitionTables = true, // create the partitioned fact tables 
    clusterByPartitionColumns = true, // shuffle to get partitions coalesced into single files. 
    filterOutNullPartitionValues = false, // true to filter out the partition with NULL key value
    tableFilter = "", // "" means generate all tables
    numPartitions = ${s}) // how many dsdgen partitions to run - number of input tasks.

// Create the specified database
sql(s"create database $databaseName")
// Create metastore tables in a specified database for your data.
// Once tables are created, the current database will be switched to the specified database.
tables.createExternalTables(rootDir, "parquet", databaseName, overwrite = true, discoverPartitions = true)
// Or, if you want to create temporary tables
// tables.createTemporaryTables(location, format)

// For CBO only, gather statistics on all columns:
tables.analyzeTables(databaseName, analyzeColumns = true)


EOF

done

echo "Data generated. Run ./run_tpcds.sh to start TPC-DS"
