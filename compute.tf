# 1. Fetch the latest Amazon Linux 2023 Image
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 2. EC2 Launch Template (Blueprint)
resource "aws_launch_template" "web" {
  name_prefix   = "web-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  # Attach the private EC2 security group created in sg.tf
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # The user-data script installs Nginx and creates a simple webpage
  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello World from an AI Engineer in Berlin!</h1>" > /usr/share/nginx/html/index.html
              EOF
  )
}

# 3. Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name = "web-asg"
  # Deploys instances strictly into the private subnets
  vpc_zone_identifier = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}

# 4. CPU-based Auto Scaling Policy
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}