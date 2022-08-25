#!/bin/bash

# ssh setup
ssh-keygen -A
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi
/usr/sbin/sshd

rails db:migrate && rails server