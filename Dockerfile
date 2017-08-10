FROM ubuntu:14.04

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Install essential packages
RUN apt-get update && apt-get install -y \
	build-essential \
	curl \
	maven \
	openssh-server \
	software-properties-common \
	vim \
	wget \
	htop tree zsh fish \
	python-pip groff-base

# Install AWS CLI
RUN pip install awscli

# Install Java 8
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN add-apt-repository -y ppa:webupd8team/java \
	&& apt-get update -y \
	&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& apt-get install -y oracle-java8-installer \
	&& update-java-alternatives -s java-8-oracle \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/oracle-jdk8-installer

# Install Tomcat 8.5.11
RUN cd /tmp && wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz
RUN tar xzvf /tmp/apache-tomcat-8*.tar.gz -C /usr/local/tomcat --strip-components=1

# Download The Mathmos Server 1.0.21
RUN wget -O /opt/the-mathmos-server.tar.gz https://github.com/dlcs/the-mathmos-server/archive/1.0.21.tar.gz \
	&& mkdir /opt/the-mathmos-server \
	&& tar -xzvf /opt/the-mathmos-server.tar.gz --strip-components=1 -C /opt/the-mathmos-server

# Overrides maven settings file with Digirati's artifact 
COPY etc/settings.xml /root/.m2/settings.xml

# Compile parent
RUN cd /opt/the-mathmos-server/the-mathmos-parent/ && mvn clean package install -U

# Compile server
RUN cd /opt/the-mathmos-server/the-mathmos-server && mvn clean package install -U \
	&& cp /opt/the-mathmos-server/the-mathmos-server/target/search.war /usr/local/tomcat/webapps

COPY run_mathmos.sh /opt/the-mathmos-server

EXPOSE 8080
