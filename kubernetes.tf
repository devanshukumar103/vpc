# Fetch existing subnet
data "aws_subnet" "public_01" {
  filter {
    name   = "tag:Name"
    values = ["public-01"]
  }
}

# Fetch existing security group
data "aws_security_group" "public_sg" {
  filter {
    name   = "group-name"
    values = ["public-sg"]
  }
}

resource "aws_instance" "k8s_ec2" {
  ami           = "ami-0360c520857e3138f"
  instance_type = "t2.micro"  # free-tier eligible
  key_name      = "deva"
  subnet_id     = data.aws_subnet.public_01.id
  vpc_security_group_ids = [data.aws_security_group.public_sg.id]

  tags = {
    Name = "k8s-single-node"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get upgrade -y
    swapoff -a
    sed -i '/ swap / s/^/#/' /etc/fstab
    apt-get install -y apt-transport-https ca-certificates curl gpg
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y containerd.io
    mkdir -p /etc/containerd
    containerd config default | tee /etc/containerd/config.toml
    systemctl restart containerd
    systemctl enable containerd
    cat <<EOF1 | tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF1
    modprobe overlay
    modprobe br_netfilter
    cat <<EOF2 | tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
    EOF2
    sysctl --system
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update -y
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl
    kubeadm init --pod-network-cidr=10.244.0.0/16
    mkdir -p /home/ubuntu/.kube
    cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
    chown ubuntu:ubuntu /home/ubuntu/.kube/config
    su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
    su - ubuntu -c "kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true"
    systemctl enable kubelet
    systemctl start kubelet
  EOF
}

output "instance_public_ip" {
  description = "Public IP of the Kubernetes EC2 instance"
  value       = aws_instance.k8s_ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the Kubernetes EC2 instance"
  value       = aws_instance.k8s_ec2.public_dns
}

