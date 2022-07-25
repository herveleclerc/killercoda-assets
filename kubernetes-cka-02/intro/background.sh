#!/bin/bash
#set -x # to test stderr output in /var/log/killercoda
echo starting... # to test stdout output in /var/log/killercoda
apt-get install -y etcd-client
echo done > /tmp/background0