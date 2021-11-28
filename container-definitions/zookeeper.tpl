[
  {
    "name": "zookeeper",
    "image": "confluentinc/cp-zookeeper",
    "cpu": 512,
    "memory": 1024,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 2181,
        "hostPort": 2181
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "zk",
        "containerPath": "/var/lib/zookeeper/data"
      },
      {
        "sourceVolume": "zklog",
        "containerPath": "/var/lib/zookeeper/log"
      }
    ],
    "environment": [
        {"name":"ZOOKEEPER_CLIENT_PORT","value":"2181"},
        {"name":"ZOOKEEPER_TICK_TIME","value":"2000"}
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "aditya",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "streaming"
      }
    }
  }
]
