resource "aws_vpc" "terra_vpc" {
  cidr_block = var.terra_subnet

  tags = {
    Name = "Terra VPC"
  }
}

resource "aws_internet_gateway" "terra_gw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "mainTerraIGW"
  }
}

resource "aws_subnet" "terra_subnets" {
  count             = length(var.terra_pub_subnets)
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = element(var.terra_pub_subnets, count.index)
  availability_zone = element(var.aws_azs, count.index)

  tags = {
    Name = "Terraform Public Subnet ${count.index + 1} - ${element(var.terra_pub_subnets, count.index)}"
  }
}

resource "aws_route_table" "terra_route_table" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_gw.id
  }
  tags = {
    Name = "Terra Default Routing Table"
    Env  = "Dev"
  }
}

resource "aws_route_table_association" "terra_route_assoc" {
  count          = length(var.terra_pub_subnets)
  subnet_id      = element(aws_subnet.terra_subnets[*].id, count.index)
  route_table_id = aws_route_table.terra_route_table.id
}