
resource "aws_security_group" "allow_http" {
  name        = "allow_ssh_http_traffic"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.terra_vpc.id

  ingress {
    description = "Allow HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow every instance to access Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}


resource "aws_instance" "terraform_server" {
  count                       = var.number_of_instances
  ami                         = var.img
  instance_type               = var.instance_type
  subnet_id                   = element(aws_subnet.terra_subnets[*].id, count.index)
  security_groups             = ["${aws_security_group.allow_http.id}"]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.terra_pub_keypair.key_name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }
  tags = {
    Name          = var.tags[count.index]
    Environnement = "dev"
  }

  # Set prevent_destroy to true for the instances
  lifecycle {
    prevent_destroy = false
  }
}


resource "time_sleep" "wait_120_seconds" {
  create_duration = "120s"
}

resource "null_resource" "output" {
  triggers = {
    always_run = "${timestamp()}" # Forces regeneration of the file on each run
  }
  #depends_on = [ time_sleep.wait_120_seconds ]

  provisioner "local-exec" {
    command = <<EOF
echo "${data.template_file.ansible_inventory.rendered}" > inventories/ansible_inventory
#sleep 120
#export ANSIBLE_HOST_KEY_CHECKING=False
#ansible-playbook -i ansible_inventory ansible/deployment.yml 
EOF
  }
}