
resource "aws_key_pair" "terra_pub_keypair" {
  key_name   = "terraform_ssh_key"
  public_key = var.ssh_pub_key
}
