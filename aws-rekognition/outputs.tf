output "collection_id" {
  description = "ID of the collection (if created)"
  value       = try(aws_rekognition_collection.this[0].id, null)
}

output "collection_arn" {
  description = "ARN of the collection (if created)"
  value       = try(aws_rekognition_collection.this[0].arn, null)
}

output "stream_processor_id" {
  description = "ID of the stream processor (if created)"
  value       = try(aws_rekognition_stream_processor.this[0].id, null)
}

output "stream_processor_arn" {
  description = "ARN of the stream processor (if created)"
  value       = try(aws_rekognition_stream_processor.this[0].arn, null)
}

output "stream_processor_status" {
  description = "Status of the stream processor (if created)"
  value       = try(aws_rekognition_stream_processor.this[0].status, null)
}

output "project_id" {
  description = "ID of the project (if created)"
  value       = try(aws_rekognition_project.this[0].id, null)
}

output "project_arn" {
  description = "ARN of the project (if created)"
  value       = try(aws_rekognition_project.this[0].arn, null)
}

output "custom_labels_model_arn" {
  description = "ARN of the custom labels model (if created)"
  value       = try(aws_rekognition_custom_labels_model.this[0].arn, null)
}

output "custom_labels_model_status" {
  description = "Status of the custom labels model (if created)"
  value       = try(aws_rekognition_custom_labels_model.this[0].status, null)
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by Rekognition"
  value       = local.role_arn
}

output "iam_role_name" {
  description = "Name of the IAM role created (if created by module)"
  value       = try(aws_iam_role.rekognition_role[0].name, null)
}

