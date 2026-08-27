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

resource "aws_subnet" "main" {
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