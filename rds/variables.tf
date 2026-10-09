variable "name" {
  type        = string
  description = "RDS instance identifier"
}

variable "environment" {
  type        = string
  description = "Environment name such as dev, qa, or prod"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the RDS subnet group"

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two private subnet IDs are required."
  }
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups allowed to connect to PostgreSQL"
}

variable "engine_version" {
  type        = string
  default     = "17"
  description = "PostgreSQL engine version"
}

variable "instance_class" {
  type        = string
  default     = "db.r6g.large"
  description = "RDS instance class"
}

variable "allocated_storage" {
  type        = number
  default     = 100
  description = "Initial storage in GiB"
}

variable "max_allocated_storage" {
  type        = number
  default     = 500
  description = "Maximum storage in GiB for autoscaling"
}

variable "db_name" {
  type        = string
  description = "Initial PostgreSQL database name"
}

variable "username" {
  type        = string
  default     = "postgres"
  description = "Master username"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ deployment"
}

variable "backup_retention_period" {
  type        = number
  default     = 30
  description = "Automated backup retention in days"
}

variable "backup_window" {
  type        = string
  default     = "03:00-04:00"
  description = "Daily backup window in UTC"
}

variable "maintenance_window" {
  type        = string
  default     = "sun:04:00-sun:05:00"
  description = "Weekly maintenance window in UTC"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Prevent accidental deletion of production RDS"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Create a final snapshot when RDS is destroyed"
}

variable "monitoring_interval" {
  type        = number
  default     = 0
  description = "Enhanced monitoring interval in seconds. 0 disables Enhanced Monitoring."
}
variable "performance_insights_enabled" {
  type        = bool
  default     = true
  description = "Enable Performance Insights"
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "Performance Insights retention period"
}