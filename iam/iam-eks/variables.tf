variable "name_prefix" {
  type        = string
  description = "Prefix used for IAM role names"
}

variable "environment" {
  type        = string
  description = "Environment name such as dev, qa, or prod"
}
