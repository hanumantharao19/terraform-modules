output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "Map of public subnet names to subnet IDs"
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "public_subnet_cidrs" {
  description = "Map of public subnet names to CIDRs"
  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.cidr_block
  }
}

output "private_subnet_cidrs" {
  description = "Map of private subnet names to CIDRs"
  value = {
    for key, subnet in aws_subnet.private :
    key => subnet.cidr_block
  }
}

output "nat_gateway_ids" {
  description = "Map of NAT Gateway names to IDs"
  value = {
    for key, nat in aws_nat_gateway.this :
    key => nat.id
  }
}

output "nat_eips" {
  description = "Map of NAT Gateway names to public IPs"
  value = {
    for key, eip in aws_eip.nat :
    key => eip.public_ip
  }
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Map of private route table names to IDs"
  value = {
    for key, rt in aws_route_table.private :
    key => rt.id
  }
}
