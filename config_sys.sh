#!/bin/bash

# this script should be run as root

echo "Allow non-root user to profile kernel events"
sysctl kernel.perf_event_paranoid=1
sysctl kernel.kptr_restrict=0
