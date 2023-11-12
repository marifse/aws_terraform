resource "aws_cloudwatch_metric_alarm" "EC2_metric_alarm" {
  alarm_name          = "EC2-metric-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.threshold_percentage}"  #thresold percentage value
  depends_on = [
    aws_autoscaling_group.webapp_autoscale_group,
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_autoscale_group.name
  }
  

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.webapp_autoScaling_policy.arn,aws_sns_topic.webapp_autoscaling_topic.arn]
}