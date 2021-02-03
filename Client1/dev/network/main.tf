module "naming" {
  source = "https://github.com/k0kazpt/_azure-terraform-module-naming"
  suffix = var.suffix
}

module "rg" {
  source = "https://github.com/k0kazpt/azure-terraform-module-rg"

  name        = module.naming.resource_group.name
  location    = var.location
  custom_tags = var.custom_tags
}

module "vnet" {
  source = "https://github.com/k0kazpt/azure-terraform-module-vnet"

  name                = module.naming.virtual_netwoek.name
  location            = var.location
  address_space       = ["10.0.1.0/22"]
  resource_group_name = module.rg.name
  subnet_names = [
    "pub",
    "prv"
  ]
  subnet_prefixes = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  custom_tags = var.custom_tags
}
