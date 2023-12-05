#!/bin/bash
set -xe

# Start Tomcat, the application server.
# service tomcat start
cd /home/ubuntu/workspace
docker-compose up -d