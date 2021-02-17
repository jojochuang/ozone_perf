#!/bin/bash

ozone sh volume create o3://ozone1/sparksqldata

ozone sh bucket create o3://ozone1/sparksqldata/tpcds100gb
ozone sh bucket create o3://ozone1/sparksqldata/tpcds1000gb
ozone sh bucket create o3://ozone1/sparksqldata/tpcds3000gb
ozone sh bucket create o3://ozone1/sparksqldata/tpcds10000gb
