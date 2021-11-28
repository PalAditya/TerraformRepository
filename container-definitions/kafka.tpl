[
  {
      "name": "kafka",
      "image": "confluentinc/cp-kafka",
      "cpu": 512,
      "memory": 1024,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 29092,
          "hostPort": 29092
        },
        {
            "containerPort": 9092,
            "hostPort": 9092
        }
      ],
      "mountPoints": [
        {
          "sourceVolume": "kafka",
          "containerPath": "/kafka"
        }
      ],
      "environment": [
          {"name":"KAFKA_BROKER_ID","value":"1"},
          {"name":"KAFKA_ZOOKEEPER_CONNECT","value":"10.0.240.167:2181"},
          {"name":"KAFKA_ADVERTISED_LISTENERS","value":"PLAINTEXT://10.0.240.167:9092"},
          {"name":"KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR","value":"1"}
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
