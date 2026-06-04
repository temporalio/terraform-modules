resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = "The role Temporal Cloud uses to invoke Lambda functions for Serverless Workers"
  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.temporal_cloud_principals
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_invoke" {
  name = "Temporal-Cloud-Lambda-Invoke-Permissions"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction", "lambda:GetFunction"]
        Resource = var.lambda_function_arns
      }
    ]
  })
}
