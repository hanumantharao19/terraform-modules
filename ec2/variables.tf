
variable "name" {
  description = "Name used for the EC2 instance and Name tag."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The name must not be empty."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance in the selected AWS region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to attach to the instance."
  type        = set(string)
}

variable "iam_instance_profile" {
  description = "Existing IAM instance profile name. Leave null if not required."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Existing EC2 key pair name. Leave null when using SSM."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 10

  validation {
    condition     = var.root_volume_size >= 10
    error_message = "The root volume must be at least 10 GiB."
  }
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2"], var.root_volume_type)
    error_message = "Root volume type must be gp3 or gp2."
  }
}

variable "root_volume_iops" {
  description = "IOPS for a gp3 root volume. Null uses the AWS default."
  type        = number
  default     = null
  nullable    = true
}

variable "root_volume_throughput" {
  description = "Throughput in MiB/s for a gp3 root volume. Null uses the AWS default."
  type        = number
  default     = null
  nullable    = true
}

variable "kms_key_id" {
  description = "Optional KMS key ID or ARN for EBS encryption."
  type        = string
  default     = null
}

variable "delete_root_volume_on_termination" {
  description = "Whether the root EBS volume is deleted when the instance is terminated."
  type        = bool
  default     = true
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IPv4 address."
  type        = bool
  default     = false
}

variable "monitoring" {
  description = "Enable detailed EC2 monitoring. Additional charges may apply."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Enable EC2 termination protection."
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Optional cloud-init or user-data script. Avoid passing secrets."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Additional tags to apply to the instance and root volume."
  type        = map(string)
  default     = {}
}

