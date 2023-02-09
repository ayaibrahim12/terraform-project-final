resource "aws_alb" "load-balancer" {
  name               = var.load-balancer-name
  internal           = var.load-balancer-internal-choise
  load_balancer_type = var.load-balancer-type
  security_groups    = [var.load-balancer-SG]
  subnets            = var.load-balancer-subnets-ids
}

resource "aws_alb_listener" "load-balancer-listener" {
  load_balancer_arn = aws_alb.load-balancer.arn
  port             = "80"
  protocol         = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.load-balancer-target-group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "load-balancer-target-group" {
  name       = var.target_group_name
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.vpc-id
  target_type = var.target_group_type
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_target_group_attachment" "attach_target_group" {
  target_group_arn = aws_alb_target_group.load-balancer-target-group.arn
  for_each = var.instance_ids
  target_id = each.value
  port = 80
}