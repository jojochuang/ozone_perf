
# to use this script, 
# ref: https://cloudera.github.io/cm_api/docs/python-client-swagger/
# ref: https://archive.cloudera.com/cm7/7.0.3/generic/jar/cm_api/swagger-html-sdk-docs/python/README.html
# $ source ~/PYTHON3.7/bin/activate
# python reconf_cluster.py

import cm_client
from cm_client.rest import ApiException
from pprint import pprint
import sys
import time
import os

# Configure HTTP basic authorization: basic
cm_client.configuration.username = 'admin'
cm_client.configuration.password = 'admin'
cm_client.configuration.verify_ssl = False

file_system_prefix = os.environ["FILE_SYSTEM_PREFIX"]
ozone_service_id = os.environ["OZONE_SERVICE_ID"]

def wait(cmd, timeout=None):
    SYNCHRONOUS_COMMAND_ID = -1
    if cmd.id == SYNCHRONOUS_COMMAND_ID:
        return cmd

    SLEEP_SECS = 5
    if timeout is None:
        deadline = None
    else:
        deadline = time.time() + timeout

    try:
        cmd_api_instance = cm_client.CommandsResourceApi(api_client)
        while True:
            cmd = cmd_api_instance.read_command(int(cmd.id))
            #pprint(cmd)
            if not cmd.active:
                return cmd

            if deadline is not None:
                now = time.time()
                if deadline < now:
                    return cmd
                else:
                    time.sleep(min(SLEEP_SECS, deadline - now))
            else:
                time.sleep(SLEEP_SECS)
    except ApiException as e:
        print("Exception reading and waiting for command %s\n" %e)


# Create an instance of the API class
cm_http = os.environ["CM_HTTP"]
if len(sys.argv) < 2:
    print("requires one argument: CM host name")
    system.exit(-1)
api_host_name = sys.argv[1]
api_host = cm_http + '://' + api_host_name
print("cluster: " + api_host)
port = os.environ["CM_PORT"]
api_version = 'v30'
# Construct base URL for API
# http://cmhost:7180/api/v30
api_url = api_host + ':' + port + '/api/' + api_version
api_client = cm_client.ApiClient(api_url)
cluster_api_instance = cm_client.ClustersResourceApi(api_client)

api_response = cluster_api_instance.read_clusters(view='SUMMARY')


for cluster in api_response.items:
    print(cluster.name, "-", cluster.full_version)
    cluster_name = cluster.name

services_api_instance = cm_client.ServicesResourceApi(api_client)
services = services_api_instance.read_services(cluster.name, view='FULL')
for service in services.items:
    #print(service.display_name, "-", service.type)
    if service.type == 'OZONE':
        ozone = service
    if service.type == 'HDFS':
        hdfs = service
    if service.type == 'YARN':
        yarn = service
    if service.type == 'HIVE':
        hive = service
    if service.type == 'HBASE':
        hbase = service
    if service.type == 'IMPALA':
        impala = service

role_api_instance = cm_client.RolesResourceApi(api_client)

#configs = services_api_instance.read_service_config(cluster.name, ozone.name, view='FULL')
#for config in configs.items:
#    if config.name.find("safety_valve"):
#      print("%s - %s - %s" % (config.name, config.related_name, config.description))

# HDFS
def configure_hdfs():

    rcg_configs = role_api_instance.read_roles(cluster.name, hdfs.name)
    namenode_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.type == 'NAMENODE']

    namenode_java_opts_config = cm_client.ApiConfig(name="namenode_java_opts", value="{{JAVA_GC_ARGS}} -XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=59979")
    body = cm_client.ApiServiceConfig([namenode_java_opts_config])
    for namenode_group in namenode_groups:
        updated_configs = role_api_instance.update_role_config(cluster.name, namenode_group, hdfs.name, body=body)

    datanode_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.type == 'DATANODE']

    datanode_java_opts_config = cm_client.ApiConfig(name="datanode_java_opts", value="{{JAVA_GC_ARGS}} -XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=59979")
    body = cm_client.ApiServiceConfig([datanode_java_opts_config])
    for datanode_group in datanode_groups:
        updated_configs = role_api_instance.update_role_config(cluster.name, datanode_group, hdfs.name, body=body)



    # add java options
    #namenode_java_opts_config = cm_client.ApiConfig(name="namenode_java_opts", value="{{JAVA_GC_ARGS}} -XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=59979")

    #body = cm_client.ApiServiceConfig([namenode_java_opts_config])
    #updated_configs = services_api_instance.update_service_config(cluster.name, hdfs.name, body=body)

    #datanode_java_opts_config = cm_client.ApiConfig(name="datanode_java_opts", value="{{JAVA_GC_ARGS}} -XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=59989")

    #body = cm_client.ApiServiceConfig([datanode_java_opts_config])
    #updated_configs = services_api_instance.update_service_config(cluster.name, hdfs.name, body=body)

    print("HDFS updated")

