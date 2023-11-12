# Push your public key to key pair
resource "aws_key_pair" "webapp-key" {
  key_name      = "webapp"
  public_key    = "${file(var.PUBLIC_KEY)}"
}

# Create Launch Tempate for ASG
resource "aws_launch_template" "webapp-lt" {
  name_prefix    = "webapp-lt"
  image_id       = "${var.AMI_ID}"
  instance_type  = "${var.INSTANCE_TYPE}"
  vpc_security_group_ids = ["${aws_security_group.appinstance-sg.id}"]
  key_name       = "webapp"
  tags = {
    Name         = "Webapp-Instance"
    ENV          = "${var.ENVIRONMENT_TAG}"
  }
  user_data      = filebase64("script.sh")
}

# Create placement group
resource "aws_placement_group" "webapp-placement" {
  name          = "webapp-placement"
  strategy      = "spread"
}

# Create ASG
resource "aws_autoscaling_group" "webapp_autoscale_group" {
  name                      = "webapp_autoscale_group"
  max_size                  = "${var.MAX_INSTANCE}"
  min_size                  = "${var.MIN_INSTANCE}"
  health_check_grace_period = 60
  health_check_type         = "ELB"
  vpc_zone_identifier       = aws_subnet.public.*.id
  placement_group           = "${aws_placement_group.webapp-placement.id}"
  target_group_arns         = ["${aws_lb_target_group.webapp-targetgroup.arn}"]

  launch_template {
    id          = "${aws_launch_template.webapp-lt.id}"
    version     = "$Default"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = "Webapp-EC2-Instance"
  }
}

resource "aws_autoscaling_policy" "webapp_autoScaling_policy" {
  name                   = "webapp-autoScaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscale_group.name
  depends_on = [
    aws_autoscaling_group.webapp_autoscale_group,
  ]
}