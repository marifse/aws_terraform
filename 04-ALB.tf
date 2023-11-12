# Create ELB - Application loadbalancer
resource "aws_lb" "webapp-alb" {
  name               = "webapp-alb"
  subnets            = "${aws_subnet.public.*.id}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]

  tags = {
    Name        = "WebApp-FrontEnd"
    ENV         = "${var.ENVIRONMENT_TAG}"
  }
}

# Create Loadbalancer target group
resource "aws_lb_target_group" "webapp-targetgroup" {
  name          = "webapp-targetgroup"
  port          = "80"
  protocol      = "HTTP"
  vpc_id        = "${aws_vpc.vpc.id}"
  target_type   = "instance"
  tags = {
    name        = "webapp"
    ENV         = "${var.ENVIRONMENT_TAG}"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "80"
  }
}

# Create Application LB listener
resource "aws_lb_listener" "webapp-listener" {
  load_balancer_arn = "${aws_lb.webapp-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn    = "${aws_lb_target_group.webapp-targetgroup.arn}"
    type                = "forward"
  }
}