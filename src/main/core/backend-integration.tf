# TODO: manage ALB with TF after migration
data "aws_lb" "backend_alb_v2" {
  name = var.backend_integration_v2_alb_name
}

# TODO: rename after migration
module "nlb_v2" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.7.0"

  name = format("be-integration-nlb2-%s", var.env)

  load_balancer_type = "network"
  internal           = true
  vpc_id             = module.vpc_v2.vpc_id
  subnets            = data.aws_subnets.int_lbs.ids

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = format("be-integration2-alb-tg-%s", var.env)
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "alb"
      targets = {
        backend_alb = {
          target_id = data.aws_lb.backend_alb_v2.arn
          port      = 80
        }
      }
      connection_termination = false
      preserve_client_ip     = true
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        matcher             = "200-499"
      }
    }
  ]
}

resource "aws_api_gateway_vpc_link" "integration" {
  name        = format("interop-backend-integration2-%s", var.env)
  description = "VPC Link to connect privately API GW Rest to NLB"
  target_arns = [module.nlb_v2.lb_arn]
}
