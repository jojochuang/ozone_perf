# ozone_perf

Scripts that automates SparkSQL and Impala TPC-DS executions on top of Ozone. The script relies on Cloudera Manager for cluster information, so the cluster must be managed by CM.

To get started, run 

1. Edit conf.sh. Change these variables: 

| Variable              | Description                          | Example                                 |
|-----------------------|--------------------------------------|-----------------------------------------|
| CM_HOST               | Cloudera Manager server name         | weichiu-1.weichiu.root.hwx.site         |
| JAVA_HOME_FINDER      | expression to locate Java home dir   |                                         |
| scale                 | the set of scale to be run.          | (100 1000) to run 100GB and 1TB data set|

2. run the following command
./init.sh

3. Go to the CM host. To run Impala TPC-DS, , first generate data by running /tmp/ozone_perf/impala-tpcds/gen_data.sh
and then run queries: /tmp/ozone_perf/impala-tpcds/run_tpcds.sh
analyze the result: python /tmp/ozone_perf/impala-tpcds/collect_impala_queries.py

for SparkSQL TPC-DS, first generate data by running /tmp/ozone_perf/sparksql-tpcds/gen_data.sh
and then run queries: /tmp/ozone_perf/sparksql-tpcds/run_tpcds.sh
