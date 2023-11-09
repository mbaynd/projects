output "priv_ip_address" {
  description = "Instance private Ip Address"
  value       = aws_instance.terraform_server[*].private_ip
}

output "pub_ip_address" {
  description = "Instance public Ip Address"
  value       = aws_instance.terraform_server[*].public_ip
}

output "jenkins_ips" {
  description = "Jenkins Servers Public IP Address"
  value       = aws_instance.jenkins_servers[*].public_ip
}