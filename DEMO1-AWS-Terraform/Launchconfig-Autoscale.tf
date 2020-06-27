
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "service"

  # Launch configuration
  lc_name = "terraform-lc"

  image_id        = "ami-079f731edfe27c29c"
  instance_type   = "t2.micro"
  security_groups = ["sg-015314798ded8811d"]
  key_name        = "grace-keypair"
  #iam_instance_profile        = "aws_iam_instance_profile.ec2-role.name"
  enable_monitoring           = false
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd mysql-server awscli
        sudo service httpd start
        sudo service mysqld start
        sudo chkconfig httpd on
    EOF

  # Auto scaling group
  asg_name                  = "terraform-asg"
  vpc_zone_identifier       = ["subnet-0dd0525cbc843e5f0"]
  target_group_arns         = "aws_lb_target_group.my-target-group.arn"
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Name"
      value               = "Apache"
      propagate_at_launch = true
    },
  ]
}
