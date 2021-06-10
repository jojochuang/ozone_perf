
# to use this script, 
# ref: https://cloudera.github.io/cm_api/docs/python-client-swagger/
# ref: https://archive.cloudera.com/cm7/7.0.3/generic/jar/cm_api/swagger-html-sdk-docs/python/README.html
# $ sudo pip install cm_client
# python reconf_cluster.py

import cm_client
from cm_client.rest import ApiException
from pprint import pprint

# Configure HTTP basic authorization: basic
cm_client.configuration.username = 'admin'
cm_client.configuration.password = 'admin'
api_host = 'http://192.168.116.52'
port = '7180'
api_version = 'v43'

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
            pprint(cmd)
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
# Construct base URL for API
# http://cmhost:7180/api/v30
api_url = api_host + ':' + port + '/api/' + api_version
api_client = cm_client.ApiClient(api_url)
cluster_api_instance = cm_client.ClustersResourceApi(api_client)

api_response = cluster_api_instance.read_clusters(view='SUMMARY')
for cluster in api_response.items:
    #print(cluster.name, "-", cluster.full_version)
    cluster_name = cluster.name


# set up Ozone
services_api_instance = cm_client.ServicesResourceApi(api_client)
services = services_api_instance.read_services(cluster.name, view='FULL')
for service in services.items:
    #print(service.display_name, "-", service.type)
    if service.type == 'IMPALA':
        impala = service

api_instance = cm_client.ImpalaQueriesResourceApi(api_client)

import datetime
filter = ""
#_from = datetime.datetime.now().astimezone().isoformat()
#print("from= " + str(_from))
_from = "2021-06-01T00:00:00"
limit = 1000
offset = 0
to = "now"
api_responses = api_instance.get_impala_queries(cluster_name, impala.name, filter=filter, _from=_from, limit=limit, offset=offset, to=to)
#print(api_responses.queries)

import re
tpcds_query_statement_prefix=".*-- start query (\d+)"
for query in api_responses.queries:
	m = re.match(tpcds_query_statement_prefix, query.statement, re.S)
	#if query.statement.find(tpcds_query_statement_prefix) >= 0:
	#print("statement = " +query.statement + "\n")
	if m != None:
		query_id = m.group(1)
		if query_id == "90":
			print("Database, Query ID, duration, GB read, cpu time (%)")
			query_end_time = query.end_time
		if "hdfs_bytes_read" in query.attributes:
			hdfs_bytes_read = int(query.attributes["hdfs_bytes_read"]) / 1073741824.0
		else:
			hdfs_bytes_read = 0.0
		if "thread_cpu_time_percentage" in query.attributes:
			thread_cpu_time_percentage = query.attributes["thread_cpu_time_percentage"]
		else:
			thread_cpu_time_percentage = "N/A"

		duration_millis = float(query.duration_millis) / 1000.0
			
		print("{database}, {query_id}, {duration_millis:.2f}, {bytes_read:.2f}, {cpu_time}".format(
	database=query.database,
	query_id=query_id,
	duration_millis=duration_millis,
	bytes_read=hdfs_bytes_read,
	cpu_time=thread_cpu_time_percentage))
		if query_id == "1":
			query_start_time = query.start_time
			# print header
			print("The TPC-DS started at " + query_start_time + ", ended at " + query_end_time)
