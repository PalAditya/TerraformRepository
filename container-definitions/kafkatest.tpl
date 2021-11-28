[
  {
    "name": "kafka",
    "image": "paladitya/paladitya:kafkaconntest",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "environment": [
        {"name":"BOOTSTRAP_ADDRESS","value":"10.0.143.102:9092"}
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
