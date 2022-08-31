#!/bin/bash

# this script should be run as root

# configuration for async profiler
echo "Allow non-root user to profile kernel events"
sysctl kernel.perf_event_paranoid=1
sysctl kernel.kptr_restrict=0

# network stack configuration
# based on https://github.com/teamclairvoyant/hadoop-deployment-bash/blob/master/tune_kernel.sh
./tune_kernel.sh
