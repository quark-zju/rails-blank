#!/bin/bash

# goto RAILS_ROOT
cd $(dirname `readlink -f "$0"`)/..

PIDFILE=./tmp/pids/unicorn.pid

if [ -e $PIDFILE ] && kill -0 `cat $PIDFILE`; then
    # unicorn still alive
    if [ "$1" == 'stop' ]; then
        echo 'Sending QUIT signal to unicorn ...'
        kill -QUIT `cat $PIDFILE`
    else
        echo 'Sending RESTART signal to unicorn ...'
        kill -USR2 `cat $PIDFILE`
    fi
else
    bundle exec unicorn_rails -E $RAILS_ENV -c config/unicorn.rb "$@"
fi
