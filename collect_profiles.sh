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
	ssh ${PASSWORDLESS_USER}@$host "sudo /tmp/ozone_perf/collect_profiles_local.sh"
done

# send back profiles

DEST_DIR="/tmp/ozone_profiles-`date '+%F-%H-%M-%S'`"
mkdir $DEST_DIR

echo "Collecting profiles"
for host in "${HOSTS[@]}"; do
	echo $host
	scp ${PASSWORDLESS_USER}@$host:/tmp/ozone_dn_profile.html ${DEST_DIR}/ozone_dn-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/ozone_om_profile.html ${DEST_DIR}/ozone_om-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/ozone_scm_profile.html ${DEST_DIR}/ozone_scm-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/ozone_recon_profile.html ${DEST_DIR}/ozone_recon-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/hdfs_nn_profile.html ${DEST_DIR}/hdfs_nn-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/hdfs_dn_profile.html ${DEST_DIR}/hdfs_dn-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/impalad_profile.html ${DEST_DIR}/impalad-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/hbase_rs_profile.html ${DEST_DIR}/hbase_rs-${host}.html
	scp ${PASSWORDLESS_USER}@$host:/tmp/ycsb_profile.html ${DEST_DIR}/ycsb-${host}.html
done

tar zcvf ${DEST_DIR}.tgz ${DEST_DIR}
echo "Profiles are available in ${DEST_DIR}.tgz"
