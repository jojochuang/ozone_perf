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

# Configure HTTP basic authorization: basic
cm_client.configuration.username = 'admin'
cm_client.configuration.password = 'admin'

# Create an instance of the API class
if len(sys.argv) < 2:
    print("requires one argument: CM host name")
    system.exit(-1)
api_host_name = sys.argv[1]
api_host = 'http://' + api_host_name
port = '7180'
api_version = 'v30'
# Construct base URL for API
# http://cmhost:7180/api/v30
api_url = api_host + ':' + port + '/api/' + api_version
api_client = cm_client.ApiClient(api_url)
api_instance = cm_client.ClouderaManagerResourceApi(api_client)
deployment = api_instance.get_deployment2(view='export')
for host in deployment.hosts:
    print(host.hostname)
