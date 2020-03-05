provider "aws" {
  region = var.AWS_REGION
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "vpc-075ce6610f7774b07	"
}


module "security_group" {
  source  = "../../../modules/network/securitygroup"
  name        = "ECP-APP Security Group"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "vpc-075ce6610f7774b07"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}
  
  #resource "aws_key_pair" "generated_key" {
#  key_name   = var.key_name
#  public_key = tls_private_key.sshkey.public_key_openssh
  
  
