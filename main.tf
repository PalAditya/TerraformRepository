/*--------- Common -----------*/

resource "aws_ecs_cluster" "mongo_ecs" {
  name = var.name

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "aditya"
  retention_in_days = 1
}

/* -------------- Zookeeper -----------*/

resource "aws_ecs_task_definition" "zk-task" {
  container_definitions    = data.template_file.container_definition_zk.rendered
  family                   = var.name
  network_mode             = "host"
  requires_compatibilities = ["EC2"]

  volume {
    name = "zk"
    host_path = "/vol1/zk-data"
  }

  volume {
    name = "zklog"
    host_path = "/vol2/zk-txn-logs"
  }
  tags = var.tags
}

resource "aws_ecs_service" "zk-ecs-service" {
  name                               = "zk"
  cluster                            = aws_ecs_cluster.mongo_ecs.arn
  task_definition                    = aws_ecs_task_definition.zk-task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  launch_type                        = "EC2"
}

data "template_file" "container_definition_zk" {
  template = file("${path.module}/container-definitions/zookeeper.tpl")
}

/* -------------- Mongo -----------*/

resource "aws_ecs_task_definition" "mongo-task" {
  container_definitions    = data.template_file.container_definition.rendered
  family                   = var.name
  network_mode             = "host"
  requires_compatibilities = ["EC2"]

  volume {
    name = var.name
    host_path = "/local"

  }
  tags = var.tags
}

resource "aws_ecs_service" "mongo-ecs-service" {
  name                               = var.name
  cluster                            = aws_ecs_cluster.mongo_ecs.arn
  task_definition                    = aws_ecs_task_definition.mongo-task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  launch_type                        = "EC2"
}

data "template_file" "container_definition" {
  template = file("${path.module}/container-definitions/mongo.tpl")

  vars = {
    mongo_version          = var.mongo_version
    mongo_container_cpu    = var.mongo_container_cpu
    mongo_container_memory = var.mongo_container_memory
    volume_name            = var.name
  }
}

/* -------------- DB2 -----------*/

resource "aws_ecs_task_definition" "db2-task" {
  container_definitions    = data.template_file.container_definition_db2.rendered
  family                   = var.name
  network_mode             = "host"
  requires_compatibilities = ["EC2"]

  volume {
    name = "aditya"
    host_path = "/database"

  }
  tags = var.tags
}

resource "aws_ecs_service" "db2-ecs-service" {
  name                               = "db2"
  cluster                            = aws_ecs_cluster.mongo_ecs.arn
  task_definition                    = aws_ecs_task_definition.db2-task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  launch_type                        = "EC2"
}

data "template_file" "container_definition_db2" {
  template = file("${path.module}/container-definitions/db2.tpl")

   vars = {
    volume_name            = "aditya"
  }
}

/*---------- Kafka - Phase 2. Ensure this is commented out, and update tpl with zk ip before uncommenting -----*/

resource "aws_ecs_task_definition" "kafka-task" {
  container_definitions    = data.template_file.container_definition_kafka.rendered
  family                   = var.name
  network_mode             = "host"
  requires_compatibilities = ["EC2"]

  volume {
    name = "kafka"
    host_path = "/vol3/kafka-data"
  }
  tags = var.tags
}

resource "aws_ecs_service" "kafka-ecs-service" {
  name                               = "kafka"
  cluster                            = aws_ecs_cluster.mongo_ecs.arn
  task_definition                    = aws_ecs_task_definition.kafka-task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  launch_type                        = "EC2"
}

data "template_file" "container_definition_kafka" {
  template = file("${path.module}/container-definitions/kafka.tpl")
}

/*------------------ Apps - Phase 3-------------------*/

/* ----- Mongo. Update TPL with EC2 IP of Mongo (Private) -------*/

resource "aws_ecs_task_definition" "mongo-test-task" {
  container_definitions    = data.template_file.container_definition_mongotest.rendered
  family                   = "test"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::000386122504:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  tags = var.tags
}

resource "aws_ecs_service" "mongotest" {
  name            = "mongodbtest"
  cluster         = aws_ecs_cluster.mongo_ecs.arn
  task_definition = aws_ecs_task_definition.mongo-test-task.arn
  desired_count   = 1
  network_configuration {
    subnets = [var.subnet_id]
  }
  deployment_minimum_healthy_percent = 0
  force_new_deployment = true
}

data "template_file" "container_definition_mongotest" {
  template = file("${path.module}/container-definitions/mongotest.tpl")
}

/* ----- DB2. Update TPL with EC2 IP of DB2 (Private) -------*/

resource "aws_ecs_task_definition" "db2-test-task" {
  container_definitions    = data.template_file.container_definition_db2test.rendered
  family                   = "test"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::000386122504:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  tags = var.tags
}

resource "aws_ecs_service" "db2test" {
  name            = "db2test"
  cluster         = aws_ecs_cluster.mongo_ecs.arn
  task_definition = aws_ecs_task_definition.db2-test-task.arn
  desired_count   = 1
  network_configuration {
    subnets = [var.subnet_id]
  }
  deployment_minimum_healthy_percent = 0
  force_new_deployment = true
}

data "template_file" "container_definition_db2test" {
  template = file("${path.module}/container-definitions/db2test.tpl")
}

/* ----- Kafka. Update TPL with EC2 IP of Kafka (Private) -------*/

resource "aws_ecs_task_definition" "kafka-test-task" {
  container_definitions    = data.template_file.container_definition_kafkatest.rendered
  family                   = "test"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::000386122504:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  tags = var.tags
}

resource "aws_ecs_service" "kafkatest" {
  name            = "kafkatest"
  cluster         = aws_ecs_cluster.mongo_ecs.arn
  task_definition = aws_ecs_task_definition.kafka-test-task.arn
  desired_count   = 1
  network_configuration {
    subnets = [var.subnet_id]
  }
  deployment_minimum_healthy_percent = 0
  force_new_deployment = true
}

data "template_file" "container_definition_kafkatest" {
  template = file("${path.module}/container-definitions/kafkatest.tpl")
}