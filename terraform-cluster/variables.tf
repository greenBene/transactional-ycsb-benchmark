variable "resource_group_location" {
  type        = string
  description = "Location for all resources."
  default     = "germanywestcentral"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "rg"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "password" {
  type        = string
  description = "The password for the local account that will be created on the new VM."
  default     = "passw0rd!"
}

variable "numer_of_nodes" {
  type        = number
  description = "The number of VM to be created."
  default     = 2
}