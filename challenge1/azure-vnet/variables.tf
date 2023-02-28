variable "resource_group_name" {
  type = string
}

variable "subnets" {
  description = "For each subnet, provide subnet name and subnet address prefixs"
  default     = {}
}

variable "address_space_vnet" {
  type = list(any)
}

variable "env" {
  type        = string
  description = "the enviornment name"

}

variable "project_label" {
  type        = string
  description = "the lable name"

}

variable "appname" {
  type        = string
  description = "the short name of the application"

}
