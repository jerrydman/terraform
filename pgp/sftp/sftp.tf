## Create IAM Role and Policy
resource "aws_iam_role" "transfer_role" {
  name = "transfer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "transfer.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "transfer_policy" {
  name        = "transfer-policy"
  description = "Policy for Transfer Family server"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      Resource = ["${aws_s3_bucket.sftp_bucket.arn}/*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "transfer_policy_attach" {
  role       = aws_iam_role.transfer_role.name
  policy_arn = aws_iam_policy.transfer_policy.arn
}


## Create SFTP
resource "aws_transfer_server" "transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]

  endpoint_type = "PUBLIC"
  domain        = "S3"

  tags = var.tag_map
}

## Decrypt WorkFlow
resource "aws_transfer_workflow" "decrypt_workflow" {
  steps {
       type = "DECRYPT"
    decrypt_step_details {
      type = "DECRYPT"
      name = "decrypt"
      source_file_location = "${original.file}"
      overwrite_existing = true
      destination_file_location {
        s3_file_location {
          bucket = aws.aws_s3_bucket.sftp_bucket.bucket
          key = "decrypted.${file.name}"
        }
      }
    }
  }
}