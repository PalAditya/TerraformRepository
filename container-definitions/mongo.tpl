[
  {
    "name": "mongodb",
    "image": "docker.io/mongo:${mongo_version}",
    "cpu": ${mongo_container_cpu},
    "memory": ${mongo_container_memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": 27017,
        "hostPort": 27017
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${volume_name}",
        "containerPath": "/data/db"
      }
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
