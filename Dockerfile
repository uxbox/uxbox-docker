FROM debian:jessie
MAINTAINER Andrey Antukh <niwi@niwi.nz>

RUN apt-get update && \
    apt-get install -yq locales ca-certificates wget sudo && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN echo "deb http://httpredir.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update -yq && \
    apt-get install -yq bash git tmux vim openjdk-8-jdk rlwrap build-essential

RUN mkdir -p /etc/resolvconf/resolv.conf.d
RUN echo "nameserver 8.8.8.8" > /etc/resolvconf/resolv.conf.d/tail

RUN useradd -m -g users -s /bin/bash uxbox
RUN echo "uxbox:uxbox" | chpasswd

COPY files/bashrc /home/uxbox/.bashrc
COPY files/vimrc /home/uxbox/.vimrc
COPY files/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
COPY files/lein /home/uxbox/.local/bin/lein
# COPY files/start.sh /home/uxbox/

RUN echo "uxbox ALL=(ALL) ALL" >> /etc/sudoers
RUN chmod +x /home/uxbox/.local/bin/lein
RUN chown uxbox /home/uxbox/.bashrc
RUN chown uxbox /home/uxbox/.vimrc

# RUN /etc/init.d/postgresql start \
#     && psql -U postgres -c "create user \"uxbox\" LOGIN SUPERUSER" \
#     && createdb -U uxbox uxbox \
#     && /etc/init.d/postgresql stop

USER uxbox
WORKDIR /home/uxbox

RUN bash -c "/home/uxbox/.local/bin/lein version"

RUN git clone https://github.com/creationix/nvm.git .nvm
RUN bash -c "source .nvm/nvm.sh && nvm install v5.6.0"
RUN bash -c "source .nvm/nvm.sh && nvm alias default v5.6.0"

EXPOSE 3449
