#Load Balancer URL for App
output "webapp_alb-load-balancer-name" {
  value = "${aws_lb.webapp-alb}"
}

#Target Group ARN for App
output "webapp-target-group-arn" {
  value = "${aws_lb_target_group.webapp-targetgroup.arn}"
}