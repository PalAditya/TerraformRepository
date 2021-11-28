[
  {
    "name": "db2test",
    "image": "paladitya/paladitya:DB2Conntest",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "environment": [
        {"name":"DB2_IP","value":"10.0.227.227"}
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
