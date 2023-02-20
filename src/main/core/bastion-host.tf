data "aws_key_pair" "baston_host_key" {
  key_name           = var.bastion_host_key_pair
  include_public_key = false
}

resource "aws_network_interface" "bastion_host" {
  subnet_id   = module.vpc.public_subnets[0]
  private_ips = [var.bastion_host_private_ip]
  ipv6_address_list_enabled = false
  private_ip_list_enabled   = true
}


resource "aws_instance" "bastion_host" {
  ami = var.bastion_host_ami_id
  instance_type = var.bastion_host_instance_type
  key_name = data.aws_key_pair.baston_host_key.key_name 
  tags = {
    Name = format("interop-bastion-host-%s-BastionInstance",var.env)
  }
}

resource "aws_network_interface_attachment" "bastion_host" {
  instance_id          = aws_instance.bastion_host.id
  network_interface_id = aws_network_interface.bastion_host.id
  device_index         = 0
} 

resource "aws_security_group" "allow_ssh" {
  name        = var.bastion_host_security_group_name
  description = format("Security group for interop-bastion-host-%s bastion host",var.env)
  vpc_id = module.vpc.vpc_id

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
