Introduction
============

Docker container for RabbitMQ 3.4.x with ability to form cluster

Usage
=====

Uses the ability in recent Docker versions to set up hosts entries to locate a node to cluster with. For
convenience sake, the node is named master.

Master
------

`docker run -d --name rmqmaster --add-host master:127.0.0.1 -v <log-dir>:/data/log -v <data-dir>:/data/mnesia -p 5672:5672 -p 15672:15672 akolosov/rabbitmq`
Additional nodes
----------------

`docker run -d --link=rmqmaster:master -v <log-dir>:/data/log -v <data-dir>:/data/mnesia  akolosov/rabbitmq`
