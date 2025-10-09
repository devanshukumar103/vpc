# resource "aws_instance" "docker_ec2" {
#   ami           = "ami-0360c520857e3138f"
#   instance_type = "t2.micro"  # free-tier eligible
#   key_name      = "deva"  # replace with your key pair name

#   tags = {
#     Name = "docker-instance"
#   }

#   user_data = <<-EOF
#     #!/bin/bash
#     # Update packages
#     sudo apt-get update -y

#     # Install prerequisites
#     sudo apt-get install -y ca-certificates curl gnupg lsb-release

#     # Add Docker’s official GPG key
#     sudo mkdir -p /etc/apt/keyrings
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#     # Set up Docker repository
#     echo \
#       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
#       https://download.docker.com/linux/ubuntu \
#       $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#     # Install Docker Engine
#     sudo apt-get update -y
#     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#     # Start and enable Docker
#     sudo systemctl start docker
#     sudo systemctl enable docker

#     # Allow ubuntu user to use docker without sudo
#     sudo usermod -aG docker ubuntu
#   EOF

#   # Security group to allow SSH and HTTP (optional)
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]
# }

# # Create a security group
# resource "aws_security_group" "ec2_sg" {
#   name        = "docker-ec2-sg"
#   description = "Allow SSH and HTTP access"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = aws_instance.docker_ec2.public_ip
# }

# output "instance_public_dns" {
#   description = "Public DNS of the EC2 instance"
#   value       = aws_instance.docker_ec2.public_dns
# }
