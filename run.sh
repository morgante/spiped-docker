#!/bin/bash
/usr/sbin/sshd
ssh -oStrictHostKeyChecking=no -f -N -D 0.0.0.0:1080 localhost
/spiped/spiped/spiped -d -s '[0.0.0.0]:8089' -t '[127.0.0.1]:1080' -k  /spiped/spiped.key

touch /var/log

tail -f /var/log