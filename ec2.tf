provider "aws" {
  region = "us-east-2"  # Specify your region
}



resource "aws_resourcegroups_group" "test-resource" {
name = "Ansible-SSM"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": ["Ansible-Managed-Instance]
    }
  ]
}
JSON
  }
}


resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "attach-ssm-policy"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_instance" "ec2" {
  ami           = "ami-id"
  instance_type = "t4g.small"
  subnet_id     = "subnet-id"

    # Enable a public IP
  associate_public_ip_address = true

  # Attach the security group
  vpc_security_group_ids = ["sg-id"]

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "Ansible-Managed-Instance"
  }
}

resource "aws_ssm_association" "ansible_association" {
  name            = "Install-Apache"
  targets  {
      key    = "InstanceIds"
      values = [aws_instance.ec2.id]
    }
}
