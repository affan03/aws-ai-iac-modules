# IAM Role for Rekognition
resource "aws_iam_role" "rekognition_role" {
  count = var.existing_role_arn == null ? 1 : 0
  name  = "${var.name}-rekognition-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rekognition.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "rekognition_s3_policy" {
  count       = var.existing_role_arn == null && var.s3_bucket_name != null ? 1 : 0
  name        = "${var.name}-rekognition-s3-policy"
  description = "Policy for Rekognition to access S3 resources"

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

# IAM Policy for Rekognition Service Access
resource "aws_iam_policy" "rekognition_service_policy" {
  count       = var.existing_role_arn == null ? 1 : 0
  name        = "${var.name}-rekognition-service-policy"
  description = "Policy for Rekognition service permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rekognition:*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for Kinesis Access (for stream processors)
resource "aws_iam_policy" "rekognition_kinesis_policy" {
  count       = var.existing_role_arn == null && var.kinesis_video_stream_arn != null ? 1 : 0
  name        = "${var.name}-rekognition-kinesis-policy"
  description = "Policy for Rekognition to access Kinesis streams"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesisvideo:GetDataEndpoint",
          "kinesisvideo:GetMedia"
        ]
        Resource = var.kinesis_video_stream_arn
      },
      {
        Effect = "Allow"
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = var.kinesis_data_stream_arn != null ? var.kinesis_data_stream_arn : "*"
      }
    ]
  })

  tags = var.tags
}

# Attach S3 policy to role
resource "aws_iam_role_policy_attachment" "rekognition_s3_attachment" {
  count      = var.existing_role_arn == null && var.s3_bucket_name != null ? 1 : 0
  policy_arn = aws_iam_policy.rekognition_s3_policy[0].arn
  role       = aws_iam_role.rekognition_role[0].name
}

# Attach service policy to role
resource "aws_iam_role_policy_attachment" "rekognition_service_attachment" {
  count      = var.existing_role_arn == null ? 1 : 0
  policy_arn = aws_iam_policy.rekognition_service_policy[0].arn
  role       = aws_iam_role.rekognition_role[0].name
}

# Attach Kinesis policy to role
resource "aws_iam_role_policy_attachment" "rekognition_kinesis_attachment" {
  count      = var.existing_role_arn == null && var.kinesis_video_stream_arn != null ? 1 : 0
  policy_arn = aws_iam_policy.rekognition_kinesis_policy[0].arn
  role       = aws_iam_role.rekognition_role[0].name
}

# Rekognition Collection
resource "aws_rekognition_collection" "this" {
  count = var.resource_type == "collection" ? 1 : 0
  id    = var.collection_id != null ? var.collection_id : var.name

  tags = var.tags
}

# Rekognition Stream Processor
resource "aws_rekognition_stream_processor" "this" {
  count = var.resource_type == "stream_processor" ? 1 : 0
  name  = var.name
  role_arn = local.role_arn

  input {
    kinesis_video_stream {
      arn = var.kinesis_video_stream_arn
    }
  }

  dynamic "output" {
    for_each = var.kinesis_data_stream_arn != null ? [1] : []
    content {
      kinesis_data_stream {
        arn = var.kinesis_data_stream_arn
      }
    }
  }

  dynamic "output" {
    for_each = var.s3_destination != null ? [1] : []
    content {
      s3_destination {
        bucket = var.s3_destination.bucket
        key_prefix = try(var.s3_destination.key_prefix, "")
      }
    }
  }

  dynamic "settings" {
    for_each = var.settings != null ? [var.settings] : []
    content {
      dynamic "face_search" {
        for_each = try(settings.value.face_search, null) != null ? [settings.value.face_search] : []
        content {
          collection_id = face_search.value.collection_id
          face_match_threshold = try(face_search.value.face_match_threshold, 80.0)
        }
      }
    }
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.rekognition_s3_attachment[0],
    aws_iam_role_policy_attachment.rekognition_service_attachment[0],
    aws_iam_role_policy_attachment.rekognition_kinesis_attachment[0]
  ] : []
}

# Rekognition Project
resource "aws_rekognition_project" "this" {
  count = var.resource_type == "project" ? 1 : 0
  name  = var.project_name != null ? var.project_name : var.name

  tags = var.tags
}

# Rekognition Custom Labels Model
resource "aws_rekognition_custom_labels_model" "this" {
  count = var.resource_type == "custom_labels_model" ? 1 : 0
  name  = var.custom_labels_model_name != null ? var.custom_labels_model_name : var.name
  project_arn = var.project_arn != null ? var.project_arn : try(aws_rekognition_project.this[0].arn, null)

  dynamic "training_data_config" {
    for_each = var.training_data_config != null ? [var.training_data_config] : []
    content {
      dynamic "assets" {
        for_each = try(training_data_config.value.assets, [])
        content {
          ground_truth_manifest {
            s3_object {
              bucket = assets.value.ground_truth_manifest.s3_object.bucket
              name   = assets.value.ground_truth_manifest.s3_object.name
            }
          }
        }
      }
      s3_bucket = try(training_data_config.value.s3_bucket, null)
    }
  }

  dynamic "testing_data_config" {
    for_each = var.testing_data_config != null ? [var.testing_data_config] : []
    content {
      dynamic "assets" {
        for_each = try(testing_data_config.value.assets, [])
        content {
          ground_truth_manifest {
            s3_object {
              bucket = assets.value.ground_truth_manifest.s3_object.bucket
              name   = assets.value.ground_truth_manifest.s3_object.name
            }
          }
        }
      }
      auto_create = try(testing_data_config.value.auto_create, false)
    }
  }

  dynamic "output_config" {
    for_each = var.output_config != null ? [var.output_config] : []
    content {
      s3_bucket = output_config.value.s3_bucket
      s3_key_prefix = try(output_config.value.s3_key_prefix, "")
    }
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.rekognition_s3_attachment[0],
    aws_iam_role_policy_attachment.rekognition_service_attachment[0]
  ] : []
}

