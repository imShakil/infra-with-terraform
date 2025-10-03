variable "resource_group" {
    type = string
    description = "Resource Group where the log analytics workspace will be placed"
    default = "tf-rg"  
}

variable "region" {
  type = string
  description = "Region"
  default = "southeastasia"
}
