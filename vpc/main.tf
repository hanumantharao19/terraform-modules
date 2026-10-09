# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}


# ============================================================
# Internet Gateway
# ============================================================

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


# ============================================================
# Public Subnets
# ============================================================

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-${each.key}"
    Tier = "public"
  }
}


# ============================================================
# Private Subnets
# ============================================================

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-${each.key}"
    Tier = "private"
  }
}


# ============================================================
# Public Route Table
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
    Tier = "public"
  }
}


# ============================================================
# Public Internet Route
# ============================================================

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}


# ============================================================
# Public Route Table Associations
# ============================================================

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}


# ============================================================
# NAT Gateway Elastic IPs
# ============================================================

locals {
  nat_subnets = var.enable_nat_gateway ? (
    var.single_nat_gateway
    ? {
        (keys(var.public_subnets)[0]) = var.public_subnets[keys(var.public_subnets)[0]]
      }
    : var.public_subnets
  ) : {}
}


resource "aws_eip" "nat" {
  for_each = local.nat_subnets

  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-${each.key}-nat-eip"
  }
}


# ============================================================
# NAT Gateways
# ============================================================

resource "aws_nat_gateway" "this" {
  for_each = local.nat_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "${var.vpc_name}-${each.key}-nat"
  }
}


# ============================================================
# Private Route Tables
# ============================================================

resource "aws_route_table" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-${each.key}-private-rt"
    Tier = "private"
  }
}


# ============================================================
# Private Routes
# ============================================================

resource "aws_route" "private_nat" {
  for_each = var.enable_nat_gateway ? var.private_subnets : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = var.single_nat_gateway ? (
    aws_nat_gateway.this[keys(var.public_subnets)[0]].id
  ) : (
    aws_nat_gateway.this[each.value.nat_key].id
  )
}

# ============================================================
# Private Route Table Associations
# ============================================================

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
