# ============================================================
# EKS Security Group
# ============================================================

resource "aws_security_group" "eks" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for EKS cluster and worker nodes"
  vpc_id      = var.vpc_id

  # ----------------------------------------------------------
  # Node-to-node communication
  # ----------------------------------------------------------

 ingress {
  description = "Allow node-to-node communication"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  self        = true
}

  # ----------------------------------------------------------
  # Kubernetes API access
  # ----------------------------------------------------------

  ingress {
    description = "Allow Kubernetes API access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.public_access_cidrs
  }

  # ----------------------------------------------------------
  # Outbound traffic
  # ----------------------------------------------------------

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# EKS Cluster
# ============================================================

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = var.private_subnet_ids

    security_group_ids = [
      aws_security_group.eks.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# EKS Managed Node Group
# ============================================================

resource "aws_eks_node_group" "this" {
  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${var.cluster_name}-node-group"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  capacity_type  = var.capacity_type
  instance_types = var.instance_types
  ami_type       = var.ami_type
  disk_size      = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  labels = {
    Environment = var.environment
  }

  tags = {
    Name        = "${var.cluster_name}-node-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}


# ============================================================
# VPC CNI Add-on
# ============================================================

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "vpc-cni"

  resolve_conflicts_on_update = "PRESERVE"

  tags = {
    Name        = "${var.cluster_name}-vpc-cni"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# CoreDNS Add-on
# ============================================================

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "coredns"

  resolve_conflicts_on_update = "PRESERVE"

  tags = {
    Name        = "${var.cluster_name}-coredns"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ============================================================
# Kube Proxy Add-on
# ============================================================

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "kube-proxy"

  resolve_conflicts_on_update = "PRESERVE"

  tags = {
    Name        = "${var.cluster_name}-kube-proxy"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}