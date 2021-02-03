variable "suffix" {
  description = "Naming suffix "
  type        = list(string)
  default = [
    "k0kazpt",
    "dev",
    "testrun"
  ]
}

variable "location" {
  description = "Location (Azure region)"
  type        = string
  default     = "northeurope"
}

variable "custom_tags" {
  description = "Custom tags that will be merged with the default tags."
  type        = map(string)
  default = {
    "env" : "dev",
    "customer" : "k0kazpt"
  }
}

variable "tags" {
  description = "Default tags to be added"
  type        = map(string)
  default = {
    "ManagedBy" : "Terraform"
  }
}

variable "custom_rules" {
  description = "Default rules to be applied to NSGs"
  type        = any
  default = [
    {
      name                       = "BlockFromInternet"
      priority                   = 9000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "all"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Block all inbound traffic from the Internet!"
    }
  ]
}
