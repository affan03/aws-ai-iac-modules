locals {
  role_arn = var.existing_role_arn != null ? var.existing_role_arn : aws_iam_role.comprehend_role[0].arn
}