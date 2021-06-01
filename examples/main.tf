provider "aws" {
  region  = "us-west-2"
  profile = "malachi"
}

module "ec2" {
  source    = "./terraform-svb-ec2"
  name      = "c4ep-2656"
  vpc_id    = "vpc-7bcea503"
  subnet_id = "subnet-5a68bf07"
}
