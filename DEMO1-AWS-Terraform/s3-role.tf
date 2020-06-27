
#Create a custom role for s3 bucket
resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2-role" {
  name = "ec2-role"
  role = "aws_iam_role.ec2-role.name"
}


/* Adding IAM Policies
To give full access to S3 bucket
*/
resource "aws_iam_role_policy" "ec2-role-policy" {
  name = "ec2-role-policy"
  role = "aws_iam_role.ec2-role.id"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
