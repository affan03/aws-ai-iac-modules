variable "name" {
  description = "Name for the Textract resource"
  type        = string
}

variable "resource_type" {
  description = "Type of Textract resource to create: adapter"
  type        = string
  validation {
    condition     = contains(["adapter"], var.resource_type)
    error_message = "Resource type must be 'adapter'."
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

# Adapter Variables
variable "adapter_name" {
  description = "Name of the adapter (defaults to name if not provided)"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the adapter"
  type        = string
  default     = ""
}

variable "auto_update" {
  description = "Whether to automatically update the adapter"
  type        = bool
  default     = false
}

variable "adapter_versions" {
  description = "List of adapter versions to create"
  type = list(object({
    version_name = string
    dataset_config = object({
      manifest_s3_object = object({
        bucket = string
        name   = string
      })
    })
  }))
  default = []
}

# S3 Configuration
variable "s3_bucket_name" {
  description = "S3 bucket name for input documents and output results"
  type        = string
  default     = null
}

variable "s3_key_prefix" {
  description = "S3 key prefix for organizing data (optional)"
  type        = string
  default     = ""
}

variable "s3_output_bucket_name" {
  description = "S3 bucket name for output results (if different from input bucket)"
  type        = string
  default     = null
}

variable "s3_output_key_prefix" {
  description = "S3 key prefix for output results"
  type        = string
  default     = ""
}

# KMS Configuration
variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

# Feature Types Configuration
variable "feature_types" {
  description = "List of feature types to enable: TABLES, FORMS, QUERIES, SIGNATURES, LAYOUT"
  type        = list(string)
  default     = ["TABLES", "FORMS"]
  validation {
    condition = alltrue([
      for ft in var.feature_types : contains(["TABLES", "FORMS", "QUERIES", "SIGNATURES", "LAYOUT"], ft)
    ])
    error_message = "Feature types must be one or more of: TABLES, FORMS, QUERIES, SIGNATURES, LAYOUT."
  }
}


