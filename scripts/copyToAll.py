#!/usr/bin/env python

import sys
import os
import socket

hostFile = os.environ['HOME'] + '/mpd.hosts'


# input parameter handling
if len(sys.argv) != 2:
    copyPath = '~/RGC'
else:
    copyPath = sys.argv[1]

# copy file to all workers via ssh
i = 0
hf = open(hostFile, 'r')
for line in hf:
    host = line.strip()
    i += 1
    if i == 1:
        # skip ourselve
        continue
    os.system('ssh -o "StrictHostKeyChecking no" %s rm -rf %s' % (host, copyPath))
    os.system('scp -o "StrictHostKeyChecking no" -r %s %s:~/' % (copyPath, host))

