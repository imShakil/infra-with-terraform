resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.prefix}-vm-public-ip"
  location            = var.region
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.prefix}-vm-nic"
  location            = var.region
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}-vm"
  location            = var.region
  resource_group_name = var.resource_group
  size                = "Standard_B1s"
  admin_username      = var.ssh_username

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = var.ssh_username
    public_key = file(var.ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.root}/scripts/epkbk-deploy.sh", {
    SSH_USER = var.ssh_username,
    DB_HOST = var.db_hostname,
    DB_USER = var.mysqlAdmin,
    DB_PASSWORD = var.mysqlAdminPass,
    DB_NAME = "bookstore"
  }))
}
