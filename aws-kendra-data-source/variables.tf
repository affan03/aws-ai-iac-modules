variable "kendra_data_source_name" {
  description = "Name of the Kendra data source"
  type        = string
}

variable "index_id" {
  description = "ID of the Kendra index to attach this data source to"
  type        = string
}

variable "kendra_data_source_type" {
  description = "Type of the Kendra data source (e.g. S3, WEB_CRAWLER)"
  type        = string
}

variable "kendra_data_source_role_arn" {
  description = "IAM role ARN for the Kendra data source"
  type        = string
}

variable "kendra_data_source_description" {
  description = "Description of the data source"
  type        = string
  default     = ""
}

variable "language_code" {
  description = "Language code (e.g., en, fr, es)"
  type        = string
  default     = "en"
}

variable "s3_bucket_name" {
  description = "S3 bucket name used as the data source"
  type        = string
}

variable "inclusion_prefixes" {
  description = "List of prefixes to include in the indexing"
  type        = list(string)
  default     = []
}

variable "schedule" {
  description = "Sync schedule in cron expression format"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "inclusion_patterns" {
  description = "Optional inclusion patterns for filtering files"
  type        = list(string)
  default     = []
}

variable "exclusion_patterns" {
  description = "Optional exclusion patterns for filtering files"
  type        = list(string)
  default     = []
}

variable "enable_acl" {
  description = "Enable access control list configuration"
  type        = bool
  default     = false
}

variable "acl_key_path" {
  description = "S3 key path for the ACL JSON file"
  type        = string
  default     = ""
  validation {
    condition     = var.enable_acl == false || (var.enable_acl == true && length(var.acl_key_path) > 0)
    error_message = "You must provide a valid acl_key_path if enable_acl is true."
  }
}

variable "enable_metadata_config" {
  description = "Enable documents metadata configuration"
  type        = bool
  default     = false
}

variable "metadata_s3_prefix" {
  description = "S3 prefix path for documents metadata"
  type        = string
  default     = ""
  validation {
    condition     = var.enable_metadata_config == false || (var.enable_metadata_config == true && length(var.metadata_s3_prefix) > 0)
    error_message = "You must provide metadata_s3_prefix when enable_metadata_config is true."
  }
}


variable "enable_seed_urls" {
  description = "Enable seed URL crawling for web crawler"
  type        = bool
  default     = false
}

variable "seed_urls" {
  description = "List of seed URLs to crawl"
  type        = list(string)
  default     = []
  validation {
    condition     = var.enable_seed_urls == false || (var.enable_seed_urls == true && length(var.seed_urls) > 0)
    error_message = "You must provide seed_urls if enable_seed_urls is true."
  }
}

variable "web_crawler_mode" {
  description = "Crawl mode: HOST_ONLY, SUBDOMAINS, EVERYTHING"
  type        = string
  default     = "HOST_ONLY"
}

variable "enable_sitemaps" {
  description = "Enable site map crawling for web crawler"
  type        = bool
  default     = false
}

variable "site_maps" {
  description = "List of site map URLs to crawl"
  type        = list(string)
  default     = []
  validation {
    condition     = var.enable_sitemaps == false || (var.enable_sitemaps == true && length(var.site_maps) > 0)
    error_message = "You must provide site_maps if enable_sitemaps is true."
  }
}

variable "crawl_depth" {
  type        = number
  default     = 2
  description = "Max depth to crawl for web pages"
}

variable "max_links_per_page" {
  type        = number
  default     = 100
  description = "Max links to crawl per page"
}

variable "max_urls_per_minute_crawl_rate" {
  description = "Maximum number of URLs to crawl per minute"
  type        = number
  default     = null
}

variable "url_inclusion_patterns" {
  description = "List of regex patterns to include URLs"
  type        = list(string)
  default     = []
}

variable "url_exclusion_patterns" {
  description = "List of regex patterns to exclude URLs"
  type        = list(string)
  default     = []
}

variable "enable_proxy" {
  description = "Enable proxy configuration for web crawler"
  type        = bool
  default     = false
}

variable "proxy_credentials_arn" {
  description = "ARN of secret containing proxy credentials"
  type        = string
  default     = ""
  validation {
    condition     = var.enable_proxy == false || (var.enable_proxy == true && length(var.proxy_credentials_arn) > 0)
    error_message = "You must provide proxy_credentials_arn when enable_proxy is true."
  }
}

variable "proxy_host" {
  description = "Proxy host for the web crawler"
  type        = string
  default     = ""
}

variable "proxy_port" {
  description = "Proxy port for the web crawler"
  type        = number
  default     = 443
}

variable "enable_basic_auth" {
  description = "Enable basic authentication for web crawler"
  type        = bool
  default     = false
}

variable "basic_auth_credentials_arn" {
  description = "ARN of Secrets Manager secret storing basic auth credentials"
  type        = string
  default     = ""
  validation {
    condition     = var.enable_basic_auth == false || (var.enable_basic_auth == true && length(var.basic_auth_credentials_arn) > 0)
    error_message = "You must provide basic_auth_credentials_arn when enable_basic_auth is true."
  }
}

variable "basic_auth_host" {
  description = "Host for basic authentication"
  type        = string
  default     = ""
}

variable "basic_auth_port" {
  description = "Port for basic authentication"
  type        = number
  default     = 443
}


# === INDEX VARIABLES ===
variable "kendra_index_name" {
  description = "Name of the Kendra index"
  type        = string
}

variable "kendra_index_description" {
  description = "Description of the Kendra index"
  type        = string
  default     = ""
}

variable "kendra_index_role_arn" {
  description = "IAM role ARN for the Kendra index"
  type        = string
}

variable "kendra_index_edition" {
  description = "Edition of the index (DEVELOPER_EDITION or ENTERPRISE_EDITION)"
  type        = string
  default     = "DEVELOPER_EDITION"
}

variable "query_capacity_units" {
  description = "Number of query capacity units for the index"
  type        = number
  default     = 1
}

variable "storage_capacity_units" {
  description = "Number of storage capacity units for the index"
  type        = number
  default     = 1
}

variable "kms_key_id" {
  description = "KMS key ARN for encryption"
  type        = string
  default     = null
}

variable "user_group_resolution_mode" {
  description = "User group resolution mode (e.g., AWS_SSO)"
  type        = string
  default     = "AWS_SSO"
}

variable "metadata_configuration_updates" {
  description = "List of document metadata configuration updates"
  type = list(object({
    name = string
    type = string

    search = object({
      displayable = bool
      facetable   = bool
      searchable  = bool
      sortable    = bool
    })

    relevance = object({
      importance            = number
      freshness             = optional(bool)
      duration              = optional(string)
      rank_order            = optional(string)
      values_importance_map = optional(map(number))
    })
  }))
  default = []
}

variable "user_token_configurations" {
  description = "List of user token configurations for authentication"
  type = list(object({
    group_attribute_field     = string
    user_name_attribute_field = string
  }))
  default = []
}
