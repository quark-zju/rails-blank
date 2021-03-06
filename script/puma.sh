#!/bin/bash

# goto RAILS_ROOT
cd $(dirname `readlink -f "$0"`)/..

CTRLFILE=tmp/pids/puma-control
PUMAPID=`grep pid: tmp/sockets/puma-control | grep -o '[0-9]*'`
SOCKETFILE='$PWD/tmp/sockets/puma.socket'

if [ -f "$CTRLFILE" ]; then
    # puma still alive
    if [ "$1" == 'stop' ]; then
        echo 'Sending QUIT signal to puma ...'
        pumactl -S $CTRLFILE stop 
        rm $CTRLFILE
    else
        echo 'Sending RESTART signal to puma ...'
        pumactl -S $CTRLFILE restart
    fi
else
    for i in pids sockets; do 
        \mkdir -p ./tmp/$i
    done
    \rm -f $SOCKETFILE

    echo 'Starting puma ...'
    bundle exec puma -t 4:48 -b unix://$SOCKETFILE -S $CTRLFILE --control tcp://127.0.0.1:9277 1>./log/puma.log 2>./log/puma-error.log &
    disown
fi
