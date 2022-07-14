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

# Create an instance of the API class
cm_http = os.environ["CM_HTTP"]
if len(sys.argv) < 2:
    print("requires two arguments: [CM host name] [roletype]")
    system.exit(-1)
api_host_name = sys.argv[1]
role_type = sys.argv[2]
api_host = cm_http + '://' + api_host_name
port = os.environ["CM_PORT"]
api_version = 'v30'
# Construct base URL for API
# http://cmhost:7180/api/v30
api_url = api_host + ':' + port + '/api/' + api_version
api_client = cm_client.ApiClient(api_url)
api_instance = cm_client.ClouderaManagerResourceApi(api_client)
deployment = api_instance.get_deployment2(view='export')
hosts_map = {}
for host in deployment.hosts:
    hosts_map.update({host.host_id: host.hostname}) 
if role_type == "all":
    for host in deployment.hosts:
            print(host.hostname)
else:
    for cluster in deployment.clusters:
        for service in cluster.services:
            for role in service.roles:
                if role.type == role_type:
                    print(hosts_map[role.host_ref.host_id])
