output "custom_model_id" {
  description = "ID of the custom model (if created)"
  value       = try(aws_bedrock_custom_model.this[0].custom_model_id, null)
}

output "custom_model_arn" {
  description = "ARN of the custom model (if created)"
  value       = try(aws_bedrock_custom_model.this[0].custom_model_arn, null)
}

output "custom_model_name" {
  description = "Name of the custom model (if created)"
  value       = try(aws_bedrock_custom_model.this[0].custom_model_name, null)
}

output "guardrail_id" {
  description = "ID of the guardrail (if created)"
  value       = try(aws_bedrock_guardrail.this[0].guardrail_id, null)
}

output "guardrail_arn" {
  description = "ARN of the guardrail (if created)"
  value       = try(aws_bedrock_guardrail.this[0].guardrail_arn, null)
}

output "knowledge_base_id" {
  description = "ID of the knowledge base (if created)"
  value       = try(aws_bedrock_knowledge_base.this[0].knowledge_base_id, null)
}

output "knowledge_base_arn" {
  description = "ARN of the knowledge base (if created)"
  value       = try(aws_bedrock_knowledge_base.this[0].knowledge_base_arn, null)
}

output "data_source_id" {
  description = "ID of the knowledge base data source (if created)"
  value       = try(aws_bedrock_knowledge_base_data_source.this[0].data_source_id, null)
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by Bedrock"
  value       = local.role_arn
}

output "iam_role_name" {
  description = "Name of the IAM role created (if created by module)"
  value       = try(aws_iam_role.bedrock_role[0].name, null)
}


