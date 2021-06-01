provider "aws" {
  region  = "us-west-2"
  profile = "malachi"
}

module "ec2" {
  source    = "./terraform-svb-ec2"
  name      = "c4ep-2656"
  vpc_id    = "vpc-7bcea503"
  subnet_id = "subnet-5a68bf07"
  key_name  = aws_key_pair.this.key_name

  security_group_cidr_ingress_rules = [
    {
      to_port = 22
      from_port = 22
      protocol = "tcp"
      cidr_blocks = ["172.91.8.230/32"]
      description = "lucas ssh"
    }
  ]
}

resource "aws_key_pair" "this" {
  key_name   = "c4ep-2656"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhiSUYCmRfHicR644Z88X9F75omD4cw2FP+mmv/tzEEppqq3XQxvF0b1sv+iQw6L9x8BrlpaVKk9VmLIjUNoj7W5s0k7g7xj5GbauFpE+8X3kyeB3WooAUCwE7y3P7otBvDgnkDIfeuhZYVaUEbRQM5tOkI7GDw4+npGc40td8FkdCgtjOljGvWaOY8U835GY7pEftD/Q4SnBFNxRBngeexg1zW4qTp5e4RCvv5EdRlIrTkI+iLVVSmtySSm6Sx+/6OGkpr9uwxpcxox8oWvQcZ59W+aWHO1+wRMOrSyJfpKiZ/rp2zVhk42ej4E3cnmgBSU8DmwmpVug4Qc36VbMH c4ep-2656"
}
