variable "name" {
  description = "Name for the Rekognition resource"
  type        = string
}

variable "resource_type" {
  description = "Type of Rekognition resource to create: collection, stream_processor, project, or custom_labels_model"
  type        = string
  validation {
    condition     = contains(["collection", "stream_processor", "project", "custom_labels_model"], var.resource_type)
    error_message = "Resource type must be one of: 'collection', 'stream_processor', 'project', or 'custom_labels_model'."
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

# Collection Variables
variable "collection_id" {
  description = "ID for the face collection (defaults to name if not provided)"
  type        = string
  default     = null
}

# Stream Processor Variables
variable "kinesis_video_stream_arn" {
  description = "ARN of the Kinesis Video Stream for stream processor"
  type        = string
  default     = null
}

variable "kinesis_data_stream_arn" {
  description = "ARN of the Kinesis Data Stream for output"
  type        = string
  default     = null
}

variable "kinesis_data_stream_role_arn" {
  description = "IAM role ARN for Kinesis Data Stream access"
  type        = string
  default     = null
}

variable "s3_destination" {
  description = "S3 destination configuration for stream processor output"
  type = object({
    bucket = string
    key_prefix = optional(string, "")
  })
  default = null
}

variable "face_search_settings" {
  description = "Face search settings for stream processor"
  type = object({
    collection_id = string
    face_match_threshold = optional(number, 80.0)
  })
  default = null
}

variable "settings" {
  description = "Settings for stream processor"
  type = object({
    face_search = optional(object({
      collection_id = string
      face_match_threshold = optional(number, 80.0)
    }))
  })
  default = null
}

# Project Variables
variable "project_name" {
  description = "Name of the Rekognition project (defaults to name if not provided)"
  type        = string
  default     = null
}

variable "project_description" {
  description = "Description of the project"
  type        = string
  default     = ""
}

# Custom Labels Model Variables
variable "custom_labels_model_name" {
  description = "Name of the custom labels model"
  type        = string
  default     = null
}

variable "project_arn" {
  description = "ARN of the Rekognition project (if project is created separately)"
  type        = string
  default     = null
}

variable "training_data_config" {
  description = "Training data configuration for custom labels model"
  type = object({
    assets = optional(list(object({
      ground_truth_manifest = object({
        s3_object = object({
          bucket = string
          name   = string
        })
      })
    })), [])
    s3_bucket = optional(string)
  })
  default = null
}

variable "testing_data_config" {
  description = "Testing data configuration for custom labels model"
  type = object({
    assets = optional(list(object({
      ground_truth_manifest = object({
        s3_object = object({
          bucket = string
          name   = string
        })
      })
    })), [])
    auto_create = optional(bool, false)
  })
  default = null
}

variable "output_config" {
  description = "Output configuration for custom labels model"
  type = object({
    s3_bucket = string
    s3_key_prefix = optional(string, "")
  })
  default = null
}

# S3 Configuration
variable "s3_bucket_name" {
  description = "S3 bucket name for input images/videos and output results"
  type        = string
  default     = null
}

variable "s3_key_prefix" {
  description = "S3 key prefix for organizing data (optional)"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

