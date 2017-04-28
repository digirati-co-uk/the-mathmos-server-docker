#!/bin/bash

export JAVA_OPTS="-Dtext.server.coordinate.url=http://starsky.dlcs-ida.org/coords/ -Dcluster.nodes=elasticsearch:9300"

cd /usr/local/tomcat/bin

./startup.sh

tail -f --follow=name /usr/local/tomcat/logs/catalina.out
