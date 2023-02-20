aws_region = "eu-central-1"
env        = "test"
short_name = "interop"

bastion_host_ami_id = "ami-05f5f4f906feab6a7"
bastion_host_instance_type = "t2.micro"
bastion_host_private_ip = "172.32.0.102"
bastion_host_security_group_name = "interop-bastion-host-test-BastionSecurityGroup-1KAJGE4ZLTG1X"
bastion_host_ssh_cidr = "0.0.0.0/0"
bastion_host_key_pair = "interop-bh-key"

tags = {
  CreatedBy   = "Terraform"
  Environment = "test"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}
