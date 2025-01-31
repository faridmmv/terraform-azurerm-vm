resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet

}

resource "azurerm_public_ip" "this" {
  count               = var.count
  name                = "pip-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    var.tags,
    {
      purpose   = "vm"
      ManagedBy = "terraform"
    }
  )
}

resource "azurerm_network_security_group" "this" {
  name                = "vm"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = ["0.0.0.0/0"]
    destination_address_prefix = "*"
  }

  tags = merge(
    var.tags,
    {
      purpose   = "vm"
      ManagedBy = "terraform"
    }
  )

}

resource "azurerm_network_interface" "this" {
  count               = var.count
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "vm"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[count.index].id
  }

  tags = merge(
    var.tags,
    {
      purpose   = "vm"
      ManagedBy = "terraform"
    }
  )

}

resource "azurerm_network_interface_security_group_association" "this" {
  count                     = var.count
  network_interface_id      = azurerm_network_interface.this[count.index].id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_linux_virtual_machine" "this" {
  count                 = var.count
  name                  = "vm-${count.index}"
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.this[count.index].id]
  size                  = "Standard_B2ms"

  os_disk {
    name                 = "vm"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "vm"
  admin_username                  = "sysadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sysadmin"
    public_key = var.public_key
  }

  tags = merge(
    var.tags,
    {
      purpose   = "vm"
      ManagedBy = "terraform"
    }
  )

}