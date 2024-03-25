resource "aws_security_group" "interop_be_services" {
  count = var.env == "dev" ? 1 : 0

  vpc_id      = module.vpc_v2.vpc_id
  name        = format("interop-alb-be-services-%s", var.env)
  description = "interop-be-services ALB SG"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  namespace          = var.env
  namespace_refactor = format("%s-refactor", var.env)
}

resource "aws_lb" "interop_be_services" {
  count = var.env == "dev" ? 1 : 0

  name               = format("interop-be-services-%s", var.env)
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.interop_be_services[0].id]
  subnets            = data.aws_subnets.int_lbs.ids
  ip_address_type    = "ipv4"

  preserve_host_header = true

  access_logs {
    bucket  = module.alb_logs_bucket.s3_bucket_id
    enabled = true
  }
}

resource "aws_lb_listener" "interop_be_services_80" {
  count = var.env == "dev" ? 1 : 0

  load_balancer_arn = aws_lb.interop_be_services[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "auth_server" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-auth-server", local.namespace)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/authorization-server/status"
    port                = 8088
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "auth_server_refactor" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-auth-server", local.namespace_refactor)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/authorization-server/status"
    port                = 8088
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "bff" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-bff", local.namespace)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/backend-for-frontend/0.0/status"
    port                = 8088
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "bff_refactor" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-bff", local.namespace_refactor)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/backend-for-frontend/0.0/status"
    port                = 8088
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "apigw" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-apigw", local.namespace)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/api-gateway/0.0/status"
    port                = 8088
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "apigw_refactor" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-apigw", local.namespace_refactor)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/api-gateway/0.0/status"
    port                = 8088
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "frontend" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-frontend", local.namespace)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/ui"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 301
  }
}

resource "aws_lb_target_group" "frontend_refactor" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-frontend", local.namespace_refactor)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/ui"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 301
  }
}

resource "aws_lb_target_group" "probing_mock" {
  count = var.env == "dev" ? 1 : 0

  name            = format("%s-probing-mock", local.namespace)
  port            = 1
  protocol        = "HTTP"
  target_type     = "ip"
  ip_address_type = "ipv4"
  vpc_id          = module.vpc_v2.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }
}

resource "aws_lb_listener_rule" "auth_server_refactor" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_server_refactor[0].arn
  }

  condition {
    path_pattern {
      values = ["/authorization-server", "/authorization-server/*"]
    }
  }

  condition {
    host_header {
      values = ["*.refactor.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "bff_refactor" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bff_refactor[0].arn
  }

  condition {
    path_pattern {
      values = ["/backend-for-frontend", "/backend-for-frontend/*"]
    }
  }

  condition {
    host_header {
      values = ["*.refactor.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "apigw_refactor" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apigw_refactor[0].arn
  }

  condition {
    path_pattern {
      values = ["/api-gateway", "/api-gateway/*"]
    }
  }

  condition {
    host_header {
      values = ["*.refactor.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "frontend_refactor" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_refactor[0].arn
  }

  condition {
    path_pattern {
      values = ["/ui", "/ui/*"]
    }
  }

  condition {
    host_header {
      values = ["*.refactor.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "probing_mock" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.probing_mock[0].arn
  }

  condition {
    path_pattern {
      values = ["/probing-mock", "/probing-mock/*"]
    }
  }
}

resource "aws_lb_listener_rule" "auth_server" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_server[0].arn
  }

  condition {
    path_pattern {
      values = ["/authorization-server", "/authorization-server/*"]
    }
  }

  condition {
    host_header {
      values = ["*.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "bff" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 7

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bff[0].arn
  }

  condition {
    path_pattern {
      values = ["/backend-for-frontend", "/backend-for-frontend/*"]
    }
  }

  condition {
    host_header {
      values = ["*.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "apigw" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 8

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apigw[0].arn
  }

  condition {
    path_pattern {
      values = ["/api-gateway", "/api-gateway/*"]
    }
  }

  condition {
    host_header {
      values = ["*.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_lb_listener_rule" "frontend" {
  count = var.env == "dev" ? 1 : 0

  listener_arn = aws_lb_listener.interop_be_services_80[0].arn
  priority     = 9

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend[0].arn
  }

  condition {
    path_pattern {
      values = ["/ui", "/ui/*"]
    }
  }

  condition {
    host_header {
      values = ["*.dev.interop.pagopa.it"]
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_alb" {
  count = var.env == "dev" ? 1 : 0

  security_group_id = module.eks_v2.cluster_primary_security_group_id

  from_port                    = 80
  to_port                      = 8088
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.interop_be_services[0].id
}