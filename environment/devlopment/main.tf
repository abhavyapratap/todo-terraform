#Hello this is bhavya pratap singh i am pursuing BCA....

module "rg" {
  source   = "../../modules/azurerm_resource_group"
  rg_name  = "rg-technologia"
  location = "centralindia"
}

module "rg1" {
  source   = "../../modules/azurerm_resource_group"
  rg_name  = "rg-technologia1"
  location = "centralindia"
}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_vnet"
  vnet_name           = "V-Net"
  location            = "centralindia"
  resource_group_name = "rg-technologia"
  address_space       = ["10.70.0.0/16"]
}


module "subnet" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  subnet_name          = "frontend-subnet"
  resource_group_name  = "rg-technologia"
  virtual_network_name = "V-Net"
  address_prefixes     = ["10.70.0.0/24"]
}

module "subnet1" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  subnet_name          = "backend-subnet"
  resource_group_name  = "rg-technologia"
  virtual_network_name = "V-Net"
  address_prefixes     = ["10.70.1.0/24"]
}

module "public_ip" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_public_ip"
  publicip_name       = "frontend-Public_IP"
  resource_group_name = "rg-technologia"
  location            = "centralindia"
}

module "public_ip1" {
  depends_on          = [module.rg]
  source              = "../../modules/azurerm_public_ip"
  publicip_name       = "backend-Public_IP"
  resource_group_name = "rg-technologia"
  location            = "centralindia"
}

module "nsg" {
  depends_on              = [module.rg]
  source                  = "../../modules/azurerm_nsg"
  nsg_name                = "frontend-network-security-group"
  resource_group_name     = "rg-technologia"
  location                = "centralindia"
  destination_port_ranges = ["22", "80"]
  security_rule_name      = "test1"
}

module "nsg1" {
  depends_on              = [module.rg]
  source                  = "../../modules/azurerm_nsg"
  nsg_name                = "backend-network-security-group"
  resource_group_name     = "rg-technologia"
  location                = "centralindia"
  destination_port_ranges = ["22", "8000"]
  security_rule_name      = "test12"
}

module "nic" {
  source                = "../../modules/azurerm_nic"
  nic_name              = "frontend-nic"
  subnet_id             = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Network/virtualNetworks/V-Net/subnets/frontend-subnet"
  location              = "centralindia"
  resource_group_name   = "rg-technologia"
  ip_configuration_name = "configuration1"
  public_ip_address_id  = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Network/publicIPAddresses/frontend-Public_IP"
}

module "nic1" {
  source                = "../../modules/azurerm_nic"
  nic_name              = "backend-nic"
  subnet_id             = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Network/virtualNetworks/V-Net/subnets/backend-subnet"
  location              = "centralindia"
  resource_group_name   = "rg-technologia"
  ip_configuration_name = "configuration2"
  public_ip_address_id  = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Network/publicIPAddresses/backend-Public_IP"
}

module "vm" {
  source                = "../../modules/azurerm_vm"
  vm_name               = "frontend-VM"
  resource_group_name   = "rg-technologia"
  location              = "centralindia"
  size                  = "Standard_B2s"
  computer_name         = "ghost"
  network_interface_ids = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Network/networkInterfaces/frontend-nic"
  os_disk_name          = "frontend-os-disk"
  publisher             = "Canonical"
  offer                 = "0001-com-ubuntu-server-jammy"
  sku                   = "22_04-lts"
  version1              = "latest"
  key_name              = "key-vault-gaming"
  username_secret_key   = "frontend-vm-username"
  pwd_secret_key        = "frontend-vm-pwd"
  custom_data = base64encode(<<EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
  )
}

module "vm1" {
  source                = "../../modules/azurerm_vm"
  vm_name               = "backend-VM"
  resource_group_name   = "rg-technologia"
  location              = "centralindia"
  size                  = "Standard_B2s"
  computer_name         = "ghostkabap"
  network_interface_ids = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Network/networkInterfaces/backend-nic"
  os_disk_name          = "backend-os-disk"
  publisher             = "Canonical"
  offer                 = "0001-com-ubuntu-server-focal"
  sku                   = "20_04-lts"
  version1              = "latest"
  key_name              = "key-vault-gaming"
  username_secret_key   = "backend-vm-username"
  pwd_secret_key        = "backend-vm-pwd"
  custom_data = base64encode(<<EOF
#!/bin/bash
# Update packages
sudo apt update -y

# Install Python 3 and pip
sudo apt install python3 -y
sudo apt install python3-pip -y

# Optional: Upgrade pip to latest version
sudo pip3 install --upgrade pip
EOF
  )
}

module "storage" {
  source              = "../../modules/azurerm_storage_acc"
  storage_name        = "technologiastorageqqqq"
  resource_group_name = "rg-technologia"
  location            = "centralindia"
}

module "container" {
  source = "../../modules/azurerm_blob_container"
  container_name = "technologiacontainer"
  storage_account_id = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-technologia/providers/Microsoft.Storage/storageAccounts/technologiastorageqqqq"
}