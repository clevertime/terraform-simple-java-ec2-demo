# terraform-simple-ec2

## usage

1. Instantiate Module
```
# this is an example
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
```
2. `terraform apply`

3. Wait for Instance to Boot and then Connect via Systems Manager: Session Manager
![!step3](./images/step3.png)

4. Navigate to folder where artifact was downloaded and run program.
![step4](./images/step4.png)
