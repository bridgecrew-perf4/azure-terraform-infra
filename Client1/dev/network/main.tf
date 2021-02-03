module "naming" {
  source = "github.com/k0kazpt/_azure-terraform-module-naming?ref=0.1.0"
  suffix = var.suffix
}

module "rg" {
  source      = "github.com/k0kazpt/azure-terraform-module-rg?ref=0.1.2"
  name        = module.naming.resource_group.name
  location    = var.location
  custom_tags = var.custom_tags
}

module "vnet" {
  source              = "github.com/k0kazpt/azure-terraform-module-vnet?ref=0.1.4"
  vnet_name           = module.naming.virtual_network.name
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
