data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Setup
resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR_BLOCK
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  #enable_classiclink  = "false"
  tags = {
    Name = "${var.RESOURCE_TAG}-VPC"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.AZ_COUNT
  cidr_block        	    = "${cidrsubnet(aws_vpc.vpc.cidr_block, var.SUBNET_CIDR_BITS, count.index)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "${var.RESOURCE_TAG}.public.${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  count            	      = var.AZ_COUNT
  cidr_block     	        = "${cidrsubnet(aws_vpc.vpc.cidr_block, var.SUBNET_CIDR_BITS, count.index + length(aws_subnet.public.*.id))}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "${var.RESOURCE_TAG}.private.${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.RESOURCE_TAG}-IGW"
  }
  depends_on = [aws_vpc.vpc]
}

# NAT GW
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.RESOURCE_TAG}-NAT"
  }
  depends_on = [aws_vpc.vpc]
}

#Elastic IP for NAT
resource "aws_eip" "nat-eip" {
  vpc 	= true
  tags = {
    Name = "${var.RESOURCE_TAG}-NGW-IP"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.RESOURCE_TAG}-Public-RT"
  }
}
# Route Table for Private Subnets
resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.RESOURCE_TAG}-Private-RT"
  }
}

#Route for Private Route Table
resource "aws_route" "private-route" {
  route_table_id         =  aws_route_table.rt-private.id
  destination_cidr_block =  "0.0.0.0/0"
  nat_gateway_id         =  aws_nat_gateway.nat-gw.id
  depends_on             = [aws_route_table.rt-private]
}

# Route Associations Public
resource "aws_route_table_association" "rta-public-1" {
  count          = var.AZ_COUNT
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = aws_route_table.rt-public.id
}

# Route Associations Private
resource "aws_route_table_association" "rta-private-1" {
  count            =  var.AZ_COUNT
  subnet_id        = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id   = aws_route_table.rt-private.id
}

