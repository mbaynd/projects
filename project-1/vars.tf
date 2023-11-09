variable "region" {
  description = "Default Region for AWS"
  type        = string
  default     = "us-west-2"
}

variable "number_of_instances" {
  default = 1
}

variable "terra_subnet" {
  default = "10.14.0.0/16"
}

variable "aws_azs" {
  type        = list(string)
  description = "AWS Availability Zones"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "terra_pub_subnets" {
  type        = list(string)
  description = "List des public subnets"
  default     = ["10.14.1.0/24", "10.14.2.0/24", "10.14.3.0/24"]
}

variable "terra_subnet_1" {
  default = "10.14.1.0/24"
}

variable "terra_subnet_2" {
  default = "10.14.2.0/24"
}

variable "terra_subnet_3" {
  default = "10.14.3.0/24"
}

variable "img" {
  description = "Ubuntu 22.04 LTS image AMI"
  default     = "ami-0efcece6bed30fd98"
  type        = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {
  type    = list(string)
  default = ["TerraformServer-1", "TerraformServer-2", "TerraformServer-3", "TerraformServer-4", "TerraformServer-5"]
}

variable "ssh_pub_key" {
  type        = string
  description = "Ansible Deployer Public Key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxy0WDcvNlFpLyc0NKdUTfauqjU6QH2xn0hUNWB52tfh3Nlj6cbFKqiYT/TlMfF6++cMDhPIc979Hnad4r8V/VgVYVpeYEO1CWGtCNPl9eqVfjRtykdsubiOjPChOD5MlFKEv8zvjBiCW41WCxkyQSlyy5jgMOsO/AdyeK8Tcs3WkYmE80NjiQzapz63wPoUDXOTxyNSN3aH60Gp6m/X73FNX//OeMm1ckRv+icXmZ66RqvW9T1Dwyx5DpKDeQeHd/N3iX4W+NUGxOEtEo6uzEkUCUt+l7Qqtvw0Vg3x7vz98mNOt+/bCZa2Zz3UsjEnbPTnlY0B41drA9T7TkYENt"
}

variable "terra_priv_ssh_key" {
  type        = string
  description = "SSH ID RSA private  key"
  default     = "/Users/mac/.ssh/id_rsa"
}