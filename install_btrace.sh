#/bin/bash
if [ ! -f "btrace-2.1.0-bin.tar.gz" ]; then
    wget https://github.com/btraceio/btrace/releases/download/v2.1.0/btrace-2.1.0-bin.tar.gz
    tar zxf btrace-2.1.0-bin.tar.gz
fi

