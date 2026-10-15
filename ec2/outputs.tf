
output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Private IPv4 address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IPv4 address, if one is assigned."
  value       = aws_instance.this.public_ip
}

output "availability_zone" {
  description = "Availability zone of the EC2 instance."
  value       = aws_instance.this.availability_zone
}

output "root_volume_id" {
  description = "ID of the root EBS volume."
  value       = one(aws_instance.this.root_block_device).volume_id
}

