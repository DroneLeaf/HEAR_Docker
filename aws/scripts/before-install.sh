#!/bin/bash
set -xe

# Delete the old  directory as needed.
if [ -d /usr/local/codedeployresources ]; then
    rm -rf /usr/local/codedeployresources/
fi

mkdir -vp /usr/local/codedeployresources

# Delete the old  HEAR_Docker_Deploy as needed.
if [ -d /home/ubuntu/HEAR_Docker_Deploy ]; then
    rm -rf /home/ubuntu/HEAR_Docker_Deploy/
fi

# Delete the old  HEAR_Docker_Deploy as needed.
if [ -d /home/ubuntu/workspace/HEAR_Docker_Deploy ]; then
    rm -rf /home/ubuntu/workspace/HEAR_Docker_Deploy/
fi

