#!/bin/bash
SCRIPT_ROOT=`dirname "$0"`
source $SCRIPT_ROOT/conf.sh

# send commands to all hosts
HOSTS=()
while IFS= read -r line; do
  HOSTS+=("$line")
done < $HOST_FILE


echo "Stopping profilers"
for host in "${HOSTS[@]}"; do
	echo $host
	ssh ${PASSWORDLESS_USER}@$host "/tmp/ozone_perf/collect_profiles_local.sh"
done

for job in `jobs -p`
do
        echo "Waiting for completion of job " $job
        wait $job
done

# send back profiles

DEST_DIR="/tmp/ozone_dn_profiles-`date '+%F-%H-%M-%S'`"
mkdir $DEST_DIR

echo "Collecting profiles"
for host in "${HOSTS[@]}"; do
	echo $host
	scp ${PASSWORDLESS_USER}@$host:/tmp/ozone_dn_profile.html ${DEST_DIR}/ozone_dn-${host}.html
done

tar zcvf ${DEST_DIR}.tgz ${DEST_DIR}
