FROM akolosov/ubuntu

MAINTAINER Alexey Kolosov <alexey.kolosov@gmail.com>

RUN wget -qO - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes rabbitmq-server
RUN rm -rf /var/lib/apt/lists/*

RUN rabbitmq-plugins enable rabbitmq_management
RUN rabbitmq-plugins enable rabbitmq_federation
RUN rabbitmq-plugins enable rabbitmq_federation_management
RUN rabbitmq-plugins enable rabbitmq_shovel
RUN rabbitmq-plugins enable rabbitmq_shovel_management

ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

RUN mkdir -p /data/mnesia
RUN mkdir -p /data/logs

ADD rabbitmq-startup.sh /usr/local/sbin/rabbitmq-startup.sh
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config
ADD erlang-cookie /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 700 /usr/local/sbin/rabbitmq-startup.sh /var/lib/rabbitmq/.erlang.cookie

ENTRYPOINT ["/bin/bash", "/usr/local/sbin/rabbitmq-startup.sh"]

EXPOSE 5672 15672 25672 4369

