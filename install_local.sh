#!/bin/bash
source `dirname "$0"`/conf.sh
CURRENT_DIR=`dirname $(readlink -f $0)`

sudo yum update -y

sudo yum install -y git pssh autoconf

# required by impala-tpcds-kit
sudo yum install -y git gcc make flex bison byacc curl unzip patch

if [ ! -f "/tmp/$ASYNC_PROFILER_TARBALL" ]; then
    wget $ASYNC_PROFILER_DOWNLOAD_PATH -P /tmp/
    sudo tar zxvf /tmp/$ASYNC_PROFILER_TARBALL -C /opt/
fi
if [ ! -f "/tmp/async-profiler-1.8.5-linux-x64.tar.gz" ]; then
    wget https://github.com/jvm-profiling-tools/async-profiler/releases/download/v3.8.5/async-profiler-1.8.5-linux-x64.tar.gz -P /tmp/
    sudo tar zxvf /tmp/async-profiler-1.8.5-linux-x64.tar.gz -C /opt/
fi

if [ ! -f "apache-maven-${MVN_VERSION}-bin.tar.gz" ]; then
    wget https://downloads.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
    tar zxvf apache-maven-${MVN_VERSION}-bin.tar.gz -C ~/
fi


sudo yum install -y python3 cmake3 snappy-devel

sudo alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake 10 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake \
--family cmake

sudo alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
--family cmake

sudo pip install cm_client

$CURRENT_DIR/install_btrace.sh
$CURRENT_DIR/install_jemalloc.sh
