#!/bin/bash
set -xe

# Start Tomcat, the application server.
# service tomcat start
cd ~/workspace
docker-compose up -d