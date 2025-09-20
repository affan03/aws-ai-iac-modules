resource "aws_kendra_data_source" "this" {
  name           = var.kendra_data_source_name
  index_id       = aws_kendra_index.this.id
  
  type           = var.kendra_data_source_type
  role_arn = aws_iam_role.kendra_datasource.arn
  schedule       = var.schedule
  description    = var.kendra_data_source_description
  language_code  = var.language_code

  configuration {

    # S3 Configuration
    dynamic "s3_configuration" {
      for_each = var.kendra_data_source_type == "S3" ? [1] : []
      content {
        bucket_name        = var.s3_bucket_name
        inclusion_prefixes = var.inclusion_prefixes
        inclusion_patterns = var.inclusion_patterns
        exclusion_patterns = var.exclusion_patterns

        dynamic "access_control_list_configuration" {
          for_each = var.enable_acl ? [1] : []
          content {
            key_path = var.acl_key_path
          }
        }

        dynamic "documents_metadata_configuration" {
          for_each = var.enable_metadata_config ? [1] : []
          content {
            s3_prefix = var.metadata_s3_prefix
          }
        }
      }
    }

    # Web Crawler Configuration
    dynamic "web_crawler_configuration" {
      for_each = var.kendra_data_source_type == "WEB_CRAWLER" ? [1] : []
      content {

        dynamic "authentication_configuration" {
          for_each = var.enable_basic_auth ? [1] : []
          content {
            basic_authentication {
              credentials = var.basic_auth_credentials_arn
              host        = var.basic_auth_host
              port        = var.basic_auth_port
            }
          }
        }

        dynamic "proxy_configuration" {
          for_each = var.enable_proxy ? [1] : []
          content {
            credentials = var.proxy_credentials_arn
            host        = var.proxy_host
            port        = var.proxy_port
          }
        }

        urls {
          dynamic "seed_url_configuration" {
            for_each = var.enable_seed_urls ? [1] : []
            content {
              seed_urls        = var.seed_urls
              web_crawler_mode = var.web_crawler_mode
            }
          }

          dynamic "site_maps_configuration" {
            for_each = var.enable_sitemaps ? [1] : []
            content {
              site_maps = var.site_maps
            }
          }
        }

        crawl_depth                      = var.crawl_depth
        max_links_per_page              = var.max_links_per_page
        max_urls_per_minute_crawl_rate  = var.max_urls_per_minute_crawl_rate
        url_inclusion_patterns          = var.url_inclusion_patterns
        url_exclusion_patterns          = var.url_exclusion_patterns
      }
    }
  }

  tags = var.tags
}


resource "aws_kendra_index" "this" {
  name        = var.kendra_index_name
  description = var.kendra_index_description
  edition     = var.kendra_index_edition
  role_arn = aws_iam_role.kendra_index.arn
  tags        = var.tags

  capacity_units {
    query_capacity_units   = var.query_capacity_units
    storage_capacity_units = var.storage_capacity_units
  }

  server_side_encryption_configuration {
    kms_key_id = var.kms_key_id
  }

  user_group_resolution_configuration {
    user_group_resolution_mode = var.user_group_resolution_mode
  }

  dynamic "document_metadata_configuration_updates" {
    for_each = var.metadata_configuration_updates
    content {
      name = document_metadata_configuration_updates.value.name
      type = document_metadata_configuration_updates.value.type

      search {
        displayable = document_metadata_configuration_updates.value.search.displayable
        facetable   = document_metadata_configuration_updates.value.search.facetable
        searchable  = document_metadata_configuration_updates.value.search.searchable
        sortable    = document_metadata_configuration_updates.value.search.sortable
      }

      relevance {
        importance            = document_metadata_configuration_updates.value.relevance.importance
        freshness             = try(document_metadata_configuration_updates.value.relevance.freshness, null)
        duration              = try(document_metadata_configuration_updates.value.relevance.duration, null)
        rank_order            = try(document_metadata_configuration_updates.value.relevance.rank_order, null)
        values_importance_map = try(document_metadata_configuration_updates.value.relevance.values_importance_map, {})
      }
    }
  }

  dynamic "user_token_configurations" {
    for_each = var.user_token_configurations
    content {
      json_token_type_configuration {
        group_attribute_field     = user_token_configurations.value.group_attribute_field
        user_name_attribute_field = user_token_configurations.value.user_name_attribute_field
      }
    }
  }
}


resource "aws_iam_role" "kendra_index" {
  name = "${var.kendra_index_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "kendra_datasource" {
  name = "${var.kendra_data_source_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "kendra_datasource_s3_read" {
  name = "s3-read"
  role = aws_iam_role.kendra_datasource.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "kendra_index_basic" {
  name = "kendra-index-basic"
  role = aws_iam_role.kendra_index.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowKMSDecrypt"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*" 
      }
    ]
  })
}
