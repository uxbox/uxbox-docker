#!/usr/bin/env bash

REV=`git rev-parse --short HEAD`
IMGNAME="uxbox"

if $(sudo docker ps |grep -q $IMGNAME); then
    sudo docker ps |grep uxbox | awk '{print $1}' | xargs --no-run-if-empty sudo docker kill
fi

if ! $(sudo docker images|grep $IMGNAME |grep -q $REV); then
    sudo docker build --rm=true -t $IMGNAME:$REV .
fi

if [ ! -e ./uxbox ]; then
    git clone git@github.com:uxbox/uxbox.git
fi

if [ ! -e ./uxbox-backend ]; then
    git clone git@github.com:uxbox/uxbox-backend.git
fi

sudo docker run -ti \
     -v `pwd`/uxbox:/home/uxbox/uxbox  \
     -v `pwd`/uxbox-backend:/home/uxbox/uxbox-backend \
     -v $HOME/.m2:/home/uxbox/.m2 \
     -v $HOME/.gitconfig:/home/uxbox/.gitconfig \
     -p 3449:3449 -p 6060:6060 uxbox:$REV
