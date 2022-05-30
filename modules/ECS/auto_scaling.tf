data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_configuration" "ecs_launch" {
  name_prefix   = format("%s - Cluster", var.cluster_name)
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.InstanceType
  key_name      = var.key-name


}


resource "aws_autoscaling_group" "autoS-cluster" {

  name = format("%s-AutoScalingGroup", var.cluster_name)
  vpc_zone_identifier = [
    var.private_subnet_1a,
    var.private_subnet_1c
  ]
  launch_configuration = aws_launch_configuration.ecs_launch.name
  desired_capacity     = lookup(var.auto_scale_options, "desired")
  max_size             = lookup(var.auto_scale_options, "max")
  min_size             = lookup(var.auto_scale_options, "min")

  tag {
    key                 = "Nome"
    value               = format("%s Cluster", var.cluster_name)
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "cpu_up" {
  name            = format("%s-cpu-scale-up", var.cluster_name)
  adjustment_type = "ChangeInCapacity"

  cooldown           = lookup(var.auto_scale_cpu, "scale_up_cooldown")
  scaling_adjustment = lookup(var.auto_scale_cpu, "scale_up_add")

  autoscaling_group_name = aws_autoscaling_group.autoS-cluster.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_up" {

  alarm_name = format("%s-cpu-high", var.cluster_name)

  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"

  evaluation_periods = lookup(var.auto_scale_cpu, "scale_up_evaluation")
  period             = lookup(var.auto_scale_cpu, "scale_up_period")
  threshold          = lookup(var.auto_scale_cpu, "scale_up_threshold")

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.autoS-cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cpu_up.arn}"]

}

resource "aws_autoscaling_policy" "cpu_down" {
  name            = format("%s-cpu-scale-down", var.cluster_name)
  adjustment_type = "ChangeInCapacity"

  cooldown           = lookup(var.auto_scale_cpu, "scale_down_cooldown")
  scaling_adjustment = lookup(var.auto_scale_cpu, "scale_down_remove")

  autoscaling_group_name = aws_autoscaling_group.autoS-cluster.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_down" {

  alarm_name = format("%s-cpu-low", var.cluster_name)

  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"

  evaluation_periods = lookup(var.auto_scale_cpu, "scale_down_evaluation")
  period             = lookup(var.auto_scale_cpu, "scale_down_period")
  threshold          = lookup(var.auto_scale_cpu, "scale_down_threshold")

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.autoS-cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cpu_down.arn}"]

}