variable "resource_group_name" {
  type = string
}

variable "administrator_login" {
  type        = string
  description = "sql admin username"
}

variable "administrator_login_password" {
  type        = string
  description = "sql admin password"
}

variable "server_version" {
  type        = string
  description = "version"
}

variable "tls_version" {
  type        = string
  description = "tls version"
}

variable "subnet_name" {
  type        = string
  description = "subnet name for pvt endpoint"
}

variable "vnet_name" {
  type        = string
  description = "vnet name for pvt endpoint"
}

variable "sku" {
  type        = string
  description = "storage tier/sku"
}

variable "collation" {
  type        = string
  description = "collation"
}

variable "replication_type" {
  type        = string
  description = "replication for storage"
}

variable "account_tier" {
  type        = string
  description = "account_tier for storage"
}

variable "azuread_name" {
  type        = string
  description = "azuread_name"
}

variable "ad_object_id" {
  type        = string
  description = "ad_object_id"
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

