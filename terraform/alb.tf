resource "aws_lb_target_group" "web_tg" {
  name        = "cloud-lab-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.lab_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name    = "cloud-lab-web-tg"
    Project = "cloud-transition-lab"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "cloud-lab-alb-sg"
  description = "Allow HTTP inbound to ALB"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "cloud-lab-alb-sg"
    Project = "cloud-transition-lab"
  }
}

resource "aws_lb" "web_alb" {
  name               = "cloud-lab-web-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name    = "cloud-lab-web-alb"
    Project = "cloud-transition-lab"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "web_instance" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.public_web.id
  port             = 80
}
