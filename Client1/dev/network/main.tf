module "naming" {
  source = "github.com/k0kazpt/_azure-terraform-module-naming?ref=0.1.0"
  suffix = var.suffix
}

module "rg" {
  source      = "github.com/k0kazpt/azure-terraform-module-rg?ref=0.2.0"
  name        = module.naming.resource_group.name
  location    = var.location
  custom_tags = var.custom_tags
}

module "vnet" {
  source              = "github.com/k0kazpt/azure-terraform-module-vnet?ref=0.2.3"
  name                = module.naming.virtual_network.name
  location            = module.rg.location
  address_space       = var.address_space
  resource_group_name = module.rg.name
  tags                = var.tags
  custom_tags         = var.custom_tags

  depends_on = [
    module.rg
  ]
}

module "nsgs" {
  for_each            = var.subnets
  source              = "github.com/k0kazpt/_azure-terraform-module-nsg?ref=3.5.0"
  resource_group_name = module.rg.name
  security_group_name = join("-", [module.naming.network_security_group.name, each.key])
  tags                = var.tags
  custom_rules        = concat(each.value.nsg_custom_rules, var.default_custom_rules)
  predefined_rules    = concat(each.value.nsg_predefined_rules, var.default_predefined_rules)

  depends_on = [
    module.vnet
  ]
}

module "subnets" {
  for_each                  = var.subnets
  source                    = "github.com/k0kazpt/azure-terraform-module-subnet?ref=0.2.3"
  name                      = each.key
  resource_group_name       = module.rg.name
  virtual_network_name      = module.vnet.name
  address_prefixes          = each.value.address_prefixes
  network_security_group_id = module.nsgs[each.key].network_security_group_id

  depends_on = [
    module.nsgs
  ]
}
