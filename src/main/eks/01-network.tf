data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet" "this" {
  count = length(var.subnets_ids)

  id = var.subnets_ids[count.index]
}
