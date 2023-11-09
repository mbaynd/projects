data "template_file" "ansible_inventory" {
  template = <<EOF
# Ansible Inventory
[all]
%{for instance in aws_instance.terraform_server[*].public_ip}
${instance} 
%{endfor}

[all:vars]
ansible_ssh_user= "ubuntu"
EOF

  vars = {
    #aws_instance.terraform_servers = "${aws_instance.terraform_server[*].public_ip}"
    #server_ssh_user   = "ubuntu"
  }
}