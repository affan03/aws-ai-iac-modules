# IAM Role for Bedrock
resource "aws_iam_role" "bedrock_role" {
  count = var.existing_role_arn == null ? 1 : 0
  name  = "${var.name}-bedrock-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "bedrock_s3_policy" {
  count       = var.existing_role_arn == null && var.s3_bucket_name != null ? 1 : 0
  name        = "${var.name}-bedrock-s3-policy"
  description = "Policy for Bedrock to access S3 resources"

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

# IAM Policy for Bedrock Service Access
resource "aws_iam_policy" "bedrock_service_policy" {
  count       = var.existing_role_arn == null ? 1 : 0
  name        = "${var.name}-bedrock-service-policy"
  description = "Policy for Bedrock service permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Attach S3 policy to role
resource "aws_iam_role_policy_attachment" "bedrock_s3_attachment" {
  count      = var.existing_role_arn == null && var.s3_bucket_name != null ? 1 : 0
  policy_arn = aws_iam_policy.bedrock_s3_policy[0].arn
  role       = aws_iam_role.bedrock_role[0].name
}

# Attach service policy to role
resource "aws_iam_role_policy_attachment" "bedrock_service_attachment" {
  count      = var.existing_role_arn == null ? 1 : 0
  policy_arn = aws_iam_policy.bedrock_service_policy[0].arn
  role       = aws_iam_role.bedrock_role[0].name
}

# Custom Model
resource "aws_bedrock_custom_model" "this" {
  count                  = var.resource_type == "custom_model" ? 1 : 0
  custom_model_name      = var.name
  base_model_identifier  = var.base_model_identifier
  job_name               = "${var.name}-training-job"
  role_arn               = local.role_arn

  dynamic "training_data_config" {
    for_each = var.training_data_config != null ? [var.training_data_config] : []
    content {
      s3_uri = training_data_config.value.s3_uri
    }
  }

  dynamic "validation_data_config" {
    for_each = var.validation_data_config != null ? [var.validation_data_config] : []
    content {
      s3_uri = validation_data_config.value.s3_uri
    }
  }

  dynamic "hyperparameters" {
    for_each = var.hyperparameters
    content {
      key   = hyperparameters.key
      value = hyperparameters.value
    }
  }

  dynamic "output_data_config" {
    for_each = var.output_data_config != null ? [var.output_data_config] : []
    content {
      s3_uri = output_data_config.value.s3_uri
    }
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.bedrock_s3_attachment[0],
    aws_iam_role_policy_attachment.bedrock_service_attachment[0]
  ] : []
}

# Guardrail
resource "aws_bedrock_guardrail" "this" {
  count                        = var.resource_type == "guardrail" ? 1 : 0
  name                         = var.name
  blocked_input_messaging      = var.blocked_input_messaging
  blocked_outputs_messaging    = var.blocked_outputs_messaging

  dynamic "content_policy_config" {
    for_each = var.content_policy_config != null ? [var.content_policy_config] : []
    content {
      dynamic "filters_config" {
        for_each = try(content_policy_config.value.filters_config, [])
        content {
          input_strength  = filters_config.value.input_strength
          output_strength = filters_config.value.output_strength
          type            = filters_config.value.type
        }
      }
    }
  }

  dynamic "word_policy_config" {
    for_each = var.word_policy_config != null ? [var.word_policy_config] : []
    content {
      dynamic "words_config" {
        for_each = try(word_policy_config.value.words_config, [])
        content {
          text = words_config.value.text
        }
      }
      dynamic "managed_word_lists_config" {
        for_each = try(word_policy_config.value.managed_word_lists_config, [])
        content {
          type = managed_word_lists_config.value.type
        }
      }
    }
  }

  dynamic "topic_policy_config" {
    for_each = var.topic_policy_config != null ? [var.topic_policy_config] : []
    content {
      dynamic "topics_config" {
        for_each = try(topic_policy_config.value.topics_config, [])
        content {
          name       = topics_config.value.name
          definition = topics_config.value.definition
          examples   = try(topics_config.value.examples, [])
          type       = topics_config.value.type
        }
      }
    }
  }

  dynamic "sensitive_information_policy_config" {
    for_each = var.sensitive_information_policy_config != null ? [var.sensitive_information_policy_config] : []
    content {
      dynamic "pii_entities_config" {
        for_each = try(sensitive_information_policy_config.value.pii_entities_config, [])
        content {
          action = pii_entities_config.value.action
          type   = pii_entities_config.value.type
        }
      }
      dynamic "regexes_config" {
        for_each = try(sensitive_information_policy_config.value.regexes_config, [])
        content {
          action      = regexes_config.value.action
          description = try(regexes_config.value.description, null)
          name        = regexes_config.value.name
          pattern     = regexes_config.value.pattern
        }
      }
    }
  }

  tags = var.tags
}

# Knowledge Base
resource "aws_bedrock_knowledge_base" "this" {
  count       = var.resource_type == "knowledge_base" ? 1 : 0
  name        = var.knowledge_base_name != null ? var.knowledge_base_name : var.name
  description = var.description
  role_arn    = var.role_arn != null ? var.role_arn : local.role_arn

  dynamic "storage_configuration" {
    for_each = var.storage_configuration != null ? [var.storage_configuration] : []
    content {
      type = storage_configuration.value.type

      dynamic "opensearch_serverless_configuration" {
        for_each = try(storage_configuration.value.opensearch_serverless_configuration, null) != null ? [storage_configuration.value.opensearch_serverless_configuration] : []
        content {
          collection_arn = opensearch_serverless_configuration.value.collection_arn
          field_mapping {
            vector_field   = opensearch_serverless_configuration.value.field_mapping.vector_field
            metadata_field = opensearch_serverless_configuration.value.field_mapping.metadata_field
            text_field     = opensearch_serverless_configuration.value.field_mapping.text_field
          }
        }
      }

      dynamic "pinecone_configuration" {
        for_each = try(storage_configuration.value.pinecone_configuration, null) != null ? [storage_configuration.value.pinecone_configuration] : []
        content {
          connection_string      = pinecone_configuration.value.connection_string
          credentials_secret_arn = pinecone_configuration.value.credentials_secret_arn
          field_mapping {
            vector_field   = pinecone_configuration.value.field_mapping.vector_field
            metadata_field = pinecone_configuration.value.field_mapping.metadata_field
            text_field     = pinecone_configuration.value.field_mapping.text_field
          }
        }
      }

      dynamic "rds_configuration" {
        for_each = try(storage_configuration.value.rds_configuration, null) != null ? [storage_configuration.value.rds_configuration] : []
        content {
          credentials_secret_arn = rds_configuration.value.credentials_secret_arn
          database_name          = rds_configuration.value.database_name
          field_mapping {
            vector_field     = rds_configuration.value.field_mapping.vector_field
            metadata_field   = rds_configuration.value.field_mapping.metadata_field
            primary_key_field = rds_configuration.value.field_mapping.primary_key_field
            text_field       = rds_configuration.value.field_mapping.text_field
          }
          resource_arn = rds_configuration.value.resource_arn
          table_name   = rds_configuration.value.table_name
        }
      }
    }
  }

  tags = var.tags

  depends_on = var.existing_role_arn == null ? [
    aws_iam_role_policy_attachment.bedrock_s3_attachment[0],
    aws_iam_role_policy_attachment.bedrock_service_attachment[0]
  ] : []
}

# Knowledge Base Data Source
resource "aws_bedrock_knowledge_base_data_source" "this" {
  count              = var.resource_type == "knowledge_base" && var.data_source != null ? 1 : 0
  knowledge_base_id  = aws_bedrock_knowledge_base.this[0].knowledge_base_id
  name               = var.data_source.name
  description        = try(var.data_source.description, null)
  data_source_id     = try(var.data_source.data_source_id, null)

  data_source_configuration {
    type = var.data_source.data_source_configuration.type

    dynamic "s3_configuration" {
      for_each = var.data_source.data_source_configuration.type == "S3" && try(var.data_source.data_source_configuration.s3_configuration, null) != null ? [var.data_source.data_source_configuration.s3_configuration] : []
      content {
        bucket_arn            = s3_configuration.value.bucket_arn
        bucket_owner_account_id = try(s3_configuration.value.bucket_owner_account_id, null)
        inclusion_prefixes    = try(s3_configuration.value.inclusion_prefixes, [])
      }
    }
  }

  dynamic "vector_ingestion_configuration" {
    for_each = try(var.data_source.vector_ingestion_configuration, null) != null ? [var.data_source.vector_ingestion_configuration] : []
    content {
      dynamic "chunking_configuration" {
        for_each = try(vector_ingestion_configuration.value.chunking_configuration, null) != null ? [vector_ingestion_configuration.value.chunking_configuration] : []
        content {
          chunking_strategy = chunking_configuration.value.chunking_strategy

          dynamic "fixed_size_chunking_configuration" {
            for_each = try(chunking_configuration.value.fixed_size_chunking_configuration, null) != null ? [chunking_configuration.value.fixed_size_chunking_configuration] : []
            content {
              max_tokens         = fixed_size_chunking_configuration.value.max_tokens
              overlap_percentage = fixed_size_chunking_configuration.value.overlap_percentage
            }
          }
        }
      }
    }
  }

  tags = var.tags
}

# Model Invocation Logging Configuration
resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  count = var.resource_type == "logging_config" && var.logging_config != null ? 1 : 0

  logging_config {
    text_data_delivery_enabled     = try(var.logging_config.text_data_delivery_enabled, false)
    image_data_delivery_enabled    = try(var.logging_config.image_data_delivery_enabled, false)
    embedding_data_delivery_enabled = try(var.logging_config.embedding_data_delivery_enabled, false)

    dynamic "s3_config" {
      for_each = try(var.logging_config.s3_config, null) != null ? [var.logging_config.s3_config] : []
      content {
        bucket_name = s3_config.value.bucket_name
        key_prefix  = try(s3_config.value.key_prefix, "")
      }
    }

    dynamic "cloudwatch_config" {
      for_each = try(var.logging_config.cloudwatch_config, null) != null ? [var.logging_config.cloudwatch_config] : []
      content {
        log_group_name = cloudwatch_config.value.log_group_name

        dynamic "large_data_delivery_s3_config" {
          for_each = try(cloudwatch_config.value.large_data_delivery_s3_config, null) != null ? [cloudwatch_config.value.large_data_delivery_s3_config] : []
          content {
            bucket_name = large_data_delivery_s3_config.value.bucket_name
            key_prefix  = try(large_data_delivery_s3_config.value.key_prefix, "")
          }
        }
      }
    }
  }
}

