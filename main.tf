resource "aws_vpc" "main" {
cidr_block = var.vpc_cidr
instance_tenancy = "default"  
enable_dns_hostnames = true

tags = local.vpc_final_tags

}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = local.igw_final_tags
}


#public_subnet

resource "aws_subnet" "public" {
  count = length(var.public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags, {
        Name ="${var.project}-${var.env}-public ${local.az_names[count.index]}"
    }, 
    var.public_subnet_tags
  )
}

 #private_subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet[count.index]
  availability_zone = local.az_names[count.index]
  

  tags = merge(
    local.common_tags, {
        Name ="${var.project}-${var.env}-private ${local.az_names[count.index]}"
    }, 
    var.private_subnet_tags
  )
}


#db_subnet

resource "aws_subnet" "db" {
  count = length(var.db_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnet[count.index]
  availability_zone = local.az_names[count.index]
  

  tags = merge(
    local.common_tags, {
        Name ="${var.project}-${var.env}-db ${local.az_names[count.index]}"
    }, 
    var.private_subnet_tags
  )
}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
          local.common_tags , {
            Name= "${var.project}-${var.env}-public"
          },
          var.public_route_table_tags
  )
}



resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
          local.common_tags , {
            Name= "${var.project}-${var.env}-private"
          },
          var.private_route_table_tags
  )
}



resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id

  tags = merge(
          local.common_tags , {
            Name= "${var.project}-${var.env}-db"
          },
          var.private_db_tags
  )
}



resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
          local.common_tags , {
            Name= "${var.project}-${var.env}-nat"
          },
          var.eip_tags
  )
}



resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].nat.id                # we are creating in us-east -1a AZ

  tags =  merge(
          local.common_tags , {
            Name= "${var.project}-${var.env}"
          },
          var.nat_gateway_tags
  )
depends_on = [aws_internet_gateway.nat]
}




resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "db" {
  route_table_id            = aws_route_table.db
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

