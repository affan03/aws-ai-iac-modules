resource "aws_iam_role" "comprehend_role" {
  count = var.existing_role_arn == null ? 1 : 0
  name  = "${var.name}-comprehend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "comprehend.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "comprehend_s3_policy" {
  count       = var.existing_role_arn == null ? 1 : 0
  name        = "${var.name}-comprehend-s3-policy"
  description = "Policy for Comprehend to access S3 resources"

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
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}${var.s3_key_prefix != "" ? "/${var.s3_key_prefix}" : ""}/*"
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

resource "aws_iam_policy" "comprehend_service_policy" {
  count       = var.existing_role_arn == null ? 1 : 0
  name        = "${var.name}-comprehend-service-policy"
  description = "Policy for Comprehend service permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "comprehend:*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "comprehend_s3_attachment" {
  count      = var.existing_role_arn == null ? 1 : 0
  policy_arn = aws_iam_policy.comprehend_s3_policy[0].arn
  role       = aws_iam_role.comprehend_role[0].name
}

resource "aws_iam_role_policy_attachment" "comprehend_service_attachment" {
  count      = var.existing_role_arn == null ? 1 : 0
  policy_arn = aws_iam_policy.comprehend_service_policy[0].arn
  role       = aws_iam_role.comprehend_role[0].name
}

resource "aws_comprehend_document_classifier" "this" {
  count                = var.resource_type == "classifier" ? 1 : 0
  name                 = var.name
  data_access_role_arn = local.role_arn
  language_code        = var.language_code

  input_data_config {
    s3_uri = var.input_s3_uri
  }

  dynamic "output_data_config" {
    for_each = var.output_s3_uri != null ? [1] : []
    content {
      s3_uri = var.output_s3_uri
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.comprehend_s3_attachment[0],
    aws_iam_role_policy_attachment.comprehend_service_attachment[0]
  ] : []
}

resource "aws_comprehend_entity_recognizer" "this" {
  count                = var.resource_type == "recognizer" ? 1 : 0
  name                 = var.name
  data_access_role_arn = local.role_arn
  language_code        = var.language_code

  input_data_config {
    dynamic "entity_types" {
      for_each = var.entity_types
      content {
        type = entity_types.value
      }
    }

    documents {
      s3_uri = var.documents_s3_uri
    }

    dynamic "entity_list" {
      for_each = var.entities_s3_uri != null && var.annotations_s3_uri == null ? [1] : []
      content {
        s3_uri = var.entities_s3_uri
      }
    }

    dynamic "annotations" {
      for_each = var.annotations_s3_uri != null ? [1] : []
      content {
        s3_uri = var.annotations_s3_uri
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.comprehend_s3_attachment[0],
    aws_iam_role_policy_attachment.comprehend_service_attachment[0]
  ] : []
}