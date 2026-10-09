output "cluster_security_group_id" {
  description = "EKS cluster and worker node security group ID"
  value       = aws_security_group.eks.id
}

output "node_security_group_id" {
  description = "EKS cluster and worker node security group ID"
  value       = aws_security_group.eks.id
}
