locals {
  role_arn = var.existing_role_arn != null ? var.existing_role_arn : aws_iam_role.textract_role[0].arn
}


