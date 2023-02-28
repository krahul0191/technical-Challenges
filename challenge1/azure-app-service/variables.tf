variable "resource_group_name" {
  type = string
}

variable "os_type" {
  description = "os type windows or linux"
}

variable "sku_name" {
  type = string
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

variable "vnet_name" {
  type        = string
  description = "vnet name"

}

variable "app_subnet" {
  type        = string
  description = "subnet for the vnet integration"

}

variable "subnet_pvtendpoint" {
  type        = string
  description = "subnet for private endpoint"

}

variable "app_settings" {
  description = "A key-value pair of App Settings for the web app."
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "A key-value pair of site config for the web app."
  type        = any
  default     = {}
}

variable "application_stack" {
  description = "A key-value pair of runtime stack for the web app."
  type        = any
  default     = {}
}