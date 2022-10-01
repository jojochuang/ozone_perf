#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

# profile Ozone DN processes on all nodes

# send commands to all hosts
HOSTS=()
while IFS= read -r line; do
  HOSTS+=("$line")
done < $HOST_FILE


for host in "${HOSTS[@]}"; do
	echo $host
	ssh ${PASSWORDLESS_USER}@$host 'sudo /tmp/ozone_perf/start_profiles_local.sh'
done

