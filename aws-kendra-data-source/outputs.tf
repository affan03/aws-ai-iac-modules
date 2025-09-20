output "data_source_id" {
  description = "The ID of the Kendra data source"
  value       = aws_kendra_data_source.this.id
}

output "kendra_index_id" {
  description = "The ID of the Kendra index"
  value       = aws_kendra_index.this.id
}

output "kendra_index_arn" {
  description = "The ARN of the Kendra index"
  value       = aws_kendra_index.this.arn
}

output "kendra_index_status" {
  description = "The current status of the Kendra index"
  value       = aws_kendra_index.this.status
}

output "kendra_data_source_id" {
  description = "The ID of the Kendra data source"
  value       = aws_kendra_data_source.this.id
}

output "kendra_data_source_arn" {
  description = "The ARN of the Kendra data source"
  value       = aws_kendra_data_source.this.arn
}

output "kendra_data_source_status" {
  description = "The current status of the Kendra data source"
  value       = aws_kendra_data_source.this.status
}

output "kendra_index_role_arn" {
  value = aws_iam_role.kendra_index.arn
}

output "kendra_datasource_role_arn" {
  value = aws_iam_role.kendra_datasource.arn
}
