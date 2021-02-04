locals {
  nsg_custom_rules = concat(
    var.default_custom_rules,
    []
  )
  nsg_predefined_rules = concat(
    var.default_predefined_rules,
    [
      {
        name     = "HTTP"
        priority = 201
      },
      {
        name     = "HTTPS"
        priority = 202
      },
      {
        name     = "SMTPS"
        priority = 203
      }
    ]
  )
}

variable "suffix" {
  description = "Naming suffix to be added!"
  type        = list(string)
  default = [
    "example"
  ]
}

variable "location" {
  description = "Location (Azure region)"
  type        = string
  default     = "westeurope"
}

variable "address_space" {
  description = "Address space of the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

variable "custom_tags" {
  description = "Custom tags that will be merged with the default tags."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Default tags to be added"
  type        = map(string)
  default = {
    "ManagedBy" : "Terraform"
  }
}

variable "default_custom_rules" {
  description = "List containing all custom rules that should be applied to all defined NSGs"
  type        = list(any)
  default     = []
}

variable "default_predefined_rules" {
  description = "List containing all predefined rules that should be applied to all defined NSGs"
  type        = list(any)
  default     = []
}

variable "subnets" {
  description = "Map containing subnet info to be passed to corresponding module"
  type        = map(any)
  default = {
    public = {
      address_prefixes     = ["10.0.0.0/24"]
      nsg_custom_rules     = []
      nsg_predefined_rules = []
    }
  }
}
