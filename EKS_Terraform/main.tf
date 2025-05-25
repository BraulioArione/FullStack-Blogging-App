provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "devopsshack_rg" {
  name     = "devopsshack-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "devopsshack_vnet" {
  name                = "devopsshack-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.devopsshack_rg.location
  resource_group_name = azurerm_resource_group.devopsshack_rg.name
}

resource "azurerm_subnet" "devopsshack_subnet" {
  count               = 2
  name                = "subnet-${count.index}"
  resource_group_name = azurerm_resource_group.devopsshack_rg.name
  virtual_network_name = azurerm_virtual_network.devopsshack_vnet.name
  address_prefixes    = ["10.0.${count.index}.0/24"]
}

resource "azurerm_network_security_group" "devopsshack_nsg" {
  name                = "devopsshack-nsg"
  location            = azurerm_resource_group.devopsshack_rg.location
  resource_group_name = azurerm_resource_group.devopsshack_rg.name

  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_kubernetes_cluster" "devopsshack_aks" {
  name                = "devopsshack-aks"
  location            = azurerm_resource_group.devopsshack_rg.location
  resource_group_name = azurerm_resource_group.devopsshack_rg.name
  dns_prefix          = "devopsshack"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.devopsshack_subnet[0].id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "DevOpsHack"
  }
}
