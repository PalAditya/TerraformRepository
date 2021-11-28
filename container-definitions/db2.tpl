[
  {
    "name": "db2",
    "image": "ibmcom/db2",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 50000,
        "hostPort": 50000
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "aditya",
        "containerPath": "/database"
      }
    ],
    "environment": [
        {"name":"DB2INST1_PASSWORD","value":"aditya"},
        {"name":"LICENSE","value":"accept"},
        {"name":"DBNAME","value":"aditya"}
    ],
    "privileged": true,
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
