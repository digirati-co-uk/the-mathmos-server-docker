#!/bin/bash

export JAVA_OPTS="-Dtext.server.coordinate.url=$STARSKY_URL -Xms${MIN_HEAP:-1024}m -Xmx${MAX_HEAP:-2048}m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -Dcluster.nodes=$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT"

cd /usr/local/tomcat/bin

mkdir -p /usr/local/tomcat/logs
touch /usr/local/tomcat/catalina.out

./startup.sh

tail -f --follow=name /usr/local/tomcat/logs/catalina.out
