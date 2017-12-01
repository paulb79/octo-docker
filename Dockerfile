FROM ubuntu:latest

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN \
    apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git software-properties-common unzip \
    default-jdk

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN wget --quiet https://nlp.stanford.edu/software/stanford-ner-2017-06-09.zip && \
    unzip stanford-ner-2017-06-09.zip && \
    mv stanford-ner-2017-06-09 lib/stanford-ner && rm stanford-ner-2017-06-09.zip

RUN wget --quiet http://nlp.stanford.edu/software/stanford-english-corenlp-2017-06-09-models.jar && \
    mv stanford-english-corenlp-2017-06-09-models.jar lib/stanford-en-models

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


