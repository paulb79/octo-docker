FROM ubuntu:latest

MAINTAINER Paul Brown

ENV JAVA_VERSION 1.8.0_131
ENV JAVA_HOME /usr/lib/jvm/jdk

# Environment variables
ENV SBT_VERSION   0.13.15
ENV SBT_HOME    /usr/local/sbt
ENV SCALA_VERSION 2.12.2
ENV SCALA_HOME    /usr/local/scala
ENV PATH    $SCALA_HOME/bin:$SBT_HOME/bin:$PATH

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN \
    apt-get update && \
    apt-get install software-properties-common -y

RUN apt-get install default-jdk -y

RUN apt-get install wget -y 

# Installing Scala from source
RUN \
    wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.tgz && \
    tar -xzf /scala-$SCALA_VERSION.tgz -C /usr/local/ && \
    ln -s /usr/local/scala-$SCALA_VERSION $SCALA_HOME && \
    rm scala-$SCALA_VERSION.tgz 

# Installing SBT from source
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
    tar -xzf sbt-$SBT_VERSION.tgz -C /usr/local/ && \
    rm sbt-$SBT_VERSION.tgz && \
    echo "Show SBT version" && \
    sbt about

# Default action: starts a Scala shell
CMD ["scala"]
