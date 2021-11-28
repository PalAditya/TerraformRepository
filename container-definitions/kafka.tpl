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
          "sourceVolume": "${volume_name}",
          "containerPath": "/kafka"
        }
      ],
      "environment": [
          {"name":"KAFKA_BROKER_ID","value":"1"},
          {"name":"KAFKA_ZOOKEEPER_CONNECT","value":"localhost:2181"},
          {"name":"KAFKA_ADVERTISED_LISTENERS","value":"PLAINTEXT://kafka:9092,PLAINTEXT_HOST://localhost:29092"},
          {"name":"KAFKA_LISTENER_SECURITY_PROTOCOL_MAP","value":"PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT"},
          {"name":"KAFKA_INTER_BROKER_LISTENER_NAME","value":"PLAINTEXT"},
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
