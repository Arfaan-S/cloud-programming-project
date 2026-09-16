# 1. Application Load Balancer (Public-facing)
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"

  # Attach the public ALB security group
  security_groups = [aws_security_group.alb_sg.id]

  # Deployed across two public subnets for High Availability
  subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = { Name = "web-alb" }
}

# 2. Target Group (The destination for the traffic)
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Ensures traffic is only sent to healthy instances
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }
}

# 3. ALB Listener (Listens for incoming HTTP traffic)
resource "aws_lb_listener" "web_listener_http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# 4. Attach Auto Scaling Group to the Target Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  lb_target_group_arn    = aws_lb_target_group.web_tg.arn
}