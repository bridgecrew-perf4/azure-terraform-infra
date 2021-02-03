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

module "nsg_pub" {
  source              = "github.com/k0kazpt/_azure-terraform-module-nsg?ref=3.5.0"
  resource_group_name = module.rg.name
  security_group_name = join("-", [module.naming.network_security_group.name, "pub"])
  tags                = var.tags
  custom_rules        = var.custom_rules
  predefined_rules = [
    {
      name     = "HTTP"
      priority = 201
    },
    {
      name     = "HTTPS"
      priority = 202
    }
  ]

  depends_on = [
    module.rg
  ]
}

module "nsg_prv" {
  source              = "github.com/k0kazpt/_azure-terraform-module-nsg?ref=3.5.0"
  resource_group_name = module.rg.name
  security_group_name = join("-", [module.naming.network_security_group.name, "prv"])
  tags                = var.tags
  custom_rules        = var.custom_rules

  depends_on = [
    module.rg
  ]
}

module "vnet" {
  source              = "github.com/k0kazpt/azure-terraform-module-vnet?ref=0.1.4"
  vnet_name           = module.naming.virtual_network.name
  address_space       = ["10.0.0.0/22"]
  resource_group_name = module.rg.name
  subnet_names = [
    "pub",
    "prv"
  ]
  subnet_prefixes = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]
  nsg_ids = {
    pub = module.nsg_pub.network_security_group_id
    prv = module.nsg_prv.network_security_group_id
  }

  custom_tags = var.custom_tags

  depends_on = [
    module.nsg_pub,
    module.nsg_prv
  ]
}
