variable "prefix" {
  default = "epkbk"
}

variable "region" {
  default = "southeastasia"
  type    = string
}

variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

variable "vnet_cidr_public_sub1" {
  default = "10.0.1.0/24"
}

variable "vnet_cidr_private_sub1" {
  default = "10.0.16.0/24"
}

variable "mysqlAdmin" {}
variable "mysqlAdminPass" {}
variable "ssh_username" {
  default = "azureuser"
}
variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
