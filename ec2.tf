# Read remote state from the network project
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "deva-tfstate"
    key    = "network/state.tfstate"
    region = "us-east-1"
  }
}
#
# Example: Create an EC2 instance in that VPC
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  subnet_id = element(data.terraform_remote_state.network.outputs.public_subnet, 0)

  tags = {
    Name = "example-instance"
  }
}
####