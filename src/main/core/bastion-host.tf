data "aws_key_pair" "baston_host_key" {
  key_name           = var.bastion_host_key_pair
  include_public_key = false
}

data "aws_subnet" "bastion_host" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset([local.bastion_host_cidrs[0]])
  }
}

# TODO: rename after migration
resource "aws_instance" "bastion_host_v2" {
  ami           = var.bastion_host_ami_id
  instance_type = var.bastion_host_instance_type
  key_name      = data.aws_key_pair.baston_host_key.key_name

  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.bastion_host.id
  vpc_security_group_ids      = [aws_security_group.bastion_host_v2.id]

  tags = {
    Name = format("interop-bastion-host-v2-%s", var.env)
  }
}

# TODO: rename after migration
resource "aws_security_group" "bastion_host_v2" {
  description = format("SG for interop-bastion-host-v2-%s", var.env)
  vpc_id      = module.vpc_v2.vpc_id

  ingress {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.bastion_host_ssh_cidr]
    ipv6_cidr_blocks = []
    security_groups  = []
  }

  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
  }
}
