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
