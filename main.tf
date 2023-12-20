data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

}


resource "aws_instance" "docker_instance" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  key_name               = var.key_name
  instance_type          = var.instance_type
  count                  = var.num_of_instance
  user_data              = templatefile("${abspath(path.module)}/userdata.sh",{myserver = var.server-name})
  vpc_security_group_ids = [aws_security_group.docker_instance_sec_grp.id]
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group" "docker_instance_sec_grp" {

  name = "${var.tag}-terraform-sec-grp"
  tags = {
    Name = "${var.tag}-terraform-sec-grp"
  }

  dynamic "ingress" {
    for_each = var.docker-instance-ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