# OZONE

def configure_ozone():
    # support async profiler
    safey_valve_config = cm_client.ApiConfig(name="ozone-conf/ozone-site.xml_service_safety_valve", value="<property><name>ozone.fs.hsync.enabled</name><value>true</value></property><property><name>hdds.profiler.endpoint.enabled</name><value>true</value></property><property><name>hdds.tracing.enabled</name><value>true</value></property>")

    body = cm_client.ApiServiceConfig([safey_valve_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, ozone.name, body=body)

    # TODO: add -XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints java options to export more accurate async profiler output

    # add java options
    ozone_java_opts_config = cm_client.ApiConfig(name="ozone_java_opts", value="{{java_args}} -XX:NativeMemoryTracking=summary")
    #ozone_java_opts_config = cm_client.ApiConfig(name="ozone_java_opts", value="{{java_args}} -XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=59999")

    body = cm_client.ApiServiceConfig([ozone_java_opts_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, ozone.name, body=body)

    # add environment variable
    #env_config = cm_client.ApiConfig(name="OZONE_service_env_safety_valve", value="ASYNC_PROFILER_HOME=/opt/async-profiler-2.0-linux-x64")
    env_config = cm_client.ApiConfig(name="OZONE_service_env_safety_valve", value="ASYNC_PROFILER_HOME=/opt/async-profiler-1.8.5-linux-x64\nJAEGER_AGENT_HOST=" + api_host_name + " \nJAEGER_SAMPLER_TYPE=const\nJAEGER_SAMPLER_PARAM=1")

    body = cm_client.ApiServiceConfig([env_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, ozone.name, body=body)

    # update service id
    env_config = cm_client.ApiConfig(name="ozone.service.id", value=ozone_service_id)

    body = cm_client.ApiServiceConfig([env_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, ozone.name, body=body)

    body = cm_client.ApiServiceConfig([safey_valve_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, ozone.name, body=body)
    print("Ozone updated")

# YARN

def configure_yarn():
    rcg_configs = role_api_instance.read_roles(cluster.name, yarn.name)
    gateway_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.type == 'GATEWAY']

    map_memory_config = cm_client.ApiConfig(name="mapreduce_map_memory_mb", value="4096")
    body = cm_client.ApiServiceConfig([map_memory_config])
    updated_configs = role_api_instance.update_role_config(cluster.name, gateway_groups[0], yarn.name, body=body)


    # retain localized files for 1 hour after job completion
    nm_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.type == 'NODEMANAGER']

    debug_delay_config = cm_client.ApiConfig(name="yarn_nodemanager_delete_debug_delay_sec", value="3600")
    body = cm_client.ApiServiceConfig([debug_delay_config])
    for nm in nm_groups:
        updated_configs = role_api_instance.update_role_config(cluster.name, nm, yarn.name, body=body)

    print("YARN updated")

def configure_hive():
    if "hive" not in globals():
        return

    # set up hive warehouse directory to o3
    warehouse_directory_config = cm_client.ApiConfig(name="hive_warehouse_directory", value=file_system_prefix + "/managed/hive")
    body = cm_client.ApiServiceConfig([warehouse_directory_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, hive.name, body=body)

    # set up hive external warehouse directory to o3
    external_warehouse_directory_config = cm_client.ApiConfig(name="hive_warehouse_external_directory", value=file_system_prefix + "/external/hive")
    body = cm_client.ApiServiceConfig([external_warehouse_directory_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, hive.name, body=body)

    print("Hive updated")


def configure_hbase():
    # add java options
    
    role_api_instance = cm_client.RolesResourceApi(api_client)
    rcg_configs = role_api_instance.read_roles(cluster.name, hbase.name)
    regionserver_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.type == 'REGIONSERVER']

    hbase_java_opts_config = cm_client.ApiConfig(name="hbase_regionserver_java_opts", value="{{JAVA_GC_ARGS}} -XX:ReservedCodeCacheSize=256m -XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=50100")

    body = cm_client.ApiServiceConfig([hbase_java_opts_config])
    updated_configs = role_api_instance.update_role_config(cluster.name, regionserver_groups[0], hbase.name, body=body)

    # add environment variable
    env_config = cm_client.ApiConfig(name="hbase_service_env_safety_valve", value="ASYNC_PROFILER_HOME=/opt/async-profiler-1.8.5-linux-x64")

    body = cm_client.ApiServiceConfig([env_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, hbase.name, body=body)

    # TODO: add -XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints java options to export more accurate async profiler output

    # enable offheap bucket cache
    env_config = cm_client.ApiConfig(name="hbase_bucketcache_ioengine", value="offheap")

    body = cm_client.ApiServiceConfig([env_config])
    updated_configs = role_api_instance.update_role_config(cluster.name, regionserver_groups[0], hbase.name, body=body)

    # bucket cache size
    env_config = cm_client.ApiConfig(name="hbase_bucketcache_size", value="8192")

    body = cm_client.ApiServiceConfig([env_config])
    updated_configs = role_api_instance.update_role_config(cluster.name, regionserver_groups[0], hbase.name, body=body)

    print("HBase updated")

def configure_impala():
    # add java options

    #api_instance = cm_client.RoleConfigGroupsResourceApi(api_client)
    #rcg_configs = api_instance.read_role_config_groups(cluster.name, impala.name)
    #pprint(rcg_configs)
    #impalad_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.role_type == 'IMPALAD']
    #impalad_java_opts_config = {"impalad_embedded_java_opts": "-XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=50110"}

    #body = cm_client.ApiRoleConfigGroup([impalad_java_opts_config])
    #for impalad_group in impalad_groups:
    #    updated_configs = api_instance.update_role_config_group(cluster.name, impalad_group, impala.name, body=impalad_java_opts_config)


    #return


    
    role_api_instance = cm_client.RolesResourceApi(api_client)
    rcg_configs = role_api_instance.read_roles(cluster.name, impala.name)
    impalad_groups = [rcg_config.name for rcg_config in rcg_configs.items if rcg_config.type == 'IMPALAD']

    impalad_java_opts_config = cm_client.ApiConfig(name="impalad_embedded_java_opts", value="-XX:NativeMemoryTracking=summary -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=50110")

    body = cm_client.ApiServiceConfig([impalad_java_opts_config])
    for impalad_group in impalad_groups:
        updated_configs = role_api_instance.update_role_config(cluster.name, impalad_group, impala.name, body=body)

    # add environment variable
    env_config = cm_client.ApiConfig(name="impala_service_env_safety_valve", value="ASYNC_PROFILER_HOME=/opt/async-profiler-1.8.5-linux-x64")

    body = cm_client.ApiServiceConfig([env_config])
    updated_configs = services_api_instance.update_service_config(cluster.name, impala.name, body=body)
    print("Impala updated")

def refresh():
    cluster_api_instance = cm_client.ClustersResourceApi(api_client)
    restart_command = cluster_api_instance.deploy_client_config(cluster_name)
    print("Deploy client config ...")
    wait(restart_command)
    print("Active: %s. Success: %s" % (restart_command.active, restart_command.success))
    restart_command = cluster_api_instance.refresh(cluster_name)
    print("Refresh ...")
    wait(restart_command)
    print("Active: %s. Success: %s" % (restart_command.active, restart_command.success))
    restart_args = cm_client.ApiRestartClusterArgs()
    print("Restarting the cluster...")
    restart_command = cluster_api_instance.restart_command(cluster_name, body=restart_args)
    wait(restart_command)
    print("Active: %s. Success: %s" % (restart_command.active, restart_command.success))

if 'ozone' in globals():
    configure_ozone()
if 'hdfs' in globals():
    configure_hdfs()
if 'yarn' in globals():
    configure_yarn()
if 'hive' in globals():
    configure_hive()
if 'hbase' in globals():
    configure_hbase()
if 'impala' in globals():
    configure_impala()
refresh()
