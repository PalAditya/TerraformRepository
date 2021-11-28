[
  {
    "name": "mongotest",
    "image": "paladitya/paladitya:mongoconntest",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "environment": [
        {"name":"MONGO_IP","value":"10.0.143.102"}
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
