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
