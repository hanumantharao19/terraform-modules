# ============================================================
# Cluster
# ============================================================

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "environment" {
  type        = string
  description = "Environment name such as dev, qa, or prod"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for EKS"

  default = "1.35"
}


# ============================================================
# Networking
# ============================================================

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)

  description = "Private subnet IDs for EKS cluster and worker nodes"

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnet IDs are required for EKS."
  }
}


# ============================================================
# IAM
# ============================================================

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS control plane"
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for EKS worker nodes"
}


# ============================================================
# EKS API Endpoint
# ============================================================

variable "endpoint_public_access" {
  type        = bool
  description = "Enable public access to the EKS Kubernetes API endpoint"

  default = true
}

variable "public_access_cidrs" {
  type        = list(string)

  description = "CIDR blocks allowed to access the public EKS API endpoint"

  default = [
    "0.0.0.0/0"
  ]
}


# ============================================================
# Cluster Logging
# ============================================================

variable "enabled_cluster_log_types" {
  type = list(string)

  description = "EKS control plane log types"

  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}


# ============================================================
# Worker Nodes
# ============================================================

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types for EKS worker nodes"

  default = [
    "t3.medium"
  ]
}

variable "ami_type" {
  type        = string
  description = "AMI type for EKS worker nodes"

  default = "AL2023_x86_64_STANDARD"
}

variable "capacity_type" {
  type        = string
  description = "EKS node capacity type"

  default = "ON_DEMAND"
}


# ============================================================
# Node Scaling
# ============================================================

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"

  default = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes"

  default = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"

  default = 3
}

variable "max_unavailable" {
  type        = number
  description = "Maximum number of unavailable nodes during update"

  default = 1
}

variable "disk_size" {
  type        = number
  description = "Worker node root disk size in GiB"

  default = 30
}
