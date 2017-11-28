FROM ubuntu:latest

MAINTAINER Paul Brown

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
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
    apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion software-properties-common

RUN apt-get install default-jdk -y

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

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

# install geturl script to retrieve the most current download URL of CoreNLP
WORKDIR /opt/
RUN git clone https://github.com/foutaise/grepurl.git

# install latest CoreNLP release
RUN wget $(/opt/grepurl/grepurl -d -r 'zip$' -a http://stanfordnlp.github.io/CoreNLP/) && \
    unzip stanford-corenlp-full-*.zip && \
    mv $(ls -d stanford-corenlp-full-*/) lib/corenlp && rm *.zip

ENV PATH /opt/conda/bin:$PATH

COPY ./scripts/python /opt/setup

RUN /opt/setup/install.sh

# Default action: starts a shell
RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean


ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]


