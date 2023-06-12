terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_vpc" "sbcntr_vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sbcntrVpc"
  }
}

resource "aws_subnet" "sbcntr_subnet_private_container_1a" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.8.0/24"

  availability_zone       = local.azs[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "sbcntr-subnet-private-container-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntr_subnet_private_container_1c" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.9.0/24"

  availability_zone       = local.azs[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "sbcntr-subnet-private-container-1c"
    Type = "Isolated"
  }
}

resource "aws_route_table" "sbcntr_route_app" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  tags = {
    Name = "sbcntr-route-app"
  }
}

resource "aws_route_table_association" "sbcntr_route_app_association_1a" {
  route_table_id = aws_route_table.sbcntr_route_app.id
  subnet_id      = aws_subnet.sbcntr_subnet_private_container_1a.id
}

resource "aws_route_table_association" "sbcntr_route_app_association_1c" {
  route_table_id = aws_route_table.sbcntr_route_app.id
  subnet_id      = aws_subnet.sbcntr_subnet_private_container_1c.id
}

resource "aws_subnet" "sbcntr_subnet_private_db_1a" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.16.0/24"

  availability_zone       = local.azs[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "sbcntr-subnet-private-db-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntr_subnet_private_db_1c" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.17.0/24"

  availability_zone       = local.azs[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "sbcntr-subnet-private-db-1c"
    Type = "Isolated"
  }
}

resource "aws_route_table" "sbcntr_route_db" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  tags = {
    Name = "sbcntr-route-db"
  }
}

resource "aws_route_table_association" "sbcntr_route_db_association_1a" {
  route_table_id = aws_route_table.sbcntr_route_db.id
  subnet_id      = aws_subnet.sbcntr_subnet_private_db_1a.id
}

resource "aws_route_table_association" "sbcntr_route_db_association_1c" {
  route_table_id = aws_route_table.sbcntr_route_db.id
  subnet_id      = aws_subnet.sbcntr_subnet_private_db_1c.id
}

resource "aws_subnet" "sbcntr_subnet_public_ingress_1a" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.0.0/24"

  availability_zone       = local.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "sbcntr-subnet-public-ingress-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "sbcntr_subnet_public_ingress_1c" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone       = local.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "sbcntr-subnet-public-ingress-1c"
    Type = "Public"
  }
}

resource "aws_route_table" "sbcntr_route_ingress" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  tags = {
    Name = "sbcntr-route-ingress"
  }
}

resource "aws_route_table_association" "sbcntr_route_ingress_association_1a" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id      = aws_subnet.sbcntr_subnet_public_ingress_1a.id
}

resource "aws_route_table_association" "sbcntr_route_ingress_association_1c" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id      = aws_subnet.sbcntr_subnet_public_ingress_1c.id
}

resource "aws_route" "sbcntr_route_ingress_default" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.sbcntr_igw.id

  depends_on = [aws_internet_gateway.sbcntr_igw]
}

resource "aws_subnet" "sbcntr_subnet_public_management_1a" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.240.0/24"

  availability_zone       = local.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "sbcntr-subnet-public-management-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "sbcntr_subnet_public_management_1c" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  cidr_block = "10.0.241.0/24"

  availability_zone       = local.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "sbcntr-subnet-public-management-1c"
    Type = "Public"
  }
}

resource "aws_route_table_association" "sbcntr_route_ingress_management_association_1a" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id      = aws_subnet.sbcntr_subnet_public_management_1a.id
}

resource "aws_route_table_association" "sbcntr_route_ingress_management_association_1c" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id      = aws_subnet.sbcntr_subnet_public_management_1c.id
}

resource "aws_internet_gateway" "sbcntr_igw" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-igw"
  }
}

resource "aws_security_group" "sbcntr_sg_ingress" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-ingress"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_ingress_egress" {
  security_group_id = aws_security_group.sbcntr_sg_ingress.id

  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips
  type        = "egress"
}

resource "aws_security_group_rule" "sbcntr_sg_ingress_ingress" {
  security_group_id = aws_security_group.sbcntr_sg_ingress.id

  from_port        = local.http_port
  to_port          = local.http_port
  protocol         = local.tcp_protocol
  cidr_blocks      = local.all_ips
  ipv6_cidr_blocks = local.all_ipv6s
  type             = "ingress"
}

resource "aws_security_group" "sbcntr_sg_management" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-management"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_management_egress" {
  security_group_id = aws_security_group.sbcntr_sg_management.id

  cidr_blocks = local.all_ips
  to_port     = local.any_port
  from_port   = local.any_port
  protocol    = local.any_protocol

  type = "egress"
}

resource "aws_security_group" "sbcntr_sg_container" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-container"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_container_egress" {
  security_group_id = aws_security_group.sbcntr_sg_container.id

  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips

  type = "egress"
}

