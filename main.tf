  # Get list of availability zones
data "aws_availability_zones" "available" {
state = "available"
        }

provider "aws" {
        region = var.region
    }
terraform {
  required_version = ">= 1.1.9"
  }
        
# Create VPC
resource "aws_vpc" "PRJ16-vpc" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
}

# Create public subnets1
resource "aws_subnet" "public" {
  count                      = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  vpc_id                     = aws_vpc.PRJ16-vpc.id
  cidr_block                 = cidrsubnet("172.16.0.0/16", 8, count.index)
  map_public_ip_on_launch    = true
  availability_zone          = data.aws_availability_zones.available.names[count.index]
    

}
