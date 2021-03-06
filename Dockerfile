FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ADD https://raw.githubusercontent.com/dceoy/clir/master/install_clir.sh /tmp/install_clir.sh

RUN set -e \
      && ln -sf bash /bin/sh

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https apt-utils ca-certificates curl g++ gcc gfortran \
        git make libblas-dev libcurl4-gnutls-dev libgit2-dev liblapack-dev \
        libmariadb-dev libiodbc2-dev libpq-dev libsqlite3-dev libssh-dev \
        libssl-dev libxml2-dev locales pandoc r-base \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && locale-gen en_US.UTF-8 \
      && update-locale

RUN set -e \
      && bash /tmp/install_clir.sh --root \
      && rm -f /tmp/install_clir.sh

RUN set -e \
      && clir update \
      && clir install --devt=cran dbplyr doParallel foreach ggpubr rmarkdown tidyverse \
      && clir validate dbplyr doParallel foreach ggpubr rmarkdown tidyverse

ENTRYPOINT ["/usr/bin/R"]