resource "aws_security_group" "sbcntr_sg_front_container" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-front-container"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_front_container_egress" {
  security_group_id = aws_security_group.sbcntr_sg_front_container.id

  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips

  type = "egress"
}

resource "aws_security_group" "sbcntr_sg_internal" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-internal"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_internal_egress" {
  security_group_id = aws_security_group.sbcntr_sg_internal.id

  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips

  type = "egress"
}

resource "aws_security_group" "sbcntr_sg_db" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-db"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_db_egress" {
  security_group_id = aws_security_group.sbcntr_sg_db.id

  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips

  type = "egress"
}

resource "aws_security_group_rule" "sbcntr_sg_front_container_froms_sg_ingress" {
  security_group_id        = aws_security_group.sbcntr_sg_front_container.id
  source_security_group_id = aws_security_group.sbcntr_sg_ingress.id

  from_port = local.http_port
  protocol  = local.tcp_protocol
  to_port   = local.http_port

  type = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_internal_from_sg_front_container" {
  security_group_id        = aws_security_group.sbcntr_sg_internal.id
  source_security_group_id = aws_security_group.sbcntr_sg_front_container.id

  from_port = local.http_port
  protocol  = local.tcp_protocol
  to_port   = local.http_port

  type = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_container_from_sg_internal" {
  security_group_id        = aws_security_group.sbcntr_sg_container.id
  source_security_group_id = aws_security_group.sbcntr_sg_internal.id

  from_port = local.http_port
  protocol  = local.tcp_protocol
  to_port   = local.http_port

  type = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_db_from_sg_container_TCP" {
  security_group_id        = aws_security_group.sbcntr_sg_db.id
  source_security_group_id = aws_security_group.sbcntr_sg_container.id

  from_port = local.mysql_port
  protocol  = local.tcp_protocol
  to_port   = local.mysql_port

  type = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_db_from_sg_front_container_TCP" {
  security_group_id        = aws_security_group.sbcntr_sg_db.id
  source_security_group_id = aws_security_group.sbcntr_sg_front_container.id

  from_port = local.mysql_port
  protocol  = local.tcp_protocol
  to_port   = local.mysql_port

  type = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_db_from_sg_management_TCP" {
  security_group_id        = aws_security_group.sbcntr_sg_db.id
  source_security_group_id = aws_security_group.sbcntr_sg_management.id

  from_port = local.mysql_port
  protocol  = local.tcp_protocol
  to_port   = local.mysql_port

  type = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_internal_from_sg_management_TCP" {
  security_group_id        = aws_security_group.sbcntr_sg_internal.id
  source_security_group_id = aws_security_group.sbcntr_sg_management.id

  from_port = local.http_port
  protocol  = local.tcp_protocol
  to_port   = local.http_port

  type = "ingress"
}

resource "aws_subnet" "sbcntr_subnet_private_egress_1a" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  availability_zone       = local.azs[0]
  map_public_ip_on_launch = false
  cidr_block              = "10.0.248.0/24"

  tags = {
    Name = "sbcntr-subnet-private-egress-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "sbcntr_subnet_private_egress_1c" {
  vpc_id = aws_vpc.sbcntr_vpc.id

  availability_zone       = local.azs[1]
  map_public_ip_on_launch = false
  cidr_block              = "10.0.249.0/24"

  tags = {
    Name = "sbcntr-subnet-private-egress-1c"
    Type = "Isolated"
  }
}

resource "aws_security_group" "sbcntr_sg_egress" {
  vpc_id = aws_vpc.sbcntr_vpc.id
  tags = {
    Name = "sbcntr-sg-vpce"
  }
}

resource "aws_security_group_rule" "sbcntr_sg_egress_egress" {
  security_group_id = aws_security_group.sbcntr_sg_egress.id

  from_port   = local.any_port
  protocol    = local.any_protocol
  to_port     = local.any_port
  cidr_blocks = local.all_ips

  type = "egress"
}

resource "aws_security_group_rule" "sbcntr_sg_vpce_from_sg_container_TCP" {
  security_group_id = aws_security_group.sbcntr_sg_egress.id
  source_security_group_id = aws_security_group.sbcntr_sg_container.id

  from_port         = local.https_port
  protocol          = local.tcp_protocol
  to_port           = local.https_port

  type              = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_vpce_from_sg_front_container_TCP" {
  security_group_id = aws_security_group.sbcntr_sg_egress.id
  source_security_group_id = aws_security_group.sbcntr_sg_front_container.id

  from_port         = local.https_port
  protocol          = local.tcp_protocol
  to_port           = local.https_port

  type              = "ingress"
}

resource "aws_security_group_rule" "sbcntr_sg_vpce_from_sg_management_TCP" {
  security_group_id = aws_security_group.sbcntr_sg_egress.id
  source_security_group_id = aws_security_group.sbcntr_sg_management.id

  from_port         = local.https_port
  protocol          = local.tcp_protocol
  to_port           = local.https_port

  type              = "ingress"
}