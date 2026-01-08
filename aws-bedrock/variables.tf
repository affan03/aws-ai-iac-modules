variable "name" {
  description = "Name for the Bedrock resource"
  type        = string
}

variable "resource_type" {
  description = "Type of Bedrock resource to create: custom_model, guardrail, knowledge_base, or logging_config"
  type        = string
  validation {
    condition     = contains(["custom_model", "guardrail", "knowledge_base", "logging_config"], var.resource_type)
    error_message = "Resource type must be one of: 'custom_model', 'guardrail', 'knowledge_base', or 'logging_config'."
  }
}

variable "existing_role_arn" {
  description = "Existing IAM role ARN to use instead of creating a new one"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Custom Model Variables
variable "base_model_identifier" {
  description = "Base model identifier for custom model (e.g., amazon.titan-text-express-v1)"
  type        = string
  default     = null
}

variable "training_data_config" {
  description = "Training data configuration for custom model"
  type = object({
    s3_uri = string
  })
  default = null
}

variable "validation_data_config" {
  description = "Validation data configuration for custom model"
  type = object({
    s3_uri = string
  })
  default = null
}

variable "hyperparameters" {
  description = "Hyperparameters for custom model training"
  type        = map(string)
  default     = {}
}

variable "output_data_config" {
  description = "Output data configuration for custom model"
  type = object({
    s3_uri = string
  })
  default = null
}

variable "s3_bucket_name" {
  description = "S3 bucket name for training data and model artifacts"
  type        = string
  default     = null
}

variable "s3_key_prefix" {
  description = "S3 key prefix for organizing data (optional)"
  type        = string
  default     = ""
}

# Guardrail Variables
variable "blocked_input_messaging" {
  description = "Message to return when input is blocked"
  type        = string
  default     = "Your request contains content that is not allowed."
}

variable "blocked_outputs_messaging" {
  description = "Message to return when output is blocked"
  type        = string
  default     = "The response contains content that is not allowed."
}

variable "content_policy_config" {
  description = "Content policy configuration for guardrail"
  type = object({
    filters_config = optional(list(object({
      input_strength  = string
      output_strength = string
      type            = string
    })), [])
  })
  default = null
}

variable "word_policy_config" {
  description = "Word policy configuration for guardrail"
  type = object({
    words_config = optional(list(object({
      text = string
    })), [])
    managed_word_lists_config = optional(list(object({
      type = string
    })), [])
  })
  default = null
}

variable "topic_policy_config" {
  description = "Topic policy configuration for guardrail"
  type = object({
    topics_config = optional(list(object({
      name       = string
      definition = string
      examples   = optional(list(string), [])
      type       = string
    })), [])
  })
  default = null
}

variable "sensitive_information_policy_config" {
  description = "Sensitive information policy configuration for guardrail"
  type = object({
    pii_entities_config = optional(list(object({
      action = string
      type   = string
    })), [])
    regexes_config = optional(list(object({
      action      = string
      description = optional(string)
      name        = string
      pattern     = string
    })), [])
  })
  default = null
}

# Knowledge Base Variables
variable "knowledge_base_name" {
  description = "Name of the knowledge base"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the knowledge base"
  type        = string
  default     = ""
}

variable "role_arn" {
  description = "IAM role ARN for the knowledge base (overrides existing_role_arn for knowledge base)"
  type        = string
  default     = null
}

variable "embedding_model_arn" {
  description = "ARN of the embedding model to use"
  type        = string
  default     = null
}

variable "vector_knowledge_base_configuration" {
  description = "Vector knowledge base configuration"
  type = object({
    embedding_model_arn = string
  })
  default = null
}

variable "storage_configuration" {
  description = "Storage configuration for knowledge base"
  type = object({
    type = string
    opensearch_serverless_configuration = optional(object({
      collection_arn    = string
      field_mapping = object({
        vector_field   = string
        metadata_field = string
        text_field     = string
      })
    }))
    pinecone_configuration = optional(object({
      connection_string = string
      credentials_secret_arn = string
      field_mapping = object({
        vector_field   = string
        metadata_field = string
        text_field     = string
      })
    }))
    rds_configuration = optional(object({
      credentials_secret_arn = string
      database_name         = string
      field_mapping = object({
        vector_field   = string
        metadata_field = string
        primary_key_field = string
        text_field     = string
      })
      resource_arn    = string
      table_name      = string
    }))
  })
  default = null
}

variable "data_source" {
  description = "Data source configuration for knowledge base"
  type = object({
    name                = string
    data_source_id      = optional(string)
    description         = optional(string)
    data_source_configuration = object({
      type = string
      s3_configuration = optional(object({
        bucket_arn = string
        bucket_owner_account_id = optional(string)
        inclusion_prefixes = optional(list(string), [])
      }))
    })
    vector_ingestion_configuration = optional(object({
      chunking_configuration = optional(object({
        chunking_strategy = string
        fixed_size_chunking_configuration = optional(object({
          max_tokens = number
          overlap_percentage = number
        }))
      }))
    }))
  })
  default = null
}

# Logging Configuration Variables
variable "logging_config" {
  description = "Logging configuration for model invocations"
  type = object({
    text_data_delivery_enabled = optional(bool, false)
    image_data_delivery_enabled = optional(bool, false)
    embedding_data_delivery_enabled = optional(bool, false)
    s3_config = optional(object({
      bucket_name = string
      key_prefix  = optional(string, "")
    }))
    cloudwatch_config = optional(object({
      log_group_name = string
      large_data_delivery_s3_config = optional(object({
        bucket_name = string
        key_prefix  = optional(string, "")
      }))
    }))
  })
  default = null
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}



