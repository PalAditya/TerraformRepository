data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-ebs"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNMjHmAM0wJEPX3QEIBkGq7EZC6IJUKSESBmyHugPw5XScWBBWyjP+BNUugyE9W1EYq+IxTZIxzeawjSwcILrfDeNggpeMlNYRc4ovCQQZ8fEnAdmgJoD5KD2EBLSV8iCpUr7mB+zgtlW7Ryo6REFJE214iYcP75N5H9mXq+yn84BWicHHEzXHcXZ5HvwRbOg5Br/NKXK3hCL0TwbTMwRUup3fqYa0pdCGBFuuuuuNUp4I6GVgmVdBduTo1QAgrPn2mqBbJg4oazrrNuJdANJ7G6Q8sCtYVsVmaskYw4ApzLjrWFiHYtBbqXf6ddWl32c+/ZkvfA9AY1Z6o1MgzsxN LENOVO@LAPTOP-CEJPJL1G"
}

resource "aws_instance" "mongo-ecs-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.default.id
  user_data              = data.template_file.user-data.rendered
  key_name               = "ssh-key"

  tags = var.tags
}

#resource "aws_instance" "kafka-ecs-instance" {
#  ami                    = data.aws_ami.amazon-linux-2.id
#  instance_type          = var.instance_type
#  vpc_security_group_ids = [var.security_group_id]
#  subnet_id              = var.subnet_id
#  iam_instance_profile   = aws_iam_instance_profile.default.id
#  user_data              = data.template_file.user-data.rendered
#  key_name               = "ssh-key"
#
#  tags = var.tags
#}

data "template_file" "user-data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = var.name
    region       = var.region
  }
}
