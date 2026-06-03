# Terraform AWS IAM Role Module For Serverless Workers

This module facilitates the configuration of an AWS IAM role, an essential step in the overall setup for Serverless Workers. The module provides support for the following functionalities:

- Creation of an IAM role in the customer's AWS account.
- Establishing trust with the Temporal Cloud AWS accounts via a cross-account assume-role policy, secured with an External ID.
- Granting `lambda:InvokeFunction` and `lambda:GetFunction` permissions on the specified Lambda functions.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.7
- AWS provider ~> 5.0
- AWS credentials configured for the account where the Lambda functions are deployed
- The `temporal_cloud_principals` values provided by Temporal Cloud during account setup

## Usage

Basic usage of this module is as follows:

```hcl
module "serverless-worker-lambda" {
  source = "terraform-modules/modules/serverless-workers/aws/lambda"

  external_id               = "<external-id>"
  temporal_cloud_principals = "<provided by Temporal Cloud>"

  lambda_function_arns = [
    "arn:aws:lambda:us-east-1:123456789012:function:my-worker-1",
    "arn:aws:lambda:us-east-1:123456789012:function:my-worker-2",
  ]

  # Optional: override the default role name
  # role_name = "Temporal-Cloud-Serverless-Worker"
}
```

Once applied, provide the `role_arn` output value to Temporal Cloud to complete the setup.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `external_id` | External ID provided by Temporal Cloud. Must be 5–45 characters: alphanumeric and `_+=,.@-`. | `string` | — | yes |
| `temporal_cloud_principals` | Temporal Cloud AWS IAM role ARNs permitted to assume this role. Provided by Temporal Cloud. | `list(string)` | — | yes |
| `lambda_function_arns` | Lambda function ARNs that Temporal Cloud is permitted to invoke. | `list(string)` | — | yes |
| `role_name` | Name of the IAM role to create. | `string` | `Temporal-Cloud-Serverless-Worker` | no |

## Outputs

| Name | Description |
|------|-------------|
| `role_arn` | ARN of the created IAM role. Provide this to Temporal Cloud. |
| `role_name` | Name of the created IAM role. |
| `lambda_function_arns` | Lambda function ARNs that Temporal Cloud is permitted to invoke. |
