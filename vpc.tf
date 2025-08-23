resource "aws_vpc" "myvpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    terraform = "true"
    Name = "myvpc1"
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id = aws_vpc.myvpc1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    terraform = "true"
    Name = "publicsubnet"
  }

}
