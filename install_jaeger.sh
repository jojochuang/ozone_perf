#!/bin/bash
source `dirname "$0"`/conf.sh

HOST=$1
ssh ${PASSWORDLESS_USER}@$HOST "cd /tmp/ && wget https://github.com/jaegertracing/jaeger/releases/download/v1.51.0/jaeger-1.51.0-linux-amd64.tar.gz"
