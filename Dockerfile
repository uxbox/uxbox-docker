FROM debian:jessie
MAINTAINER Andrey Antukh <niwi@niwi.nz>

RUN apt-get update && \
    apt-get install -yq locales ca-certificates wget sudo && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN echo "deb http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update -yq && \
    apt-get install -yq bash git tmux vim openjdk-8-jdk rlwrap build-essential \
                        postgresql-9.5 postgresql-contrib-9.5

RUN mkdir -p /etc/resolvconf/resolv.conf.d
RUN echo "nameserver 8.8.8.8" > /etc/resolvconf/resolv.conf.d/tail

RUN useradd -m -g users -s /bin/bash uxbox
RUN echo "uxbox:uxbox" | chpasswd

RUN echo "uxbox ALL=(ALL) ALL" >> /etc/sudoers
COPY files/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf
COPY files/postgresql.conf /etc/postgresql/9.5/main/postgresql.conf

RUN /etc/init.d/postgresql start \
    && psql -U postgres -c "create user \"uxbox\" LOGIN SUPERUSER" \
    && createdb -U uxbox uxbox \
    && createdb -U uxbox test \
    && /etc/init.d/postgresql stop

USER uxbox
WORKDIR /home/uxbox

RUN git clone https://github.com/creationix/nvm.git .nvm
RUN bash -c "source .nvm/nvm.sh && nvm install v5.10.1"
RUN bash -c "source .nvm/nvm.sh && nvm alias default v5.10.1"

COPY files/lein /home/uxbox/.local/bin/lein
RUN bash -c "/home/uxbox/.local/bin/lein version"

COPY files/bashrc /home/uxbox/.bashrc
COPY files/vimrc /home/uxbox/.vimrc

USER root
WORKDIR /root
EXPOSE 3449
EXPOSE 6060
EXPOSE 9090

COPY files/bashrc /root/.bashrc
COPY files/vimrc /root/.vimrc
COPY files/start.sh /root/start.sh

CMD /root/start.sh
