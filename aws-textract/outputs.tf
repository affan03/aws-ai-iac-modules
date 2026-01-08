output "adapter_id" {
  description = "ID of the adapter (if created)"
  value       = try(aws_textract_adapter.this[0].adapter_id, null)
}

output "adapter_arn" {
  description = "ARN of the adapter (if created)"
  value       = try(aws_textract_adapter.this[0].adapter_arn, null)
}

output "adapter_name" {
  description = "Name of the adapter (if created)"
  value       = try(aws_textract_adapter.this[0].name, null)
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by Textract"
  value       = local.role_arn
}

output "iam_role_name" {
  description = "Name of the IAM role created (if created by module)"
  value       = try(aws_iam_role.textract_role[0].name, null)
}

output "s3_input_policy_arn" {
  description = "ARN of the S3 input policy (if created)"
  value       = try(aws_iam_policy.textract_s3_input_policy[0].arn, null)
}

output "s3_output_policy_arn" {
  description = "ARN of the S3 output policy (if created)"
  value       = try(aws_iam_policy.textract_s3_output_policy[0].arn, null)
}



