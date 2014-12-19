#!/bin/bash

if [ -z $RABBIT_HOSTNAME ]; then
	RABBIT_HOSTNAME="master"	
fi

if [ -z $MASTER_HOSTNAME ]; then
	MASTER_NODENAME="rabbit@$RABBIT_HOSTNAME"	
else
	MASTER_NODENAME="rabbit@$MASTER_HOSTNAME"	
fi

ulimit -n 10240

chown -R rabbitmq:rabbitmq /data

if [ -z $MASTER_HOSTNAME ]; then
	echo "Running RabbitMQ server as standalone node using nodename ${MASTER_NODENAME}.";
	export RABBITMQ_NODENAME="${MASTER_NODENAME}"
	rabbitmq-server
else
	echo "Joining cluster to ${MASTER_NODENAME}"
	rabbitmq-server -detached
	rabbitmqctl stop_app
	rabbitmqctl reset

	if [ -z "$RAM_NODE" ]; then
		rabbitmqctl join_cluster "${MASTER_NODENAME}"
	else
		rabbitmqctl join_cluster --ram "${MASTER_NODENAME}"
	fi

	rabbitmqctl start_app

	# Tail to keep the a foreground process active..
	tail -f /data/log/rabbit\@$HOSTNAME.log
fi
