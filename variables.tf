variable "aws_account_id" {
  type        = "string"
  description = "The AWS Account ID"
  default     = "THE-AWS-ACCOUNT-ID"
}

variable "aws_region" {
  type        = "string"
  description = "This is the region we use in AWS. Defaults to Ireland (eu-west-1)."
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  type        = "string"
  description = "The CIDR for VPC"
  default     = "172.30.0.0/16"
}
