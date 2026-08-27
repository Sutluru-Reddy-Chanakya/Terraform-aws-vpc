locals {
  common_tags = {
    project = var.project 
    env = var.env 
    Terraform = "true"
  }
  vpc_final_tags = merge(
        local.common_tags , {
            Name = "${var.project}-${var.env}"
        },
        var.vpc_tags
    )
 igw_final_tags =merge(
        local.common_tags , {
            Name = "${var.project}-${var.env}"
        },
        var.igw_tags
 ) 
 az_names = slice(data.aws_availability_zones.available.names, 0,2)
 
}