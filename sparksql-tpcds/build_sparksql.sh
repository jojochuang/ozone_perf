#!/bin/bash
source `dirname "$0"`/../conf.sh

cd `dirname "$0"`
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install -y sbt
sudo yum install -y gcc make flex bison byacc git

# build sbt-spark-package from source locally
if [ ! -f "eb823d6d3c9fd642334b886103b57de14e00acbd.zip" ]; then
    wget https://github.com/databricks/sbt-spark-package/archive/eb823d6d3c9fd642334b886103b57de14e00acbd.zip
    unzip eb823d6d3c9fd642334b886103b57de14e00acbd.zip
    cd sbt-spark-package-eb823d6d3c9fd642334b886103b57de14e00acbd/
    sbt publishLocal
    cd ..
fi

git clone https://github.com/databricks/spark-sql-perf.git
cd spark-sql-perf/
# support spark 2.4 and scala 2.11
git checkout 85bbfd4ca22b386b3216af5434b44ad3b6a32b58

sbt 'set test in Test := {}' assembly

echo "Done. Next, run build_tpcds_kit.sh to build and install DataBricks' tpcds-kit"
