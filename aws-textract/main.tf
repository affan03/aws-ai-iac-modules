# IAM Role for Textract
resource "aws_iam_role" "textract_role" {
  count = var.existing_role_arn == null ? 1 : 0
  name  = "${var.name}-textract-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "textract.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for S3 Access (Input)
resource "aws_iam_policy" "textract_s3_input_policy" {
  count       = var.existing_role_arn == null && var.s3_bucket_name != null ? 1 : 0
  name        = "${var.name}-textract-s3-input-policy"
  description = "Policy for Textract to read S3 documents"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for S3 Access (Output)
resource "aws_iam_policy" "textract_s3_output_policy" {
  count       = var.existing_role_arn == null && (var.s3_output_bucket_name != null || var.s3_bucket_name != null) ? 1 : 0
  name        = "${var.name}-textract-s3-output-policy"
  description = "Policy for Textract to write results to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_output_bucket_name != null ? var.s3_output_bucket_name : var.s3_bucket_name}${var.s3_output_key_prefix != "" ? "/${var.s3_output_key_prefix}" : ""}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for Textract Service Access
resource "aws_iam_policy" "textract_service_policy" {
  count       = var.existing_role_arn == null ? 1 : 0
  name        = "${var.name}-textract-service-policy"
  description = "Policy for Textract service permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "textract:*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Attach S3 input policy to role
resource "aws_iam_role_policy_attachment" "textract_s3_input_attachment" {
  count      = var.existing_role_arn == null && var.s3_bucket_name != null ? 1 : 0
  policy_arn = aws_iam_policy.textract_s3_input_policy[0].arn
  role       = aws_iam_role.textract_role[0].name
}

# Attach S3 output policy to role
resource "aws_iam_role_policy_attachment" "textract_s3_output_attachment" {
  count      = var.existing_role_arn == null && (var.s3_output_bucket_name != null || var.s3_bucket_name != null) ? 1 : 0
  policy_arn = aws_iam_policy.textract_s3_output_policy[0].arn
  role       = aws_iam_role.textract_role[0].name
}

# Attach service policy to role
resource "aws_iam_role_policy_attachment" "textract_service_attachment" {
  count      = var.existing_role_arn == null ? 1 : 0
  policy_arn = aws_iam_policy.textract_service_policy[0].arn
  role       = aws_iam_role.textract_role[0].name
}

# Textract Adapter
resource "aws_textract_adapter" "this" {
  count       = var.resource_type == "adapter" ? 1 : 0
  name        = var.adapter_name != null ? var.adapter_name : var.name
  description = var.description
  auto_update = var.auto_update

  dynamic "adapter_versions" {
    for_each = var.adapter_versions
    content {
      version_name = adapter_versions.value.version_name

      dataset_config {
        manifest_s3_object {
          bucket = adapter_versions.value.dataset_config.manifest_s3_object.bucket
          name   = adapter_versions.value.dataset_config.manifest_s3_object.name
        }
      }
    }
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.textract_s3_input_attachment[0],
    aws_iam_role_policy_attachment.textract_service_attachment[0]
  ] : []
}



