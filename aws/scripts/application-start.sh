#!/bin/bash
set -xe

# Start Tomcat, the application server.
# service tomcat start
cp -r /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/${DEPLOYMENT_ID}/deployment-archive /home/ubuntu/HEAR_Docker_Deploy
cd /home/ubuntu/workspace
docker-compose up -d