
# ------ Jenkins START
variable "jenkins_ingressrules" {
  type    = list(number)
  default = [8080, 22]
}

resource "aws_security_group" "jenkins_sg" {
  name        = "allow_ssh_http8080_traffic"
  description = "Allow SSH and HTTP inbound traffic on port 8080"
  vpc_id      = aws_vpc.terra_vpc.id

  dynamic "ingress" {
    iterator = port
    for_each = var.jenkins_ingressrules
    content {
      description = "Allow SSH and HTTP Traffic on port 8080"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow every instance to access Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_http8080_ssh"
    "Terraform" = "true"
  }
}

resource "aws_instance" "jenkins_servers" {
  count           = 3
  ami             = var.img
  key_name        = aws_key_pair.terra_pub_keypair.key_name
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.terra_subnets[0].id
  security_groups = [aws_security_group.jenkins_sg.id]
  #user_data       = file("./install_jenkins.sh")

  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name          = "Jenkins Server - ${count.index + 1}"
    Environnement = "ci_cd"
  }
}


resource "local_file" "jenkins_inventory" {
  filename = "inventories/jenkins_inventory"
  content  = <<-EOF
[jenkins]
%{for ip in aws_instance.jenkins_servers[*].public_ip} 
${ip}
%{endfor}

[jenkins_master]
${aws_instance.jenkins_servers[0].public_ip}
EOF
}


resource "null_resource" "jenkins_password" {
  triggers = {
    always_run = "${timestamp()}" # Forces regeneration of the file on each run
  }

  provisioner "local-exec" {
    command = <<-EOF
    ssh-keyscan ${aws_instance.jenkins_servers[0].public_ip} >> /Users/mac/.ssh/known_hosts
    ssh-keyscan ${aws_instance.jenkins_servers[1].public_ip} >> /Users/mac/.ssh/known_hosts
    ssh-keyscan ${aws_instance.jenkins_servers[2].public_ip} >> /Users/mac/.ssh/known_hosts

    ansible -i inventories/jenkins_inventory jenkins_master -m script -a "./scripts/install_jenkins.sh"
    
    JENIKINS_PASSWORD=$(ssh -l ubuntu ${aws_instance.jenkins_servers[0].public_ip} cat  /tmp/jenkins_initialAdminPassword)
    echo "Jenkins URL : http://${aws_instance.jenkins_servers[0].public_ip}:8080"
    echo "Jenkins Password: $JENIKINS_PASSWORD"
EOF
  }
}
# ------- Jenkins END