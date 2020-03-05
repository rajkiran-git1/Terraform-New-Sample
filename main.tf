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
  vpc_id = "vpc_main.id"
}


module "security_group" {
  source  = "../../../modules/network/securitygroup"
  name        = "ECP-APP Security Group"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "vpc_main.id"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}
  
  #resource "aws_key_pair" "generated_key" {
#  key_name   = var.key_name
#  public_key = tls_private_key.sshkey.public_key_openssh
  
  module "ec2-app-instance" {
  source = "../../../modules/compute/ec2"
  instance_count              = "5"
  name                        = "App-Compoents-name"
  ami                         = var.ami
  instance_type               = "m5.2xlarge"
  #security_groups	          = aws_subnet.main-public-1.id
    
  #availability_zone	      = element(var.availability_zone, count.index)
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[1]
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
#  key_name                    = aws_key_pair.generated_key.key_name
   key_name		      = var.key_name
#  subnet_id                   = element(var.subnet_id, 1)
  tenancy		      = var.tenancy
  user_data = <<-EOF
                #! /bin/bash
                sudo mkdir /apps
                sudo mkfs -t ext4 /dev/xvdf
                sudo mount /dev/xvdf /apps
                sudo echo "/dev/xvdf   /apps  ext4 defaults,nofail 0 2" >> /etc/fstab
  EOF
  
  tags = {
    App-Name    = "Application-name"
    Compoents   = "Compoent-name"
    Environment = "UAT"
        
   }
