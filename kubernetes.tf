resource "aws_instance" "k8s_ec2" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t2.micro"  # free-tier eligible
  key_name      = "deva"      # replace with your key pair name
  subnet_id     = aws_subnet.public_01.id

  tags = {
    Name = "k8s-single-node"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update system
    apt-get update -y
    apt-get upgrade -y

    # Disable swap (Kubernetes requirement)
    swapoff -a
    sed -i '/ swap / s/^/#/' /etc/fstab

    # Install container runtime (containerd)
    apt-get install -y apt-transport-https ca-certificates curl gpg
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y containerd.io

    # Configure containerd and enable
    mkdir -p /etc/containerd
    containerd config default | tee /etc/containerd/config.toml
    systemctl restart containerd
    systemctl enable containerd

    # Load required kernel modules
    cat <<EOF1 | tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF1

    modprobe overlay
    modprobe br_netfilter

    # Set sysctl params required by Kubernetes
    cat <<EOF2 | tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
    EOF2

    sysctl --system

    # Install Kubernetes components
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update -y
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl

    # Initialize Kubernetes master node (single-node cluster)
    kubeadm init --pod-network-cidr=10.244.0.0/16

    # Set up kubeconfig for ubuntu user
    mkdir -p /home/ubuntu/.kube
    cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
    chown ubuntu:ubuntu /home/ubuntu/.kube/config

    # Apply Flannel CNI
    su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

    # Allow scheduling pods on the control-plane node (make it master + worker)
    su - ubuntu -c "kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true"

    # Enable kubelet service
    systemctl enable kubelet
    systemctl start kubelet
  EOF

  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
}

# Security group
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-ec2-sg"
  description = "Allow SSH and Kubernetes traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Kubernetes API server
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Kubelet API
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "Public IP of the Kubernetes EC2 instance"
  value       = aws_instance.k8s_ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the Kubernetes EC2 instance"
  value       = aws_instance.k8s_ec2.public_dns
}