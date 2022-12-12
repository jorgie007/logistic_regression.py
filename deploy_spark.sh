#!/bin/bash
# Simple script for deploying Spark in standalone mode on DAS-5 for the DDPS course 2022.
# Author: Yuxuan Zhao

set -eu

if [[ $# -lt 1 ]] ; then
	echo ""
	echo "usage: source deploy_spark.sh [nodes]"
	echo "for example: source deploy_spark.sh node105,node106,node107"
	echo ""
	exit 1
fi

echo "Deploying spark on ${1}"
nodes=${1}
IFS=',' read -ra node_list <<< "$nodes"; unset IFS
master=${node_list[0]}
worker=${node_list[@]:1}
echo "master is "$master
echo "worker is "$worker



source export.sh

cd /var/scratch/$USER/spark/conf && cp spark-env.sh.template spark-env.sh && cp workers.template workers
sleep 3
echo "export JAVA_HOME=/var/scratch/$USER/jdk-11.0.2" >> spark-env.sh
echo "export SPARK_MASTER_HOST=$master" >> spark-env.sh
echo "$worker" > workers

ssh $master "cd /var/scratch/$USER/spark && ./bin/spark-submit /home/$USER/logistic_regression.py-main/logistic_regression.py"
