resource "aws_sns_topic" "webapp_autoscaling_topic" {
  display_name = "WebApp-Topic"
  name         = "WebApp-Topic"
}

resource "aws_sns_topic_subscription" "webapp_autoscaling_email_subscription" {
  endpoint  = "${var.SNS_EMAIL}"
  protocol  = "email"
  topic_arn = "${aws_sns_topic.webapp_autoscaling_topic.arn}"
}

resource "aws_autoscaling_notification" "webapp_autoscaling_notification" {
  group_names   = ["${aws_autoscaling_group.webapp_autoscale_group.name}"]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
  topic_arn     = "${aws_sns_topic.webapp_autoscaling_topic.arn}"
}