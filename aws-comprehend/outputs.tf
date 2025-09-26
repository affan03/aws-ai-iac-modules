output "classifier_id" {
  description = "ID of the classifier (if created)"
  value       = try(aws_comprehend_document_classifier.this[0].id, null)
}

output "classifier_arn" {
  description = "ARN of the classifier (if created)"
  value       = try(aws_comprehend_document_classifier.this[0].arn, null)
}

output "recognizer_id" {
  description = "ID of the recognizer (if created)"
  value       = try(aws_comprehend_entity_recognizer.this[0].id, null)
}

output "recognizer_arn" {
  description = "ARN of the recognizer (if created)"
  value       = try(aws_comprehend_entity_recognizer.this[0].arn, null)
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by Comprehend"
  value       = local.role_arn
}

output "iam_role_name" {
  description = "Name of the IAM role created (if created by module)"
  value       = try(aws_iam_role.comprehend_role[0].name, null)
}