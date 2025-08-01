#-----------------------------------------------
#               VPC
#-----------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block[lower(var.environment)]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-igw"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#-----------------------------------------------
#               Private subnet
#-----------------------------------------------

// sb : Subnet
resource "aws_subnet" "private" {
  cidr_block        = var.subnet_cidr_block[lower(var.environment)].private
  availability_zone = "ap-southeast-1a"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-sb-private"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

// name of the resource = resource tag name
resource "aws_security_group" "securitygroup_for_endpoints" {
  name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-sg-ep"
  description = "For Private endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-sec-ep"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}


// name of the resource = resource tag name
// This can be removed later
resource "aws_security_group" "sg_ep" {
  name        = "sec-ep-${lower(var.projectname)}-${lower(var.environment)}"
  description = "For Private endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "sec-ep-${lower(var.projectname)}-${lower(var.environment)}"
    Environment = "${lower(var.environment)}"
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

// ep : EndPoint
resource "aws_vpc_endpoint" "ecr_api" {
  depends_on = [
    aws_security_group.securitygroup_for_endpoints
  ]
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-southeast-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.securitygroup_for_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-ep-ecr-api"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  depends_on = [
    aws_security_group.securitygroup_for_endpoints
  ]
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-southeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.securitygroup_for_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-ep-ecr-dkr"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_vpc_endpoint" "ecr_secretmanager" {
  depends_on = [
    aws_security_group.securitygroup_for_endpoints
  ]
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-southeast-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.securitygroup_for_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-ep-secretsmanager"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_vpc_endpoint" "ecr_s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-southeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.main.main_route_table_id]

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-ep-s3"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-southeast-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.main.main_route_table_id]

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-ep-dynamodb"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

#-----------------------------------------------
#               NAT private -> public -> internet
#-----------------------------------------------

resource "aws_eip" "nat_gateway" {
  vpc = true
  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-eip"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-nat"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

// rt : Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-rt-private"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


#-----------------------------------------------
#               Public subnet
#-----------------------------------------------

resource "aws_subnet" "public_a" {
  cidr_block        = var.subnet_cidr_block[lower(var.environment)].public_a
  availability_zone = "ap-southeast-1a"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-public-a"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_vpc.main.main_route_table_id
}

resource "aws_subnet" "public_b" {
  cidr_block        = var.subnet_cidr_block[lower(var.environment)].public_b
  availability_zone = "ap-southeast-1b"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name        = "${lower(var.projectname)}-${lower(var.environment)}-${lower(var.region)}-public-b"
    Environment = lower(var.environment)
    Project     = var.projectname
    CostCenter  = var.costcenter
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_vpc.main.main_route_table_id
}
