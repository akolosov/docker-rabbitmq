Introduction
============

Docker container for RabbitMQ 3.4.x with ability to form cluster


Usage
=====

Uses the ability in recent Docker versions to set up hosts entries to locate a node to cluster with. For
convenience sake, the node is named master.


Master
------

`docker run -d -h rmq-master --name rmq --add-host master:<IP-FOR-NODES> \
				-v <log-dir>:/data/log -v <data-dir>:/data/mnesia \
				-p 5672:5672 -p 15672:15672 -p 25672:25672 -p 4369:4369 akolosov/rabbitmq`


Additional nodes
----------------

`docker run -d -h rmq-slaveXX --name rmq -e "MASTER_HOSTNAME=master" --add-host master:<MASTER-NODE-IP> \
				-v <log-dir>:/data/log -v <data-dir>:/data/mnesia \
				-p 5672:5672 -p 15672:15672 -p 25672:25672 -p 4369:4369 akolosov/rabbitmq`
