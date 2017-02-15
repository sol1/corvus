#!/usr/bin/env bash

set -e
scriptname=$(basename $0)
pidfile="/home/corvus/corvus/${scriptname}.pid"
exec 200>$pidfile
flock -n 200 || exit 1
pid=$$
echo $pid 1>&200

source /home/corvus/.rvm/environments/ruby-2.2.2-corvus

cd /home/corvus/corvus/current

bin/rails runner -e production lib/voipmonitor_api_importer.rb >> /home/corvus/corvus/current/log/api-sync.log