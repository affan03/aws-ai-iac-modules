variable "name" {
  description = "Name for the Comprehend resource"
  type        = string
}

variable "language_code" {
  description = "Language code for the documents (e.g., en, es, fr)"
  type        = string
  default     = "en"
}

variable "resource_type" {
  description = "Type of Comprehend resource to create: classifier or recognizer"
  type        = string
  validation {
    condition     = contains(["classifier", "recognizer"], var.resource_type)
    error_message = "Resource type must be either 'classifier' or 'recognizer'."
  }
}

variable "s3_bucket_name" {
  description = "S3 bucket name where training data is stored"
  type        = string
}

variable "s3_key_prefix" {
  description = "S3 key prefix for organizing data (optional)"
  type        = string
  default     = ""
}

variable "input_s3_uri" {
  description = "S3 URI for training data (classifier)"
  type        = string
  default     = null
}

variable "output_s3_uri" {
  description = "Optional S3 URI where output results are stored (classifier jobs)"
  type        = string
  default     = null
}

variable "entity_types" {
  description = "List of entity types for the recognizer"
  type        = list(string)
  default     = []
}

variable "documents_s3_uri" {
  description = "S3 URI for training documents (recognizer)"
  type        = string
  default     = null
}

variable "entities_s3_uri" {
  description = "S3 URI for entity list (recognizer)"
  type        = string
  default     = null
}

variable "annotations_s3_uri" {
  description = "S3 URI for annotations file (recognizer)"
  type        = string
  default     = null
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
