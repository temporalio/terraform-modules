output "role_arn" {
  description = "ARN of the IAM role created for Temporal Cloud. Provide this value to Temporal Cloud to complete the setup."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role."
  value       = aws_iam_role.this.name
}

output "lambda_function_arns" {
  description = "Lambda function ARNs that Temporal Cloud is permitted to invoke."
  value       = var.lambda_function_arns
}
