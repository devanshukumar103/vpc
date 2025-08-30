resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    terraform = "true"
    Name = "test"
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    terraform = "true"
    Name = "test-subnet"
  }

}
