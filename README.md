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
