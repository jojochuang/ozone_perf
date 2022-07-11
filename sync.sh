#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

HOSTS=()
while IFS= read -r line; do
  HOSTS+=("$line")
done < $HOST_FILE


for host in "${HOSTS[@]}"; do
	echo $host
	rsync -raP -e 'ssh -o StrictHostKeyChecking=no' --exclude ".*" --exclude "*/.*" . ${PASSWORDLESS_USER}@$host:/tmp/ozone_perf  &
done

for job in `jobs -p`
do
        echo "Waiting for completion of job " $job
        wait $job
done
