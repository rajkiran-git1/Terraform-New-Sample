  
variable "AWS_REGION" {
  default = "us-west-1, "
}

#Keypairs will be created at the time of execution
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-west-1 = "ami-000b48d2b508d571d"
    ap-southeast-1 = "ami-0a9f38b8bf7ad9bcb"
  }
}

