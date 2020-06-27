/* Define the target group:
This is going to provide a resource for use with Load Balancer.
*/
resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-demo1-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-03774726debc9181a"
}

/*Provides the ability to register instances
 with an Application Load Balancer (ALB)
 */
resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment" {
  target_group_arn = "aws_lb_target_group.my-target-group.arn"
  target_id        = "i-0562accfdcf77ba7e"
  port             = 80
}

# Define the load balancer
resource "aws_lb" "my-aws-alb" {
  name            = "my-demo1-alb"
  internal        = false
  security_groups = ["sg-015314798ded8811d"]
  subnets         = ["subnet-081ebf90128b4cc21", "subnet-063f1fb49c278d055"]

  tags = {
    Name = "my-demo1-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

# Provides a Load Balancer Listener resource
resource "aws_lb_listener" "my-demo1-alb-listner" {
  load_balancer_arn = "aws_lb.my-aws-alb.arn"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "aws_lb_target_group.my-target-group.arn"
  }
}
