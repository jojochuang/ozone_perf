#!/bin/bash

CURRENT_DIR=`dirname $(readlink -f $0)`

sudo yum update -y

sudo yum install -y git pssh autoconf

#./autogen.sh
#make
#make install

wget https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.0/async-profiler-2.0-linux-x64.tar.gz
wget https://github.com/jvm-profiling-tools/async-profiler/releases/download/v1.8.5/async-profiler-1.8.5-linux-x64.tar.gz

sudo tar zxvf async-profiler-2.0-linux-x64.tar.gz -C /opt/
sudo tar zxvf async-profiler-1.8.5-linux-x64.tar.gz -C /opt/

# under /tmp/async-profiler-2.0-linux-x64


wget https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz
tar zxf apache-maven-3.8.1-bin.tar.gz


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

$CURRENT_DIR/install_btrace.sh
$CURRENT_DIR/install_jemalloc.sh
