#!/bin/bash
set -x

echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
mkdir -p /local
mkdir -p /database
mkdir -p /vol1/zk-data
mkdir -p /vol2/zk-txn-logs
#mkdir -p /vol3/kafka-data
chmod -R 777 /vol1/zk-data
chmod -R 777 /vol2/zk-txn-logs
#chmod -R 777 /vol3/kafka-data

sed -i '/After=cloud-final.service/d' /usr/lib/systemd/system/ecs.service
systemctl daemon-reload

#verify that the agent is running
until curl -s http://localhost:51678/v1/metadata
do
	sleep 1
done

#install the Docker volume plugin
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${region} --grant-all-permissions

systemctl restart docker
systemctl restart ecs
