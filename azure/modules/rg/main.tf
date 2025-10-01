
provider "azurerm" {

    features {
    }

}

resource "azurerm_resource_group" "tf-rg" {
    name = "tf-rg"
    location = "southeastasia"
    tags = {
        "rg" = "tf"
    }
}

output "rg-name" {
    value = azurerm_resource_group.tf-rg.name
}
