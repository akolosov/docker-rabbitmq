#!/bin/bash

if [ -z $MASTER_HOSTNAME ]; then
	MASTER_NODENAME="rabbit@master"	
else
	MASTER_NODENAME="rabbit@$MASTER_HOSTNAME"	
fi

ulimit -n 1024
chown -R rabbitmq:rabbitmq /data

if [ -z $MASTER_HOSTNAME ]; then
	echo "Running RabbitMQ server as standalone node using nodename ${MASTER_NODENAME}.";
	export RABBITMQ_NODENAME="${MASTER_NODENAME}"
	rabbitmq-server
	/bin/sh
else
	echo "Joining cluster to ${MASTER_NODENAME}"
	rabbitmq-server -detached
	rabbitmqctl stop_app
	rabbitmqctl reset
	rabbitmqctl join_cluster "${MASTER_NODENAME}"
	rabbitmqctl start_app
	/bin/sh
fi
