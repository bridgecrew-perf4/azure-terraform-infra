location = "northeurope"

suffix = [
  "k0kazpt",
  "dev",
  "testrun"
]

custom_tags = {
  "env" : "dev",
  "customer" : "k0kazpt"
}

default_custom_rules = [
  {
    name                       = "BlockFromInternet"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    description                = "Block all inbound traffic from the Internet!"
  }
]

subnets = {
  public = {
    address_prefixes = ["10.0.0.0/24"]
    nsg_custom_rules = []
    nsg_predefined_rules = [
      {
        name = "HTTP"
        priority = 201
      },
      {
        name = "HTTPS"
        priority = 202
      }
    ]
  }
  private = {
    address_prefixes = ["10.0.1.0/24"]
    nsg_custom_rules = [
      {
        name                       = "BlockToInternet"
        priority                   = 4000
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "Internet"
        destination_port_range     = "*"
        description                = "Block all inbound traffic from the Internet!"
      }
    ]
    nsg_predefined_rules = []
  }
}
