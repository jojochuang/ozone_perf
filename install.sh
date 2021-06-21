#!/bin/bash
source `dirname "$0"`/conf.sh


HOSTS=()
while IFS= read -r line; do
  HOSTS+=("$line")
done < $HOST_FILE


for host in "${HOSTS[@]}"; do
	echo $host
	rsync -raP -e 'ssh -o StrictHostKeyChecking=no' . systest@$host:/tmp/ozone_perf  &
done

for job in `jobs -p`
do
        echo "Waiting for completion of job " $job
        wait $job
done

for host in "${HOSTS[@]}"; do
	echo $i
	ssh systest@$host /tmp/ozone_perf/install_local.sh &
done

for job in `jobs -p`
do
        echo "Waiting for completion of job " $job
        wait $job
done

